import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kite/models/news.dart';
import 'package:kite/providers/read_clusters_provider.dart';
import 'package:go_router/go_router.dart';

class NewsContentSliver extends ConsumerWidget {
  final AsyncValue<NewsResponse>? newsAsync;

  const NewsContentSliver({super.key, this.newsAsync});

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
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: news.clusters.length,
            itemBuilder: (context, index) {
              final cluster = news.clusters[index];
              final id = cluster.quoteSourceUrl ?? cluster.title;
              final isRead = readIds.contains(id);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () async {
                    await Future.wait([
                      ref.read(readClustersProvider.notifier).markRead(id),
                      context.push('/article', extra: cluster),
                    ]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1,
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
            },
          );
        },
        error: (error, _) {
          print('News error: $error');
          return Center(child: Text('Error loading news: $error'));
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
