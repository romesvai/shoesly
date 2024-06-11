import 'package:shoesly_ps/src/core/exceptions/network_exception.dart';
import 'package:shoesly_ps/src/core/helper/connectivity_checker.dart';

mixin NetworkConnectionMixin {
  Future<void> checkNetworkConnection() async {
    final isConnected = await ConnectivityChecker.isConnected();
    if (!isConnected) throw const NetworkException.connection();
  }
}
