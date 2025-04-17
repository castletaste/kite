import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kite/extensions/category_emoji.dart';
import 'package:kite/models/category.dart';
import 'package:kite/providers/category_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return CupertinoPageScaffold(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(largeTitle: Text('Kite')),
            categorySelect(context, categories),
            SliverToBoxAdapter(
              child: Container(
                height: 1000,
                color: CupertinoColors.placeholderText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PinnedHeaderSliver categorySelect(
    BuildContext context,
    AsyncValue<CategoriesResponse> categories,
  ) {
    return PinnedHeaderSliver(
      child: categories.maybeWhen(
        data:
            (res) => Container(
              height: 40,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              child: ListView.builder(
                itemCount: res.categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemFill,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${res.categories[index].emoji} ${res.categories[index].name}',
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                    ),
                  );
                },
              ),
            ),
        error: (err, st) => Text(err.toString()),
        orElse: () => CupertinoActivityIndicator(),
      ),
    );
  }
}
