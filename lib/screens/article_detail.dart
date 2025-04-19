import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:universal_image/universal_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kite/models/news.dart';
import 'package:kite/widgets/quote_card.dart';
import 'package:kite/widgets/related_articles_section.dart';

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
        trailing: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 42,
            top: 4,
            bottom: 6,
            end: 8,
          ),
          child: AutoSizeText(
            title,
            textAlign: TextAlign.start,
            style: theme.textTheme.navTitleTextStyle.copyWith(fontSize: 14),
            maxLines: 2,
            minFontSize: 10,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            if (cluster.shortSummary != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichText(
                  text: TextSpan(
                    text: cluster.shortSummary!,
                    style: theme.textTheme.textStyle.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
            if (cluster.location != null) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  if (Platform.isIOS || Platform.isMacOS) {
                    final url = 'https://maps.apple.com/?q=${cluster.location}';
                    final success = await launchUrl(Uri.parse(url));
                    if (!success || !context.mounted) return;
                  } else {
                    final url =
                        'https://maps.google.com/?q=${cluster.location}';
                    final success = await launchUrl(Uri.parse(url));
                    if (!success || !context.mounted) return;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.location_solid, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          cluster.location!,
                          style: theme.textTheme.textStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.inactiveGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Display first article image with caption or fallback
            if (cluster.articles != null &&
                cluster.articles!.any(
                  (a) => a.image != null && a.image!.isNotEmpty,
                ))
              Column(
                children: [
                  const SizedBox(height: 24),
                  UniversalImage(
                    cluster.articles!
                        .firstWhere(
                          (a) => a.image != null && a.image!.isNotEmpty,
                        )
                        .image!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      cluster.articles!
                              .firstWhere(
                                (a) => a.image != null && a.image!.isNotEmpty,
                              )
                              .imageCaption ??
                          'Story image',
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 14,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                  ),
                ],
              ),
            if (cluster.quote != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: QuoteCard(
                  quote: cluster.quote!,
                  sourceUrl: cluster.quoteSourceUrl,
                  author: cluster.quoteAuthor!,
                  sourceDomain: cluster.quoteSourceDomain,
                ),
              ),

            // Display second article image with caption or fallback
            if (cluster.articles != null &&
                cluster.articles!
                        .where((a) => a.image != null && a.image!.isNotEmpty)
                        .length >
                    1) ...[
              const SizedBox(height: 12),
              UniversalImage(
                cluster.articles!
                    .where((a) => a.image != null && a.image!.isNotEmpty)
                    .toList()[1]
                    .image!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  cluster.articles!
                          .where((a) => a.image != null && a.image!.isNotEmpty)
                          .toList()[1]
                          .imageCaption ??
                      'Additional story image',
                  style: theme.textTheme.textStyle.copyWith(
                    fontSize: 14,
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
              ),
            ],
            if (cluster.perspectives != null &&
                cluster.perspectives!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Perspectives',
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: cluster.perspectives?.length,

                      itemBuilder: (context, index) {
                        final p = cluster.perspectives![index];
                        final author = p.sources
                            ?.map((e) {
                              return e.name;
                            })
                            .join(', ');
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: QuoteCard(
                            quote: p.text ?? '',
                            author: author,
                            sourceUrl: p.sources?.first.url,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (cluster.historicalBackground != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Historical background',
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      cluster.historicalBackground!,
                      style: theme.textTheme.textStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            if (cluster.internationalReactions != null) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'International reactions',
                  style: theme.textTheme.textStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 8,
                  children:
                      cluster.internationalReactions!
                          .map((r) => QuoteCard(quote: r))
                          .toList(),
                ),
              ),
            ],
            if (cluster.articles != null && cluster.articles!.isNotEmpty) ...[
              RelatedArticlesSection(
                articles: cluster.articles!,
                domains: cluster.domains,
              ),
            ],
            if (cluster.didYouKnow != null) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QuoteCard(
                  title: 'Did you know?',
                  quote: cluster.didYouKnow!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
