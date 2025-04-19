// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing different values in SharedPreferences
const _kCategoriesJsonKey = 'categories_json';
const _kCategoriesLastModifiedKey = 'categories_last_modified';
const _kNewsJsonKeyPrefix = 'news_json_';
const _kNewsLastModifiedKeyPrefix = 'news_last_modified_';
const _kReadClustersKey = 'read_clusters';
const _kLastSelectedCategoryKey = 'last_selected_category';

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
  static String? getCategoriesJson() {
    return _prefs!.getString(_kCategoriesJsonKey);
  }

  /// Saves the categories JSON.
  static Future<void> setCategoriesJson(String json) async {
    await _prefs!.setString(_kCategoriesJsonKey, json);
  }

  /// Returns the value of the `Last-Modified` header for categories.
  static String? getCategoriesLastModified() {
    return _prefs!.getString(_kCategoriesLastModifiedKey);
  }

  /// Saves the value of the `Last-Modified` header for categories.
  static Future<void> setCategoriesLastModified(String value) async {
    await _prefs!.setString(_kCategoriesLastModifiedKey, value);
  }

  /* ----------------------------- News ----------------------------- */

  /// Returns the cached news JSON for a specific category, or `null` if it doesn't exist.
  static String? getNewsJson(String categoryFile) {
    return _prefs!.getString('$_kNewsJsonKeyPrefix$categoryFile');
  }

  /// Saves the news JSON for a specific category.
  static Future<void> setNewsJson(String categoryFile, String json) async {
    await _prefs!.setString('$_kNewsJsonKeyPrefix$categoryFile', json);
  }

  /// Returns the value of the `Last-Modified` header for news of a specific category.
  static String? getNewsLastModified(String categoryFile) {
    return _prefs!.getString('$_kNewsLastModifiedKeyPrefix$categoryFile');
  }

  /// Saves the value of the `Last-Modified` header for news of a specific category.
  static Future<void> setNewsLastModified(
    String categoryFile,
    String value,
  ) async {
    await _prefs!.setString('$_kNewsLastModifiedKeyPrefix$categoryFile', value);
  }

  /// Returns the set of read cluster IDs. Returns an empty set if not found.
  static Set<String> getReadClusters() {
    final list = _prefs!.getStringList(_kReadClustersKey) ?? [];
    return list.toSet();
  }

  /// Saves the set of read cluster IDs.
  static Future<void> setReadClusters(Set<String> clusters) async {
    await _prefs!.setStringList(_kReadClustersKey, clusters.toList());
  }

  /// Returns the last selected category file name, or null if not found.
  static String? getLastSelectedCategory() {
    return _prefs!.getString(_kLastSelectedCategoryKey);
  }

  /// Saves the last selected category file name.
  static Future<void> setLastSelectedCategory(String categoryFile) async {
    await _prefs!.setString(_kLastSelectedCategoryKey, categoryFile);
  }
}
