import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityChecker {
  const ConnectivityChecker._();

  static Future<bool> isConnected() async {
    final result = await InternetConnection().hasInternetAccess;

    return result;
  }

  static Stream<bool> isConnectedStream() {
    return InternetConnection().onStatusChange.map((status) {
      switch (status) {
        case InternetStatus.connected:
          return true;
        case InternetStatus.disconnected:
          return false;
      }
    });
  }
}
