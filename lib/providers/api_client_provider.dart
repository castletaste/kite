import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kite/services/api_client.dart';

/// Provides a singleton ApiClient and disposes it when no longer needed.
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  ref.onDispose(client.dispose);
  return client;
});
