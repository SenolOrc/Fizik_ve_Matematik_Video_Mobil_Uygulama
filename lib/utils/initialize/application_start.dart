import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/utils/initialize/app_cache.dart';

@immutable
class ApplicationStart {
  const ApplicationStart._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    initializeDateFormatting();
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    await AppCache.instance.setup();
  }
}
