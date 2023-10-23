// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCzJbAZfO6-0MgaKu7aAJLFNxNmd_xzhjU',
    appId: '1:398647625357:web:e1ce4fb3387bbe4c5604c4',
    messagingSenderId: '398647625357',
    projectId: 'mensageiro-ea074',
    authDomain: 'mensageiro-ea074.firebaseapp.com',
    storageBucket: 'mensageiro-ea074.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpMT_xu349L5aBz9-IiPosb94x_envsVY',
    appId: '1:398647625357:android:70729ed67dd44c6f5604c4',
    messagingSenderId: '398647625357',
    projectId: 'mensageiro-ea074',
    storageBucket: 'mensageiro-ea074.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCln5IlTsLY6rK0_P0_gMmzfso_Dl2_y4',
    appId: '1:398647625357:ios:325b3da9972701635604c4',
    messagingSenderId: '398647625357',
    projectId: 'mensageiro-ea074',
    storageBucket: 'mensageiro-ea074.appspot.com',
    iosBundleId: 'com.example.mensageiro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCln5IlTsLY6rK0_P0_gMmzfso_Dl2_y4',
    appId: '1:398647625357:ios:4e5796368f04c40c5604c4',
    messagingSenderId: '398647625357',
    projectId: 'mensageiro-ea074',
    storageBucket: 'mensageiro-ea074.appspot.com',
    iosBundleId: 'com.example.mensageiro.RunnerTests',
  );
}
