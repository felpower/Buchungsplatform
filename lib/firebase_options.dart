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
    apiKey: 'AIzaSyD86C32C-3ppvndyWhB_zkfnVN4td52Zdc',
    appId: '1:870171387832:web:ce9ee169e126e84019114d',
    messagingSenderId: '870171387832',
    projectId: 'esv-steyr',
    authDomain: 'esv-steyr.firebaseapp.com',
    storageBucket: 'esv-steyr.appspot.com',
    measurementId: 'G-280C1262MQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJU6lyT5DIfIe_TtYtGRTMkK65JjHRW_o',
    appId: '1:870171387832:android:3147075792882b7019114d',
    messagingSenderId: '870171387832',
    projectId: 'esv-steyr',
    storageBucket: 'esv-steyr.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkloiOq9ZHD6tGidBnBTuNULRyiuFJcZU',
    appId: '1:870171387832:ios:5448f8b883efa97e19114d',
    messagingSenderId: '870171387832',
    projectId: 'esv-steyr',
    storageBucket: 'esv-steyr.appspot.com',
    iosClientId:
        '870171387832-2665ombqa7di12t6alvtq7t2v0jeglnr.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCkloiOq9ZHD6tGidBnBTuNULRyiuFJcZU',
    appId: '1:870171387832:ios:5448f8b883efa97e19114d',
    messagingSenderId: '870171387832',
    projectId: 'esv-steyr',
    storageBucket: 'esv-steyr.appspot.com',
    iosClientId:
        '870171387832-2665ombqa7di12t6alvtq7t2v0jeglnr.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled',
  );
}
