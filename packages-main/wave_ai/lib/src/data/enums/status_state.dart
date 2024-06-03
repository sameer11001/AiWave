enum StatusState {
  completed,
  processing,
  failed,
  nothing;

  String toKey() => name.toString();

  static StatusState fromKey(String? state) {
    return StatusState.values.firstWhere(
      (element) => element.toKey() == state,
      orElse: () => StatusState.processing,
    );
  }
}
