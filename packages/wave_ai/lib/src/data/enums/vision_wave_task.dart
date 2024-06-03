/// enum for vision task (detect , pose , seg).
/// by default the return from this enum is (detect)
enum VisionWaveTask {
  detect('detect'),
  pose('pose'),
  segment('seg');

  const VisionWaveTask(this.name);
  final String name;

  String toKey() => name.toString();

  static VisionWaveTask fromKey(String key) {
    return VisionWaveTask.values.firstWhere(
      (element) => element.toKey() == key,
      orElse: () => VisionWaveTask.detect,
    );
  }
}
