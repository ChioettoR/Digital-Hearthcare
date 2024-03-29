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
    apiKey: 'AIzaSyAdqaPYIAsvYNXCCaHgYnK6iiuUNo835-I',
    appId: '1:610753855101:web:23d07820aae108bc857b14',
    messagingSenderId: '610753855101',
    projectId: 'digital-healthcare-436c5',
    authDomain: 'digital-healthcare-436c5.firebaseapp.com',
    storageBucket: 'digital-healthcare-436c5.appspot.com',
    measurementId: 'G-QJGN68L6EZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKdg4XdhMo-f7BRR3ZZtv4VaFlmzLqnH8',
    appId: '1:610753855101:android:6d54034143e051a5857b14',
    messagingSenderId: '610753855101',
    projectId: 'digital-healthcare-436c5',
    storageBucket: 'digital-healthcare-436c5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDL8HE4P8YywaNrDQrY6FTZkKbHYEaEFuw',
    appId: '1:610753855101:ios:8b3a8c91939515ab857b14',
    messagingSenderId: '610753855101',
    projectId: 'digital-healthcare-436c5',
    storageBucket: 'digital-healthcare-436c5.appspot.com',
    iosClientId: '610753855101-mgq2elcmvatm007j7gab0ska7l7ea182.apps.googleusercontent.com',
    iosBundleId: 'com.example.newDhc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDL8HE4P8YywaNrDQrY6FTZkKbHYEaEFuw',
    appId: '1:610753855101:ios:a8ab4647978923c7857b14',
    messagingSenderId: '610753855101',
    projectId: 'digital-healthcare-436c5',
    storageBucket: 'digital-healthcare-436c5.appspot.com',
    iosClientId: '610753855101-2abd3a7tie310kdc5eia3v81kv5714f1.apps.googleusercontent.com',
    iosBundleId: 'com.example.newDhc.RunnerTests',
  );
}
