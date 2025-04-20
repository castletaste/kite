import 'package:flutter/cupertino.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kite/providers/onthisday_provider.dart';

class OnThisDay extends ConsumerStatefulWidget {
  const OnThisDay({super.key});

  @override
  ConsumerState<OnThisDay> createState() => _OnThisDayScreenState();
}

class _OnThisDayScreenState extends ConsumerState<OnThisDay> {
  @override
  Widget build(BuildContext context) {
    final onThisAsync = ref.watch(onThisDayProvider);

    return Column(
      children: [
        onThisAsync.when(
          data: (resp) {
            final list =
                resp.events.where((e) => e.type == 'event').toList()
                  ..sort((a, b) => b.sortYear.compareTo(a.sortYear));

            // Vertical timeline
            return Column(
              children: List.generate(list.length, (index) {
                final e = list[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: CupertinoColors.activeGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (index != list.length - 1)
                            Container(
                              width: 2,
                              height: 60,
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.year,
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Html(data: e.content),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ],
    );
  }
}
