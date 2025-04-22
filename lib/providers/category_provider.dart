import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/models/category.dart';
import 'package:kite/providers/api_client_provider.dart';
import 'package:kite/services/storage.dart';
import 'package:kite/services/api_urls.dart';

part 'category_provider.g.dart';

@riverpod
Future<CategoriesResponse> categories(Ref ref) async {
  final api = ref.watch(apiClientProvider);

  // try to read cache first

  final cachedJsonString = Storage.getCategoriesJson();
  final cachedLastModified = Storage.getCategoriesLastModified();
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
    final response = await api.getJson(
      categoriesUrl,
      ifModifiedSince: cachedLastModified,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final categories = CategoriesResponse.fromJson(response.data);
      // save to cache
      await Storage.setCategoriesJson(response.rawBody);
      if (response.lastModified != null) {
        await Storage.setCategoriesLastModified(response.lastModified!);
      }
      return categories;
    }

    if (response.statusCode == 304 && cached != null) {
      // data is not changed, return cache
      return cached;
    }

    // Any other abnormal status
    throw http.ClientException(
      'Failed to load categories (status: ${response.statusCode})',
      Uri.parse(categoriesUrl),
    );
  } on Exception catch (_) {
    // If there is a network error, try to return the cache, if it exists
    if (cached != null) return cached;
    rethrow; // if there is no cache — throw the exception further
  }
}
