import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherConfig {
  late PusherChannelsFlutter _pusher;

  final String appId = '2002846';
  final String apiKEY = '0f818db2b7622218a22a';
  final String secret = '804b44dfbb09822e5245';
  final String apiCLUSTER = 'mt1';

  Future<void> initPusher(
    void Function(PusherEvent event) onEvent, {
    String? channelName,
    int? userId,
    String? token,
  }) async {
    _pusher = PusherChannelsFlutter.getInstance();

    try {
      await _pusher.init(
        apiKey: apiKEY,
        cluster: apiCLUSTER,
        onConnectionStateChange: (currentState, previousState) {
          log('Connection State Change: $previousState → $currentState');

          if (currentState == 'CONNECTED') {
            log('Pusher connected. Attempting to fetch socket ID and subscribe...');
            _subscribeToChannel(channelName, userId, onEvent, token!);
          }
        },
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer: (channelName, socketId, options) async {
          return await authenticatePrivateChannel(channelName, userId, socketId, token!);
        },
      );

      log('Connecting to Pusher...');
      await _pusher.connect();
    } catch (e) {
      log('Error during Pusher initialization: $e');
    }
  }

  Future<void> _subscribeToChannel(
    String? channelName,
    int? userId,
    void Function(PusherEvent event) onEvent,
    String token,
  ) async {
    try {
      var socketId = await fetchSocketId();
      if (socketId == null) {
        log('Socket ID is null. Cannot proceed with subscription.');
        return;
      }

      log('Attempting to subscribe to channel: $channelName with Socket ID: $socketId');

      if (channelName != null && channelName.startsWith('private-')) {
        final authResponse = await authenticatePrivateChannel(channelName, userId!, socketId, token);

        if (authResponse != null && authResponse['auth'] != null) {
          await _pusher.subscribe(channelName: channelName, onEvent: onEvent);
          log('Successfully subscribed to private channel: $channelName');
        } else {
          log('Authentication failed. Could not subscribe to private channel: $channelName');
        }
      } else {
        await _pusher.subscribe(channelName: channelName ?? '', onEvent: onEvent);
        log('Successfully subscribed to public channel: $channelName');
      }
    } catch (e) {
      log('Error during channel subscription: $e');
    }
  }

  Future<String?> fetchSocketId() async {
    String? socketId;
    int retryCount = 0;

    while (socketId == null && retryCount < 5) {
      socketId = await _pusher.getSocketId();
      retryCount++;
    }

    if (socketId == null) {
      log('Failed to fetch Socket ID after multiple attempts.');
    }
    return socketId;
  }

  Future<Map<String, dynamic>?> authenticatePrivateChannel(
    String channelName,
    int? userId,
    String socketId,
    String token,
  ) async {
    try {
      log('Authenticating private channel: $channelName with socket ID: $socketId');

      log('Authorization Token: $token');

      final url = Uri.parse('https://fasakhaninja.com/api/pusher/auth');
      final response = await http.post(
        url,
        body: {'channel_name': channelName, 'socket_id': socketId},
        headers: {'Accept': 'application/json', if (token != '') 'Authorization': 'Bearer $token'},
      );

      log('Authentication API Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        if (responseJson.containsKey('auth')) {
          log("Authentication successful. Auth: ${responseJson['auth']}");
          return {
            'auth': responseJson['auth'],
            // 'channel_data': responseJson['channel_data'] ?? {},
          };
        } else {
          log("Error: Missing 'auth' in the response.");
          return null;
        }
      } else {
        log('Authentication failed. Status Code: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error during authentication: $e');
      return null;
    }
  }

  void disconnectPusher() {
    _pusher.disconnect();
  }

  // Callback Methods
  void onError(String message, int? code, dynamic e) {
    log('Error: $message, Code: $code, Exception: $e');
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log('Successfully subscribed to channel: $channelName with data: $data');
  }

  void onSubscriptionError(String message, dynamic e) {
    log('❌ Subscription Error: $message, Exception: $e');
  }

  void onDecryptionFailure(String event, String reason) {
    log('Decryption failure on event $event: $reason');
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log('Member Added: Channel: $channelName, User: $member');
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log('Member Removed: Channel: $channelName, User: $member');
  }
}
