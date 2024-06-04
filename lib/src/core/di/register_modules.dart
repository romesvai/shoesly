import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/router/app_router.dart';

@module
abstract class RegisterModules {
  @singleton
  AppRouter get router => AppRouter();
}
