import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kite/services/storage.dart';

part 'read_clusters_provider.g.dart';

@riverpod
class ReadClusters extends _$ReadClusters {
  // Storage key moved to Storage._kReadClustersKey

  @override
  Future<Set<String>> build() async {
    return Storage.getReadClusters();
  }

  /// Marks a cluster as read by its unique [id] and persists the change.
  Future<void> markRead(String id) async {
    final current = state.value ?? <String>{};
    if (current.contains(id)) return;
    final updated = {...current, id};
    state = AsyncData(updated);
    await Storage.setReadClusters(updated);
  }
}
