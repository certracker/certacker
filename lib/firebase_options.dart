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
    apiKey: 'AIzaSyCQDmrezS6tE5Pn9ocC_R5CZ7PtJSog4EA',
    appId: '1:912576608221:web:a4e4a888a1526157f9a834',
    messagingSenderId: '912576608221',
    projectId: 'certracker',
    authDomain: 'certracker.firebaseapp.com',
    storageBucket: 'certracker.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtRjnrk0iYXLrziZToCKUg82-hnw8cxZw',
    appId: '1:912576608221:android:bcf8d6dc6d05bc59f9a834',
    messagingSenderId: '912576608221',
    projectId: 'certracker',
    storageBucket: 'certracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBM7xusxdC9OFw6GUUopky2TMHOjV280Y',
    appId: '1:912576608221:ios:ba745d12fbaa545ef9a834',
    messagingSenderId: '912576608221',
    projectId: 'certracker',
    storageBucket: 'certracker.appspot.com',
    iosBundleId: 'com.example.certracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCBM7xusxdC9OFw6GUUopky2TMHOjV280Y',
    appId: '1:912576608221:ios:38e1a634da4b0548f9a834',
    messagingSenderId: '912576608221',
    projectId: 'certracker',
    storageBucket: 'certracker.appspot.com',
    iosBundleId: 'com.example.certracker.RunnerTests',
  );
}
