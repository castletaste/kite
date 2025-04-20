import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:universal_image/universal_image.dart';

class ArticleImage extends StatelessWidget {
  final String imageUrl;
  final String caption;
  final String fallbackCaption;

  final bool enableViewer;

  const ArticleImage({
    super.key,
    required this.imageUrl,
    required this.caption,
    this.fallbackCaption = '',

    this.enableViewer = false,
  });

  void _onTap(context) async {
    if (!enableViewer) return;
    unawaited(HapticFeedback.selectionClick());
    await showImageViewer(
      context,
      doubleTapZoomable: true,
      swipeDismissible: true,
      NetworkImage(imageUrl),
      useSafeArea: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _onTap(context),
          child: UniversalImage(
            imageUrl,
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            caption.isNotEmpty ? caption : fallbackCaption,
            style: theme.textTheme.textStyle.copyWith(
              fontSize: 12,
              color: CupertinoColors.inactiveGray,
            ),
          ),
        ),
      ],
    );
  }
}
