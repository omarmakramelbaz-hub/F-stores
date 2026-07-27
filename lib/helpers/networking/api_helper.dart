import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../view/layout/vendor/auth/screen/login_screen.dart';
import '../extension/context_extension.dart';
import '../hive/hive_methods.dart';
import '../routes/app_routers_import.dart';
import '../utils/common_methods.dart';

enum ResponseState { sleep, offline, loading, pagination, complete, error, unauthorized }

class ApiResponse {
  ResponseState state;

  dynamic data;
  ApiResponse({required this.state, required this.data});
}

class ApiHelper {
  static ApiHelper? _instance;

  ApiHelper._();

  static ApiHelper get instance {
    _instance ??= ApiHelper._();

    return _instance!;
  }

  // final String _serverKey = '';

  MediaType appMediaType(String path) {
    List<String> list = '${lookupMimeType(path)}'.split('/');
    return MediaType('${list.firstOrNull}', '${list.lastOrNull}');
  }

  final Dio _dio = Dio()
    ..interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          if (options.path.contains('/posts')) return false;
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    ]);

  Options _options(Map<String, String>? headers, bool hasToken) {
    return Options(
      contentType: 'application/json',
      followRedirects: false,
      validateStatus: (status) {
        return true;
      },
      headers: {
        'Accept': 'application/json',
        //  'Accept-Language': HiveMethods.getLang(),
        'Lang': HiveMethods.getLang(),
        if (HiveMethods.getToken() != null && hasToken) ...{'Authorization': 'Bearer ${HiveMethods.getToken()}'},
        ...?headers,
      },
    );
  }

  Map<String, String> _offlineMessage() {
    return {
      'message': NamedNavigatorImpl.navigatorState.currentContext!.apiTr(
        ar: 'تأكد من الاتصال بالإنترنت',
        en: 'Make sure you are connected to the internet',
      ),
    };
  }

  Map<String, String> _errorMessage() {
    return {'message': NamedNavigatorImpl.navigatorState.currentContext!.apiTr(ar: 'حدث خطأ', en: 'An error occurred')};
  }

  Future<ApiResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    bool hasToken = true,
  }) async {
    ApiResponse responseJson;
    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }

    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
      );
      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(state: ResponseState.error, data: _errorMessage());
      Future.delayed(Duration.zero, onFinish);
    } on SocketException {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    return responseJson;
  }

  Future<ApiResponse> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
  }) async {
    ApiResponse responseJson;

    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    try {
      final response = await _dio.post(
        url,
        queryParameters: queryParameters,
        data: body,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(state: ResponseState.error, data: _errorMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    } on SocketException {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    return responseJson;
  }

  Future<ApiResponse> put(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
  }) async {
    ApiResponse responseJson;

    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    try {
      final response = await _dio.put(
        url,
        queryParameters: queryParameters,
        data: body,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(state: ResponseState.error, data: _errorMessage());
      Future.delayed(Duration.zero, onFinish);
    } on SocketException {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    return responseJson;
  }

  Future<ApiResponse> patch(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
  }) async {
    ApiResponse responseJson;

    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    try {
      final response = await _dio.patch(
        url,
        queryParameters: queryParameters,
        data: body,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(state: ResponseState.error, data: _errorMessage());
      Future.delayed(Duration.zero, onFinish);
    } on SocketException {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    return responseJson;
  }

  Future<ApiResponse> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    bool hasToken = true,
  }) async {
    ApiResponse responseJson;

    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    try {
      final response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: body,
        options: _options(headers, hasToken),
      );
      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(state: ResponseState.error, data: _errorMessage());
      Future.delayed(Duration.zero, onFinish);
    } on SocketException {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    return responseJson;
  }

  Future<ApiResponse> download(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, String>? headers,
    void Function()? onFinish,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    bool hasToken = true,
  }) async {
    ApiResponse responseJson;

    if (await CommonMethods.hasConnection() == false) {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    final fileName = path.basename(url);
    final savePath = await _getFilePath(fileName);
    try {
      final response = await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        data: body,
        options: _options(headers, hasToken),
        onReceiveProgress: onReceiveProgress,
      );
      responseJson = _buildResponse(response);
      Future.delayed(Duration.zero, onFinish);
    } on DioException {
      responseJson = ApiResponse(state: ResponseState.error, data: _errorMessage());
      Future.delayed(Duration.zero, onFinish);
    } on SocketException {
      responseJson = ApiResponse(state: ResponseState.offline, data: _offlineMessage());
      Future.delayed(Duration.zero, onFinish);
      return responseJson;
    }
    return responseJson;
  }

  ApiResponse _buildResponse(Response<dynamic> response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return ApiResponse(state: ResponseState.complete, data: responseJson);
      case 201:
        var responseJson = response.data;
        return ApiResponse(state: ResponseState.complete, data: responseJson);
      case 400:
        var responseJson = response.data;
        return ApiResponse(state: ResponseState.error, data: responseJson);
      case 401:
        var responseJson = response.data;
        Future.delayed(Duration.zero, () {
          NamedNavigatorImpl.navigatorState.currentState?.pushNamedAndRemoveUntil(
            LoginScreen.routeName,
            (route) => false,
          );
        });
        return ApiResponse(state: ResponseState.unauthorized, data: responseJson);
      case 422:
        var responseJson = response.data;
        return ApiResponse(state: ResponseState.error, data: responseJson);
      case 403:
        var responseJson = response.data;
        return ApiResponse(state: ResponseState.error, data: responseJson);
      case 500:
      default:
        var responseJson = response.data;
        return ApiResponse(state: ResponseState.error, data: responseJson);
    }
  }

  Future<String> _getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await path_provider.getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName.pdf';
    return path;
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      'type': 'service_account',
      'project_id': 'fasakhaninjatest',
      'private_key_id': 'a44ba08e526bdad176c1c2a557eeb51a25ff44ff',
      'private_key':
          '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkEhTXsNnfDPBK\neDiaF99c/ZSBofZLoBKh8Zam8sBjvvqAavIE6G3MTZ0ZiXiVQ5KwMk7JBejyPGsW\nDnDn4/8ycszQWuR4Ei0sLIqQ5xOKBjCRFKY0aDc0UK5tcEYTHwJ6y+jS+aLYKTNi\nw1X3cfhMVuWjobaSrTJNMFkcuKNp0N6OH4wnIl4S+8yLTJ8VyxN+Azb/gn7v6CdK\nLPgjj45aG4wEv97/t0bs5trmQRFaUllxtvTC0ZjLqBE4xf+37gGfIz4x36OIERU5\nXVM2vyPNkeqrswe4Crxa6ne3bVYWwSyiVqsJYjoO3JuM58THXAgWHyE2xvNL3WDw\nGF0XxaxzAgMBAAECggEAGxLqwo7p3N83Naqx+GeREbi8jUmrKV6QRI3npMPxEGSe\n1JsRNdMe7zQthN3E+qiMZ6vdiVmCz5o9t4WJhxJ99ZaxCn69Lb0eHCh7cx7WgBO2\nZvJn3MUHuwfHSMLapWQcFiRY1pugDhh6ZMVEBdGWPg6m1UIlrP2Mi+U7BzzGpnqv\nbSagpHRr26+iuZBeAhi0r0cQ8BZ0LCY7OGvgDGXz2Y9svS4no5t4hjVeBs6B/NQz\n6ZHvx6MXZ/XfmiTtigueERCuXzPmxatIhy6t7P2FtlM2VNiIS/zEP7zpI8CWCUPc\no6MhYzl/lQwIJ69lOCSPzeQ+D9Xf6ZzIwbcZ0DNgyQKBgQDmW6GK0FX5/hEGzxvH\nRDa39gUGDhW5QG61r/1cPP4jleiaDlVSiNWbXxFlIfQCYnXB/H3faCfsNNEWNu6a\n8OMs7YuRm1EaujEw0soLLIw5GuLHAXk4BoySJAHXZryDjtLOqoI5iWduTlXnbXFX\nCSmC+UwohlOyeTDJZiRp4Nt3mwKBgQC2VYBvvjIjJac9D4B/UnHEJlEPvVNXp+na\nW9f88vXT1XwerSRsxfeBHi0KYwhCyje8Emh6aGhKkwuvPqpppIlp7dTnMNH57j6f\nX8nUrrtYWZW2Q4dGN9popim3D1/hmgfdLlcEYDPru1PW9nw+DhJT0SHMz775TG0S\nSiYNDp7oCQKBgQDMeHE/ggWOzVHXtWZ2zbm0OI/k/AOUV/jtFLXTdeAvPhUlCav6\ngrL4Ir6SAj1REIxuD+y6rP0i0Q72pPPOXBuJ+aB1MmQfUT3wlGn62SPuXEsHUeuD\nK20DGyr3Q535OIEuKHNHFwvUAXyG28JK+zr5osdTAUixlpkTa7LOuGSWGQKBgGQu\nvIApR9EJ+kbRgq/yc7Hrv7RfOTC7gQFKX3WLZUi8TxNn3NCrQV+/Xc4MNdjE1TTQ\nBHnlbhAzlUL3spiTIDGEzOsuZuDlZ6EX94SVcTiNGHZpyiTpwWaojdkYaH1Drbh4\norUzyrNmXR2Klx9difJlwSWQrAS8Wl2nQhsAgo1JAoGALViHBj2PP5iXn2LeWTlh\nl95ZBxgi3UirMzgbgP9i1JIKzzhygTAf2zI9JQHrs7d/geoMtUn0UmmTez9S1/X7\n74/JtiSp/qslKR0BHziyzTGiI3po8V9sbSjFblWmpC5rbiXDjvVQRmKNcg3+ZvC4\n3t93OhJGY4qMOHhwOTYs+6A=\n-----END PRIVATE KEY-----\n',
      'client_email': 'fasakhaninjatest@fasakhaninjatest.iam.gserviceaccount.com',
      'client_id': '107349182376266401546',
      'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
      'token_uri': 'https://oauth2.googleapis.com/token',
      'auth_provider_x509_cert_url': 'https://www.googleapis.com/oauth2/v1/certs',
      'client_x509_cert_url':
          'https://www.googleapis.com/robot/v1/metadata/x509/fasakhaninjatest%40fasakhaninjatest.iam.gserviceaccount.com',
      'universe_domain': 'googleapis.com',
    };

    /// Only ONE scope needed
    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final httpClient = http.Client();

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      httpClient,
    );

    httpClient.close();
    return credentials.accessToken.data;
  }

  Future<void> sendNotification({
    required String deviceToken,
    required String titleName,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCLoudMessaging = 'https://fcm.googleapis.com/v1/projects/fasakhaninjatest/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {'title': titleName, 'body': body},
        'android': {
          'priority': 'high',
          'notification': {'channel_id': 'high_importance_channel', 'sound': 'custom_sound'}
        },
        'apns': {
          'headers': {'apns-priority': '10'},
          'payload': {
            'aps': {'sound': 'lastSound.wav', 'badge': 1}
          }
        },
        'data': data
      },
    };

    final dio = Dio();
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    ]);

    try {
      final response = await dio.post(
        endpointFirebaseCLoudMessaging,
        data: message,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverAccessTokenKey',
          },
        ),
      );

      if (response.statusCode == 200) {
        // log('notification sent "$deviceToken"');
      } else {
        log('notification not sent ${response.statusCode} -----> "$deviceToken"');
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }
  // Future<void> sendNotification({
  //   required String title,
  //   required String body,
  //   required String to,
  //   Map<String, dynamic>? data,
  //   void Function()? onFinish,
  // }) async {
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=$_serverKey',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{'body': body, 'title': title},
  //           'priority': 'high',
  //           'data': <String, dynamic>{...?data},
  //           'to': to,
  //         },
  //       ),
  //     );
  //     Future.delayed(Duration.zero, onFinish);
  //   } catch (e) {
  //     Future.delayed(Duration.zero, onFinish);
  //     log("error push notification");
  //   }
  // }
}
