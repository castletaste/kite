import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/models/news.dart';
import 'package:kite/providers/category_provider.dart';
import 'package:kite/providers/http_client_provider.dart';
import 'package:kite/services/storage.dart';

part 'news_provider.g.dart';

@riverpod
Future<NewsResponse> categoryNews(Ref ref, String categoryFile) async {
  final client = ref.watch(httpClientProvider);
  final newsUrl = 'https://kite.kagi.com/$categoryFile';

  NewsResponse? cached;
  // Try to read cache first
  final cachedJsonString = Storage.getNewsJson(categoryFile);
  final cachedLastModified = Storage.getNewsLastModified(categoryFile);

  if (cachedJsonString != null) {
    try {
      final cachedJson = jsonDecode(cachedJsonString) as Map<String, dynamic>;
      cached = NewsResponse.fromJson(cachedJson);
    } catch (e) {
      // If the cache is corrupted — ignore it
      debugPrint('cachedJson is corrupted: $e');
    }
  }

  try {
    final response = await client.get(
      Uri.parse(newsUrl),
      headers: {
        if (cachedLastModified != null) 'If-Modified-Since': cachedLastModified,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final bodyString = utf8.decode(response.bodyBytes);
      final jsonMap = jsonDecode(bodyString) as Map<String, dynamic>;
      final news = NewsResponse.fromJson(jsonMap);

      // Save to cache
      await Storage.setNewsJson(categoryFile, bodyString);
      final lastModifiedHeader = response.headers['last-modified'];
      if (lastModifiedHeader != null) {
        await Storage.setNewsLastModified(categoryFile, lastModifiedHeader);
      }

      return news;
    }

    if (response.statusCode == 304 && cached != null) {
      // Data is not changed, return cache
      debugPrint('returning cached news for $categoryFile');
      return cached;
    }

    // Any other abnormal status
    throw http.ClientException(
      'Failed to load news (status: ${response.statusCode}, reason: ${response.reasonPhrase})',
      Uri.parse(newsUrl),
    );
  } on Exception catch (e) {
    debugPrint('error: $e');
    // If there is a network error, try to return the cache, if it exists
    if (cached != null) return cached;
    rethrow;
  }
}

@riverpod
Future<Map<String, AsyncValue<NewsResponse>>> allCategoryNews(Ref ref) async {
  // Get all categories first
  final categoriesAsyncValue = ref.watch(categoriesProvider);

  return categoriesAsyncValue.when(
    data: (categoriesResponse) {
      final Map<String, AsyncValue<NewsResponse>> result = {};

      for (final category in categoriesResponse.categories) {
        // For each category, create an entry with its news provider
        final newsProvider = categoryNewsProvider(category.file);
        result[category.name] = ref.watch(newsProvider);
      }

      return result;
    },
    error: (error, stackTrace) {
      throw Exception('Failed to load categories: $error');
    },
    loading: () {
      // Return empty map while categories are loading
      return {};
    },
  );
}
