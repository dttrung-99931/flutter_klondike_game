extension ListExt on List {
  T? firstWhereOrNull<T>(bool Function(T element) condition) {
    for (final element in this) {
      if (element is T && condition(element)) {
        return element;
      }
    }
    return null;
  }
}
