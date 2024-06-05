import 'package:shoesly_ps/bootstrap.dart';
import 'package:shoesly_ps/firebase_options.dart';

void main() async {
  await bootstrap(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
