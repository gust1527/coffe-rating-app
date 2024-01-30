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
    apiKey: 'AIzaSyBYdixApjIXPSAZuuWop6-soZGWvp7F-Jw',
    appId: '1:760010668205:web:680e3832a4ce650602ee24',
    messagingSenderId: '760010668205',
    projectId: 'coffe-rating-backend',
    authDomain: 'coffe-rating-backend.firebaseapp.com',
    storageBucket: 'coffe-rating-backend.appspot.com',
    measurementId: 'G-QE8YN529X4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD20LlzCuS1gK4htNj5BMVv8ejPXgMOyHA',
    appId: '1:760010668205:android:b7ed6ca9dc389f1902ee24',
    messagingSenderId: '760010668205',
    projectId: 'coffe-rating-backend',
    storageBucket: 'coffe-rating-backend.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIEVGRkeoVigv4NHBlQOWtbRkTDEQGemI',
    appId: '1:760010668205:ios:7b818b61d2afab2402ee24',
    messagingSenderId: '760010668205',
    projectId: 'coffe-rating-backend',
    storageBucket: 'coffe-rating-backend.appspot.com',
    iosBundleId: 'com.example.coffeRatingAppImpl',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIEVGRkeoVigv4NHBlQOWtbRkTDEQGemI',
    appId: '1:760010668205:ios:13eb4c1cca30080202ee24',
    messagingSenderId: '760010668205',
    projectId: 'coffe-rating-backend',
    storageBucket: 'coffe-rating-backend.appspot.com',
    iosBundleId: 'com.example.coffeRatingAppImpl.RunnerTests',
  );
}