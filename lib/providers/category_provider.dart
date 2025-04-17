import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/models/category.dart';

part 'category_provider.g.dart';

const _categoriesUrl = 'https://kite.kagi.com/kite.json';

/// Provider that returns an HTTP client. Convenient to override in tests
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

@riverpod
Future<CategoriesResponse> categories(Ref ref) async {
  final client = ref.read(httpClientProvider);
  final response = await client.get(Uri.parse(_categoriesUrl));
  if (response.statusCode != 200) {
    throw http.ClientException(
      'Failed to load categories',
      Uri.parse(_categoriesUrl),
    );
  }
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return CategoriesResponse.fromJson(json);
}
