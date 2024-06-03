import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'object_info_objects.dart';

class ObjectsInfo {
  List<String>? objectNames;
  List<DetectedObject>? objects;
  int? objectsCount;

  ObjectsInfo({this.objectNames, this.objects, this.objectsCount});

  @override
  String toString() {
    return 'ObjectsInfo(objectNames: $objectNames, objects: $objects, objectsCount: $objectsCount)';
  }

  factory ObjectsInfo.fromMap(Map<String, dynamic> data) => ObjectsInfo(
        objectNames: data['object_names']?.map<String>((e) => e as String).toList(),
        objects: data['objects'] == null
            ? null
            : (data['objects'] as Map<String, dynamic>)
                .map<String, DetectedObject>(
                  (k, e) => MapEntry(k, DetectedObject.fromMap(int.parse(k), e as Map<String, dynamic>)),
                )
                .values
                .toList(),
        objectsCount: data['objects_count'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'object_names': objectNames,
        'objects': objects?.map((e) => e.toMap()).toList(),
        'objects_count': objectsCount,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ObjectsInfo].
  factory ObjectsInfo.fromJson(String data) {
    return ObjectsInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ObjectsInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  ObjectsInfo copyWith({
    List<String>? objectNames,
    List<DetectedObject>? objects,
    int? objectsCount,
  }) {
    return ObjectsInfo(
      objectNames: objectNames ?? this.objectNames,
      objects: objects ?? this.objects,
      objectsCount: objectsCount ?? this.objectsCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ObjectsInfo) return false;
    return listEquals(other.objectNames, objectNames) &&
        listEquals(other.objects, objects) &&
        other.objectsCount == objectsCount;
  }

  @override
  int get hashCode =>
      objectNames.hashCode ^ objects.hashCode ^ objectsCount.hashCode;
}
