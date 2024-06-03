enum WordWaveTask {
  defaultTask('default'),
  transcript('transcript'),
  translate('translate');

  final String name;
  const WordWaveTask(this.name);

  String toKey() => name.toString();

  static WordWaveTask fromKey(String? state) {
    return WordWaveTask.values.firstWhere(
      (element) => element.toKey() == state,
      orElse: () => WordWaveTask.defaultTask,
    );
  }
}
