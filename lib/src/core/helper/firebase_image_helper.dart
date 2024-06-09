import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImageHelper {
  FirebaseImageHelper._();

  static Future<String> getDownloadUrl(String imagePath) =>
      FirebaseStorage.instance.ref().child(imagePath).getDownloadURL();
}
