import 'package:flutter/cupertino.dart';
import 'package:universal_image/universal_image.dart';

import 'package:kite/models/news.dart';
import 'package:kite/widgets/related_article_tile.dart';

class RelatedArticlesSection extends StatefulWidget {
  final List<Article> articles;
  final List<Domain>? domains;

  const RelatedArticlesSection({
    super.key,
    required this.articles,
    this.domains,
  });

  @override
  State<RelatedArticlesSection> createState() => _RelatedArticlesSectionState();
}

class _RelatedArticlesSectionState extends State<RelatedArticlesSection> {
  bool showAllSources = false;
  final Set<String> expandedDomains = {};

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    // Group articles by domain
    final Map<String, List<Article>> grouped = {};
    for (var article in widget.articles) {
      final domainName = article.domain ?? 'Unknown';
      grouped.putIfAbsent(domainName, () => []).add(article);
    }
    final domainEntries = grouped.entries.toList();
    const initialCount = 3;
    final displayedEntries =
        showAllSources
            ? domainEntries
            : domainEntries.take(initialCount).toList();

    // Header styled with Cupertino navigation title style
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        'Related Articles',
        style: theme.textTheme.navTitleTextStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Build grouped sections using CupertinoListSection for each domain
    final sections =
        displayedEntries.map((entry) {
          final domainName = entry.key;
          final articles = entry.value;
          final isExpanded = expandedDomains.contains(domainName);
          final faviconUrl =
              widget.domains
                  ?.firstWhere(
                    (d) => d.name == domainName,
                    orElse: () => Domain(),
                  )
                  .url;
          return CupertinoListSection.insetGrouped(
            header: GestureDetector(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    expandedDomains.remove(domainName);
                  } else {
                    expandedDomains.add(domainName);
                  }
                });
              },
              child: Row(
                children: [
                  if (faviconUrl != null) ...[
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.systemBackground,
                      ),
                      child: UniversalImage(faviconUrl, width: 20, height: 20),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      domainName,
                      style: theme.textTheme.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    color: theme.textTheme.textStyle.color,
                    size: 20,
                  ),
                ],
              ),
            ),
            children: [
              if (isExpanded)
                ...articles.map(
                  (article) => RelatedArticleTile(
                    article: article,
                    domains: widget.domains,
                  ),
                ),
            ],
          );
        }).toList();

    // Show more/less button
    final showMoreButton =
        domainEntries.length > initialCount
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed:
                    () => setState(() => showAllSources = !showAllSources),
                child: Text(
                  showAllSources ? 'Show less' : 'Show more',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            )
            : const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header, ...sections, showMoreButton],
    );
  }
}
