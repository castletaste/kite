import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/models/category.dart';
import 'package:kite/services/storage.dart';

part 'category_provider.g.dart';

const _categoriesUrl = 'https://kite.kagi.com/kite.json';

/// Provider that returns an HTTP client. Convenient to override in tests
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

@riverpod
Future<CategoriesResponse> categories(Ref ref) async {
  final client = ref.read(httpClientProvider);

  // try to read cache first

  final cachedJsonString = await Storage.getCategoriesJson();
  final cachedLastModified = await Storage.getCategoriesLastModified();
  CategoriesResponse? cached;
  if (cachedJsonString != null) {
    try {
      final cachedJson = jsonDecode(cachedJsonString) as Map<String, dynamic>;
      cached = CategoriesResponse.fromJson(cachedJson);
    } catch (_) {
      // If the cache is corrupted — ignore it
    }
  }

  try {
    final response = await client.get(
      Uri.parse(_categoriesUrl),
      headers: {
        if (cachedLastModified != null) 'If-Modified-Since': cachedLastModified,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final categories = CategoriesResponse.fromJson(json);
      // save to cache
      await Storage.setCategoriesJson(response.body);
      final lastModifiedHeader = response.headers['last-modified'];
      if (lastModifiedHeader != null) {
        await Storage.setCategoriesLastModified(lastModifiedHeader);
      }
      return categories;
    }

    if (response.statusCode == 304 && cached != null) {
      // data is not changed, return cache
      return cached;
    }

    // Any other abnormal status
    throw http.ClientException(
      'Failed to load categories (status: \\${response.statusCode})',
      Uri.parse(_categoriesUrl),
    );
  } on Exception catch (_) {
    // If there is a network error, try to return the cache, if it exists
    if (cached != null) return cached;
    rethrow; // if there is no cache — throw the exception further
  }
}
