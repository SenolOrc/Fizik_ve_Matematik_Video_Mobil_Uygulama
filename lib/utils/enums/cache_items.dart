import 'package:quiz_app/utils/initialize/app_cache.dart';

enum CacheItems {
  token;

  String get read => AppCache.instance.sharedPreferences.getString(name) ?? '';

  Future<bool> write(String value) =>
      AppCache.instance.sharedPreferences.setString(name, value);
}
