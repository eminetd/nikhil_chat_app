// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAqFbudQ-DoM3D6Pt0RM6DLNE37iY4V-YM',
    appId: '1:627800327489:web:8fa627012bec3c6f318dc0',
    messagingSenderId: '627800327489',
    projectId: 'chat-app-1eaf1',
    authDomain: 'chat-app-1eaf1.firebaseapp.com',
    storageBucket: 'chat-app-1eaf1.appspot.com',
    measurementId: 'G-1KGWDFEPS6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5wtJH4O4Br6seiQUgzhaZUhMtwv5rtS4',
    appId: '1:627800327489:android:2d6d8053b5e3a653318dc0',
    messagingSenderId: '627800327489',
    projectId: 'chat-app-1eaf1',
    storageBucket: 'chat-app-1eaf1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6tmrLr6i1oRtq2c3eBuYlgWp-CZPEdCE',
    appId: '1:627800327489:ios:44b3242adeadd727318dc0',
    messagingSenderId: '627800327489',
    projectId: 'chat-app-1eaf1',
    storageBucket: 'chat-app-1eaf1.appspot.com',
    iosBundleId: 'com.example.chatApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6tmrLr6i1oRtq2c3eBuYlgWp-CZPEdCE',
    appId: '1:627800327489:ios:44b3242adeadd727318dc0',
    messagingSenderId: '627800327489',
    projectId: 'chat-app-1eaf1',
    storageBucket: 'chat-app-1eaf1.appspot.com',
    iosBundleId: 'com.example.chatApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAqFbudQ-DoM3D6Pt0RM6DLNE37iY4V-YM',
    appId: '1:627800327489:web:53a61a9d2b315415318dc0',
    messagingSenderId: '627800327489',
    projectId: 'chat-app-1eaf1',
    authDomain: 'chat-app-1eaf1.firebaseapp.com',
    storageBucket: 'chat-app-1eaf1.appspot.com',
    measurementId: 'G-H6MSNP5898',
  );

}