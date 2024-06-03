enum AIModelType {
  wordWave,
  reserachWave,
  visionWave;

  String toKey() => name.toString().replaceFirst("Wave", "_wave").toLowerCase();

  static AIModelType fromKey(String? key) {
    return AIModelType.values.firstWhere(
      (element) => element.toKey() == key,
    );
  }
}

extension AIModelTypeX on AIModelType {
  List<String>? get allowedFileExtensions {
    switch (this) {
      case AIModelType.wordWave:
        return ["mp4", "mkv", "avi", "mp3", "wav"];
      case AIModelType.visionWave:
        return ["mp4", "mkv", "avi", "mp3", "wav"];
      
      case AIModelType.reserachWave:
        return null;
    }
  }
}
