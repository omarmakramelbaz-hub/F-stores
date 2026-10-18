import 'package:connectivity_plus/connectivity_plus.dart';

/// A transport is a connection hint; the request still determines reachability.
bool hasNetworkConnection(Iterable<ConnectivityResult> results) {
  return results.any((result) => result != ConnectivityResult.none);
}
