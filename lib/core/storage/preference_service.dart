import 'package:shared_preferences/shared_preferences.dart';
import 'preference_keys.dart';


class PreferenceService {
  PreferenceService._();

  static late SharedPreferences preferences;

  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  // Is Logged In
  static bool get isLoggedIn =>
      preferences.getBool(PreferenceKeys.isLoggedIn) ?? false;
  static set isLoggedIn(bool value) =>
      preferences.setBool(PreferenceKeys.isLoggedIn, value);

  // Employee ID
  static String? get employeeId =>
      preferences.getString(PreferenceKeys.employeeId);
  static set employeeId(String? value) => value == null
      ? preferences.remove(PreferenceKeys.employeeId)
      : preferences.setString(PreferenceKeys.employeeId, value);

  static Future<void> clearSession() async {
    await preferences.remove(PreferenceKeys.isLoggedIn);
    await preferences.remove(PreferenceKeys.employeeId);
  }
}