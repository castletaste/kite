/// Provides an extension on Iterable to return the first element matching the test or null if none is found.
extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// Returns the first element that satisfies [test], or null if no such element exists.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
