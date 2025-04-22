import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kite/models/category.dart';
import 'package:kite/models/news.dart';
import 'package:kite/providers/read_clusters_provider.dart';
import 'package:kite/screens/on_this_day.dart';

class NewsContentSliver extends ConsumerWidget {
  final AsyncValue<NewsResponse>? newsAsync;
  final Category? selectedCategory;

  const NewsContentSliver({super.key, this.newsAsync, this.selectedCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (newsAsync == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final readIds = ref
        .watch(readClustersProvider)
        .maybeWhen(data: (ids) => ids, orElse: () => <String>{});

    return newsAsync!.when(
      data: (newsResponse) {
        final clusters = newsResponse.news.clusters;
        if (clusters.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('No news for this category')),
            ),
          );
        }
        final sorted =
            clusters..sort((a, b) => readIds.contains(a.id) ? 1 : -1);
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final cluster = sorted[index];
            final isRead = readIds.contains(cluster.id);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                color:
                    isRead
                        ? CupertinoColors.secondarySystemFill
                        : CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
                onPressed: () async {
                  unawaited(HapticFeedback.lightImpact());
                  context.push('/article', extra: cluster);
                  await Future.delayed(
                    const Duration(milliseconds: 400),
                    () => ref
                        .read(readClustersProvider.notifier)
                        .markRead(cluster.id),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: CupertinoCheckbox(
                          value: isRead,
                          onChanged: null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cluster.emoji == null
                              ? cluster.title
                              : '${cluster.emoji}${cluster.title}',
                          style: CupertinoTheme.of(
                            context,
                          ).textTheme.navTitleTextStyle.copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }, childCount: sorted.length),
        );
      },
      error: (error, _) {
        if (selectedCategory?.file == 'onthisday.json') {
          return const SliverFillRemaining(child: OnThisDay());
        }
        debugPrint('News error: $error');
        return const SliverToBoxAdapter(
          child: Center(child: Text('Error loading news')),
        );
      },
      loading:
          () => const SliverFillRemaining(
            child: Center(child: CupertinoActivityIndicator()),
          ),
    );
  }
}
