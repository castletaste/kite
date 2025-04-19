import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kite/models/news.dart';
import 'package:kite/providers/read_clusters_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Cluster cluster;

  const ArticleDetailScreen({super.key, required this.cluster});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final title =
        cluster.emoji == null
            ? cluster.title
            : '${cluster.emoji} ${cluster.title}';
            
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 4, top: 4),
          child: AutoSizeText(
            title,
            textAlign: TextAlign.start,
            style: theme.textTheme.navTitleTextStyle.copyWith(fontSize: 16),
            maxLines: 2,
            minFontSize: 8,
          ),
        ),
        // previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (cluster.shortSummary != null) ...[
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: cluster.shortSummary!,
                  style: theme.textTheme.textStyle.copyWith(fontSize: 16),
                ),
              ),
            ],
            if (cluster.articles != null && cluster.articles!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Related articles',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              ...cluster.articles!.map((article) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: CupertinoListTile(
                    leading:
                        article.image != null
                            ? Image.network(article.image!)
                            : null,
                    title: Text(article.title ?? 'No title'),
                    subtitle:
                        article.domain != null ? Text(article.domain!) : null,
                    // trailing: article.date != null ? Text(article.date!) : null,
                    onTap: () {
                      // TODO: open article URL
                    },
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
