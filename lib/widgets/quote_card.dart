import 'package:flutter/cupertino.dart';

import 'package:url_launcher/url_launcher.dart';

class QuoteCard extends StatelessWidget {
  final String quote;
  final String? title;
  final String? sourceUrl;
  final String? author;
  final String? sourceDomain;

  const QuoteCard({
    super.key,
    required this.quote,
    this.title,
    this.sourceUrl,
    this.author,
    this.sourceDomain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return GestureDetector(
      onTap: () async {
        if (sourceUrl != null) {
          final success = await launchUrl(Uri.parse(sourceUrl!));
          if (!success || !context.mounted) return;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null && title!.isNotEmpty) ...[
              Text(
                title!,
                style: theme.textTheme.textStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Flexible(
              child: Text(
                quote,
                style: theme.textTheme.textStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            if (author != null && author!.isNotEmpty) ...[
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: author,
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                    if (sourceDomain != null && sourceDomain!.isNotEmpty)
                      TextSpan(
                        text: ' - $sourceDomain',
                        style: theme.textTheme.textStyle.copyWith(
                          fontSize: 12,
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
