extension ListExtension<T> on List<T> {
  List<T> search(String query, String Function(T) getPrimary, [String Function(T)? getSecondary]) {
    if (query.isEmpty) return this; // Return the original list if the query is empty.

    final lowerQuery = query.toLowerCase();
    return where((item) {
      final primaryMatch = getPrimary(item).toLowerCase().contains(lowerQuery);
      final secondaryMatch = getSecondary?.call(item).toLowerCase().contains(lowerQuery) ?? false;
      return primaryMatch || secondaryMatch;
    }).toList();
  }

  String get conversationId {
    final ids = map((e) => e ?? -1).toList()..sort();
    return ids.join('_');
  }
}

