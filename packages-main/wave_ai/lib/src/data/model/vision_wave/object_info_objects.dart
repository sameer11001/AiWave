class DetectedObject {
  final int id;
  String firstDetectTime;
  String lastDetectTime;
  String objectName;

  DetectedObject({
    required this.id,
    required this.firstDetectTime,
    required this.lastDetectTime,
    required this.objectName,
  });

  factory DetectedObject.fromMap(int id, Map<String, dynamic> json) {
    return DetectedObject(
      id: id,
      firstDetectTime: json['first_detect_time'],
      lastDetectTime: json['last_detect_time'],
      objectName: json['object_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_detect_time': firstDetectTime,
      'last_detect_time': lastDetectTime,
      'object_name': objectName,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectedObject &&
          runtimeType == other.runtimeType &&
          firstDetectTime == other.firstDetectTime &&
          lastDetectTime == other.lastDetectTime &&
          objectName == other.objectName;

  @override
  int get hashCode =>
      firstDetectTime.hashCode ^ lastDetectTime.hashCode ^ objectName.hashCode;
}

class DetectedObjects {
  Map<String, DetectedObject> objects;

  DetectedObjects({required this.objects});

  factory DetectedObjects.fromJson(int id, Map<String, dynamic> json) {
    Map<String, DetectedObject> objects = {};
    json['objects'].forEach((key, value) {
      objects[key] = DetectedObject.fromMap(id, value);
    });

    return DetectedObjects(objects: objects);
  }

  Map<String, dynamic> toJson() {
    return {
      'objects': {for (var key in objects.keys) key: objects[key]!.toMap()},
    };
  }

  DetectedObjects copyWith({
    Map<String, DetectedObject>? objects,
  }) {
    return DetectedObjects(
      objects: objects ?? this.objects,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectedObjects && runtimeType == other.runtimeType;

  @override
  int get hashCode => objects.hashCode;
}
