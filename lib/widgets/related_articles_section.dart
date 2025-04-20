import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kite/models/news.dart';
import 'package:kite/widgets/related_article_tile.dart';

class RelatedArticlesSection extends StatelessWidget {
  final List<Article> articles;
  final List<Domain>? domains;

  const RelatedArticlesSection({super.key, required this.articles, this.domains});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Related articles',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(height: 8),
        ...articles.map(
          (article) => RelatedArticleTile(article: article, domains: domains),
        ),
      ],
    );
  }
}
