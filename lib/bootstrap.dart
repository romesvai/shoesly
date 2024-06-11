import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoesly_ps/src/app/app.dart';
import 'package:shoesly_ps/src/core/constants/hive_keys.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/features/cart/domain/model/cart_item_data_model.dart';

Future<void> bootstrap({required FirebaseOptions firebaseOptions}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  await configureInjection();
  final storageDir = await getApplicationSupportDirectory();

  await _initializeHive(storageDir.path);
  runApp(const App());
}

Future<void> _initializeHive(String storagePath) async {
  Hive.init(storagePath);
  registerHiveAdapters();

  await Hive.openBox<CartItemDataModel>(
    hiveCartKey,
  );
}

void registerHiveAdapters() {
  Hive.registerAdapter(
    CartItemDataModelAdapter(),
  );
}
