import 'package:flutter/material.dart';
import 'package:shoesly_ps/src/app/app.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  runApp(const App());
}
