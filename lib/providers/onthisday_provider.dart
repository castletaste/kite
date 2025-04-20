import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:kite/models/onthisday.dart';
import 'package:kite/providers/http_client_provider.dart';

// Manual FutureProvider for OnThisDay events, avoiding code generation
final onThisDayProvider = FutureProvider<OnThisDayResponse>((ref) async {
  final client = ref.watch(httpClientProvider);
  const url = 'https://kite.kagi.com/onthisday.json';
  try {
    final response = await client.get(Uri.parse(url));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = utf8.decode(response.bodyBytes);
      final jsonMap = jsonDecode(body) as Map<String, dynamic>;
      return OnThisDayResponse.fromJson(jsonMap);
    }
    throw http.ClientException(
      'Failed to load events (status: ${response.statusCode})',
      Uri.parse(url),
    );
  } on Exception catch (e) {
    debugPrint('onThisDay fetch error: $e');
    rethrow;
  }
});
