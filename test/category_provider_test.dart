import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kite/models/category.dart';
import 'package:kite/providers/api_client_provider.dart';
import 'package:kite/providers/category_provider.dart';
import 'package:kite/services/api_client.dart';
import 'package:kite/services/storage.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUpAll(() async {
    registerFallbackValue(Uri());
    registerFallbackValue(<String, String>{});
    await Storage.init();
  });

  const url = 'https://kite.kagi.com/kite.json';
  late _MockHttpClient mockClient;

  const sampleJson = '''
  {
    "timestamp": 123456789,
    "categories": [
      { "name": "World", "file": "world.json" },
      { "name": "Tech", "file": "tech.json" }
    ]
  }
  ''';

  setUp(() async {
    mockClient = _MockHttpClient();
    // Clear any cached data between tests
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  test('categoriesProvider fetches and parses categories', () async {
    when(
      () => mockClient.get(Uri.parse(url), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(sampleJson, 200));

    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(client: mockClient)),
      ],
    );

    final response = await container.read(categoriesProvider.future);

    expect(response.timestamp, 123456789);
    expect(response.categories.length, 2);
    expect(
      response.categories.first,
      const Category(name: 'World', file: 'world.json'),
    );
  });

  test('categoriesProvider throws on non‑200 status', () async {
    when(
      () => mockClient.get(Uri.parse(url), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('error', 500));

    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(client: mockClient)),
      ],
    );

    expect(container.read(categoriesProvider.future), throwsException);
  });
}
