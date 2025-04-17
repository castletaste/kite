import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/screens/feed.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FeedScreen()),
    ],
  );
}
