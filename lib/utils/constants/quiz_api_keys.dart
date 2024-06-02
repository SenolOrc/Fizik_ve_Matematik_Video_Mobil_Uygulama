import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static final String? iosFirebaseApi = dotenv.env["FIREBASE_IOS_API_KEY"];
  static final String? androidFirebaseApi = dotenv.env["FIREBASE_ANDROID_API_KEY"];
  static final String? macosFirebaseApi = dotenv.env["FIREBASE_MACOS_API_KEY"];
  static final String? webFirebaseApi = dotenv.env["FIREBASE_WEB_API_KEY"];
}
