// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing different values in SharedPreferences
const _kCategoriesJsonKey = 'categories_json';
const _kCategoriesLastModifiedKey = 'categories_last_modified';

class Storage {
  static SharedPreferences? _prefs;
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences?> init() async {
    _prefs = await _instance;
    return _prefs;
  }

  /* ----------------------------- Categories ----------------------------- */

  /// Returns the cached JSON as a string, or `null` if it doesn't exist.
  static Future<String?> getCategoriesJson() async {
    final prefs = await _instance;
    return prefs.getString(_kCategoriesJsonKey);
  }

  /// Saves the categories JSON.
  static Future<void> setCategoriesJson(String json) async {
    final prefs = await _instance;
    await prefs.setString(_kCategoriesJsonKey, json);
  }

  /// Returns the value of the `Last-Modified` header for categories.
  static Future<String?> getCategoriesLastModified() async {
    final prefs = await _instance;
    return prefs.getString(_kCategoriesLastModifiedKey);
  }

  /// Saves the value of the `Last-Modified` header for categories.
  static Future<void> setCategoriesLastModified(String value) async {
    final prefs = await _instance;
    await prefs.setString(_kCategoriesLastModifiedKey, value);
  }
}
