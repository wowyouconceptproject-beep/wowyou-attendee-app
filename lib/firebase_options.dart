
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase web configuration is not available.',
      );
    }

    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKYIZRxuFdgHWNWrchilRDb3bLLf8NIA8',
    appId: '1:437698238988:android:d81fd6ef89d12a6c56ec29',
    messagingSenderId: '437698238988',
    projectId: 'wowyou-eventtech',
    storageBucket: 'wowyou-eventtech.firebasestorage.app',
  );
}
