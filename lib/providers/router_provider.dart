import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/models/news.dart';
import 'package:kite/screens/article_detail.dart';
import 'package:kite/screens/feed.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const FeedScreen()),
      GoRoute(
        path: '/article',
        pageBuilder: (context, state) {
          late final Cluster cluster;
          if (state.extra is Cluster) {
            cluster = state.extra as Cluster;
          } else if (state.extra is Map<String, dynamic>) {
            cluster = Cluster.fromJson(state.extra as Map<String, dynamic>);
          } else {
            throw Exception(
              'Unexpected type for state.extra: ${state.extra.runtimeType}',
            );
          }
          return CustomTransitionPage(
            key: state.pageKey,
            fullscreenDialog: false,
            child: ArticleDetailScreen(cluster: cluster),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: false,
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
