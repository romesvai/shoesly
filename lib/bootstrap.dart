import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoesly_ps/src/app/app.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';

Future<void> bootstrap({required FirebaseOptions firebaseOptions}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  await configureInjection();
  runApp(const App());
}
