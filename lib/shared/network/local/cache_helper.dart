import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache_Helper {
  static SharedPreferences sharedPreferences =
      SharedPreferences as SharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);

    return await sharedPreferences.setDouble(key, value);
  }

  static Future<bool> removeData({required String key}) {
    return sharedPreferences.remove(key);
  }
}
