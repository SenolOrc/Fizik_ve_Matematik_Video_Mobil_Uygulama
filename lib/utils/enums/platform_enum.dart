import 'dart:io';

enum PlatformEnum {
  ios,
  android;

  static String get currentPlatform {
    if (Platform.isAndroid) return PlatformEnum.android.name;
    if (Platform.isIOS) return PlatformEnum.ios.name;
    throw Exception('Platform cannot detected!');
  }
}
