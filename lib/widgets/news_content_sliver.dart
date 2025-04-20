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

    return SliverToBoxAdapter(
      child: newsAsync!.when(
        data: (newsResponse) {
          final news = newsResponse.news;
          if (news.clusters.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No news for this category'),
              ),
            );
          }
          // Sort clusters: unread first, then read using unique IDs
          final clusters = news.clusters;
          final sortedClusters =
              clusters..sort((a, b) => readIds.contains(a.id) ? 1 : -1);

          return Column(
            children: List.generate(sortedClusters.length, (index) {
              final cluster = sortedClusters[index];

              final isRead = readIds.contains(cluster.id);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color:
                      isRead
                          ? CupertinoColors.secondarySystemFill
                          : CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                  alignment: Alignment.bottomCenter,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navTitleTextStyle
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
        error: (error, _) {
          if (selectedCategory?.file == 'onthisday.json') {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: const OnThisDay(),
            );
          }
          debugPrint('News error: $error');
          return Center(child: Text('Error loading news: $error'));
        },
        loading:
            () => SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height,
              child: Center(child: CupertinoActivityIndicator()),
            ),
      ),
    );
  }
}
