import 'package:shared_preferences/shared_preferences.dart';

// class Preferences {
//   static final Preferences _instance = Preferences._();
//
//   factory Preferences() {
//     return _instance;
//   }
//
//   Preferences._();
//
//   static Preferences get instance => _instance;
//   SharedPreferences? prefs;
//
//   static String firstTimeOpen = 'isFirstTimeOpen';
//
//   Future<void> initialAppPreference() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   Future setFirstTimeOpen(bool value) async {
//     await prefs?.setBool(firstTimeOpen, value);
//   }
//
//   bool getFirstTimeOpen() {
//     return prefs?.getBool(firstTimeOpen) ?? false;
//   }
//
//   void clearSharedPreferences() {
//     prefs?.clear();
//   }
// }

class AppPreference {
  static late SharedPreferences _prefs;

  static Future initMySharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void clearSharedPreferences(String value) {
    _prefs.remove(value);
    return;
  }

  // static const String theme = "theme";

  ///-------------
  static Future setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String getString(String key) {
    final String? value = _prefs.getString(key);
    return value ?? "";
  }

  static Future setBoolean(String key, {required bool value}) async {
    await _prefs.setBool(key, value);
  }

  static bool getBoolean(String key) {
    final bool? value = _prefs.getBool(key);
    return value ?? false;
  }

  static Future setLong(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  static double getLong(String key) {
    final double? value = _prefs.getDouble(key);
    return value ?? 0.0;
  }

  static Future setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int getInt(String key) {
    final int? value = _prefs.getInt(key);
    return value ?? 0;
  }

  static Future setInComingKeyword(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String getInComingKeyword(String key) {
    final String? value = _prefs.getString(key);
    return value ?? "";
  }
}
