import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kite/models/category.dart';
import 'package:kite/widgets/category_selector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CategorySelector shows data and reacts to tap', (tester) async {
    final categories = [
      Category(name: 'World', file: 'world.json'),
      Category(name: 'Custom', file: 'custom.json'),
    ];
    final categoriesResponse = CategoriesResponse(
      timestamp: 0,
      categories: categories,
    );
    Category? selected;

    await tester.pumpWidget(
      CupertinoApp(
        home: CustomScrollView(
          slivers: [
            CategorySelector(
              categories: AsyncValue.data(categoriesResponse),
              selectedCategory: categories[0],
              onCategorySelected: (c) => selected = c,
            ),
          ],
        ),
      ),
    );

    expect(find.text('🌍 World'), findsOneWidget);
    expect(find.text('📰 Custom'), findsOneWidget);

    await tester.tap(find.text('📰 Custom'));
    expect(selected, equals(categories[1]));
  });

  testWidgets('CategorySelector shows no items when loading', (tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: CustomScrollView(
          slivers: [
            CategorySelector(
              categories: const AsyncValue<CategoriesResponse>.loading(),
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ],
        ),
      ),
    );

    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('CategorySelector shows no items when error', (tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: CustomScrollView(
          slivers: [
            CategorySelector(
              categories: AsyncValue.error('error', StackTrace.empty),
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ],
        ),
      ),
    );

    expect(find.byType(ListView), findsNothing);
  });
}
