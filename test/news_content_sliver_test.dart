import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kite/models/category.dart';
import 'package:kite/models/news.dart';
import 'package:kite/widgets/news_content_sliver.dart';
import 'package:kite/screens/on_this_day.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final someCategory = Category(name: 'World', file: 'world.json');
  final onThisDayCategory = Category(name: 'OnThisDay', file: 'onthisday.json');

  testWidgets('loading state shows activity indicator', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: CupertinoApp(
          home: CustomScrollView(
            slivers: [
              NewsContentSliver(
                newsAsync: const AsyncValue<NewsResponse>.loading(),
                selectedCategory: someCategory,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets('empty clusters show no news message', (tester) async {
    final newsResponse = NewsResponse(timestamp: 0, news: News(clusters: []));

    await tester.pumpWidget(
      ProviderScope(
        child: CupertinoApp(
          home: CustomScrollView(
            slivers: [
              NewsContentSliver(
                newsAsync: AsyncValue.data(newsResponse),
                selectedCategory: someCategory,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('No news for this category'), findsOneWidget);
  });

  testWidgets('data state shows clusters list', (tester) async {
    final cluster = Cluster(title: 'TestTitle');
    final newsResponse = NewsResponse(
      timestamp: 1,
      news: News(clusters: [cluster]),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: CupertinoApp(
          home: CustomScrollView(
            slivers: [
              NewsContentSliver(
                newsAsync: AsyncValue.data(newsResponse),
                selectedCategory: someCategory,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TestTitle'), findsOneWidget);
  });

  testWidgets('error state shows retry button and message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: CupertinoApp(
          home: CustomScrollView(
            slivers: [
              NewsContentSliver(
                newsAsync: AsyncValue.error('err', StackTrace.empty),
                selectedCategory: someCategory,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Error loading news'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('error state on onthisday shows OnThisDay widget', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: CupertinoApp(
          home: CustomScrollView(
            slivers: [
              NewsContentSliver(
                newsAsync: AsyncValue.error('err', StackTrace.empty),
                selectedCategory: onThisDayCategory,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(OnThisDay), findsOneWidget);
  });
}
