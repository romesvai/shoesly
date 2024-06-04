import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/di/injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: 'initGetIt')
Future<void> configureInjection() async {
  getIt.initGetIt();
}
