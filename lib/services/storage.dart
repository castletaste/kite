// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing different values in SharedPreferences
const _kCategoriesJsonKey = 'categories_json';
const _kCategoriesLastModifiedKey = 'categories_last_modified';
const _kNewsJsonKeyPrefix = 'news_json_';
const _kNewsLastModifiedKeyPrefix = 'news_last_modified_';

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

  /* ----------------------------- News ----------------------------- */

  /// Returns the cached news JSON for a specific category, or `null` if it doesn't exist.
  static Future<String?> getNewsJson(String categoryFile) async {
    final prefs = await _instance;
    return prefs.getString('$_kNewsJsonKeyPrefix$categoryFile');
  }

  /// Saves the news JSON for a specific category.
  static Future<void> setNewsJson(String categoryFile, String json) async {
    final prefs = await _instance;
    await prefs.setString('$_kNewsJsonKeyPrefix$categoryFile', json);
  }

  /// Returns the value of the `Last-Modified` header for news of a specific category.
  static Future<String?> getNewsLastModified(String categoryFile) async {
    final prefs = await _instance;
    return prefs.getString('$_kNewsLastModifiedKeyPrefix$categoryFile');
  }

  /// Saves the value of the `Last-Modified` header for news of a specific category.
  static Future<void> setNewsLastModified(
    String categoryFile,
    String value,
  ) async {
    final prefs = await _instance;
    await prefs.setString('$_kNewsLastModifiedKeyPrefix$categoryFile', value);
  }
}
