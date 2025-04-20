import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/widgets/extensions/first_where_or_null.dart';
import 'package:universal_image/universal_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kite/models/news.dart';

class RelatedArticleTile extends StatelessWidget {
  final Article article;
  final List<Domain>? domains;

  const RelatedArticleTile({super.key, required this.article, this.domains});

  @override
  Widget build(BuildContext context) {
    final favicon =
        domains?.firstWhereOrNull((d) => d.name == article.domain)?.url;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CupertinoListTile(
        leading:
            favicon != null
                ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: UniversalImage(favicon, width: 64, height: 64),
                )
                : const SizedBox.shrink(),
        title: Text(article.title ?? 'No title'),
        subtitle: article.domain != null ? Text(article.domain!) : null,
        onTap: () async {
          unawaited(HapticFeedback.selectionClick());
          final url = article.link;
          if (url == null || url.isEmpty) return;
          await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
        },
      ),
    );
  }
}
