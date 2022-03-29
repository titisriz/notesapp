// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDOXXpl5qSVh-wHSgBbFpcIMxcORYO5WLE',
    appId: '1:394200727902:web:7626b70c4654593ccf0fcf',
    messagingSenderId: '394200727902',
    projectId: 'note-app-2f2b3',
    authDomain: 'note-app-2f2b3.firebaseapp.com',
    storageBucket: 'note-app-2f2b3.appspot.com',
    measurementId: 'G-T8CWB6MMEE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBulywYkFtq3ncynqf6uTiTCziSXZRI4Ww',
    appId: '1:394200727902:android:d3df0d300b449d53cf0fcf',
    messagingSenderId: '394200727902',
    projectId: 'note-app-2f2b3',
    storageBucket: 'note-app-2f2b3.appspot.com',
  );
}
