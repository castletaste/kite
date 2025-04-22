import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kite/providers/api_client_provider.dart';
import 'package:kite/providers/news_provider.dart';
import 'package:kite/services/api_client.dart';
import 'package:kite/services/storage.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Initialize mock SharedPreferences and register fake fallback values
  SharedPreferences.setMockInitialValues({});
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
  });
  setUp(() async {
    await Storage.init();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  group('categoryNewsProvider', () {
    late _MockHttpClient mockHttpClient;
    late ApiClient apiClient;

    setUp(() {
      mockHttpClient = _MockHttpClient();
      apiClient = ApiClient(client: mockHttpClient);
    });

    test('fetches and caches news on 200 response', () async {
      const categoryFile = 'world.json';
      const url = 'https://kite.kagi.com/world.json';
      const sampleJson = '{"timestamp":1,"clusters":[]}';
      when(
        () =>
            mockHttpClient.get(Uri.parse(url), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async =>
            http.Response(sampleJson, 200, headers: {'last-modified': 'Tue'}),
      );

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(apiClient)],
      );

      final response = await container.read(
        categoryNewsProvider(categoryFile).future,
      );

      expect(response.timestamp, 1);
      expect(response.news.clusters, isEmpty);

      // Verify cache saved
      expect(Storage.getNewsJson(categoryFile), sampleJson);
      expect(Storage.getNewsLastModified(categoryFile), 'Tue');
    });

    test('returns cached news on 304 response', () async {
      const categoryFile = 'world.json';
      const url = 'https://kite.kagi.com/world.json';
      const cachedJson = '{"timestamp":2,"clusters":[{"title":"Test"}]}';

      await Storage.setNewsJson(categoryFile, cachedJson);
      await Storage.setNewsLastModified(categoryFile, 'Wed');

      when(
        () =>
            mockHttpClient.get(Uri.parse(url), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('', 304));

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(apiClient)],
      );

      final response = await container.read(
        categoryNewsProvider(categoryFile).future,
      );

      expect(response.timestamp, 2);
      expect(response.news.clusters.first.title, 'Test');
    });

    test('returns cached news on network error', () async {
      const categoryFile = 'world.json';
      const cachedJson = '{"timestamp":3,"clusters":[]}';

      await Storage.setNewsJson(categoryFile, cachedJson);
      await Storage.setNewsLastModified(categoryFile, 'Thu');

      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenThrow(Exception('network error'));

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(apiClient)],
      );

      final response = await container.read(
        categoryNewsProvider(categoryFile).future,
      );

      expect(response.timestamp, 3);
    });

    test('throws when network error and no cache', () async {
      const categoryFile = 'world.json';
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenThrow(Exception('network error'));

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(apiClient)],
      );

      expect(
        container.read(categoryNewsProvider(categoryFile).future),
        throwsException,
      );
    });
  });
}
