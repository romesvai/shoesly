import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shoesly_ps/src/core/router/app_router.dart';

@module
abstract class RegisterModules {
  @singleton
  AppRouter get router => AppRouter();

  @injectable
  FirebaseFirestore get firebaseFireStore => FirebaseFirestore.instance;
}
