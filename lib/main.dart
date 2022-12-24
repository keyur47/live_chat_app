import 'dart:developer';

import 'package:chat_app/app/live_call_app.dart';
import 'package:chat_app/core/constants/preferences.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await AppPreference.initMySharedPreferences();

    /// send notificatin
    // await FireBaseNotification().initializeNotification();
    runApp(const LiveCallApp());
  } catch (e, st) {
    log("error in main =======$e ========$st");
  }
}
