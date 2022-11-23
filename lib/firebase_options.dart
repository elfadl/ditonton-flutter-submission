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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBEGIQADiOjWMGoivBrevKPTJkJL6RFMYA',
    appId: '1:421990200489:web:130a34623bdb8eed86e5b8',
    messagingSenderId: '421990200489',
    projectId: 'ditonton-elfastudio',
    authDomain: 'ditonton-elfastudio.firebaseapp.com',
    storageBucket: 'ditonton-elfastudio.appspot.com',
    measurementId: 'G-9Q3GE4KWGD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnUES5YbR8iCYjJB5u7n5Wdv7ldZggDNw',
    appId: '1:421990200489:android:1c4182fe98168b4686e5b8',
    messagingSenderId: '421990200489',
    projectId: 'ditonton-elfastudio',
    storageBucket: 'ditonton-elfastudio.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKea9Ng29-WYMcrh89jGFfTmTm3LxZHhI',
    appId: '1:421990200489:ios:ce36ee57f0b867c186e5b8',
    messagingSenderId: '421990200489',
    projectId: 'ditonton-elfastudio',
    storageBucket: 'ditonton-elfastudio.appspot.com',
    iosClientId: '421990200489-9vn874bloch1gb0s5gbn0c1isc0l20rd.apps.googleusercontent.com',
    iosBundleId: 'com.dicoding.ditonton',
  );
}