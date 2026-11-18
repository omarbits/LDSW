// Generated for the Filmapp Firebase project.
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'Firebase no está configurado para esta plataforma. '
      'Configura Android o iOS con FlutterFire.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwFUlIxOk5ISzouYwDR88epqXPjQn4yL4',
    appId: '1:318403268658:web:412bdf3d4a98b3fa646c2b',
    messagingSenderId: '318403268658',
    projectId: 'filmapp-7b7fa',
    authDomain: 'filmapp-7b7fa.firebaseapp.com',
    storageBucket: 'filmapp-7b7fa.firebasestorage.app',
  );
}
