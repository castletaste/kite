import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import 'package:kite/models/category.dart';
import 'package:kite/providers/category_provider.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
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

  setUp(() {
    mockClient = _MockHttpClient();
  });

  test('categoriesProvider fetches and parses categories', () async {
    when(
      () => mockClient.get(Uri.parse(url)),
    ).thenAnswer((_) async => http.Response(sampleJson, 200));

    final container = ProviderContainer(
      overrides: [httpClientProvider.overrideWithValue(mockClient)],
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
      () => mockClient.get(Uri.parse(url)),
    ).thenAnswer((_) async => http.Response('error', 500));

    final container = ProviderContainer(
      overrides: [httpClientProvider.overrideWithValue(mockClient)],
    );

    expect(container.read(categoriesProvider.future), throwsException);
  });
}
