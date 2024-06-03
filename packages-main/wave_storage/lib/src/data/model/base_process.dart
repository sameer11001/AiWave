// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wave_core/wave_core.dart';
import 'package:wave_ai/wave_ai.dart';

class BaseProcess {
  final String? uid;
  final AIModelType modelType;
  final String? task;
  final String modelKey;
  dynamic data;
  final DateTime createdAt;
  final DateTime? updatedAt;
  BaseProcess({
    required this.uid,
    required this.modelType,
    required this.task,
    required this.modelKey,
    this.data,
    required this.createdAt,
    this.updatedAt,
  });

  BaseProcess copyWith({
    AIModelType? modelType,
    String? task,
    String? modelKey,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BaseProcess(
      uid: uid,
      modelType: modelType ?? this.modelType,
      task: task ?? this.task,
      modelKey: modelKey ?? this.modelKey,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'model_name': modelType.toKey(),
      'task': task,
      'model_key': modelKey,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory BaseProcess.fromMap(Map<String, dynamic> map) {
    final modelType = AIModelType.fromKey(map['model_name'] as String);
    var data = map['data'];
    if (modelType == AIModelType.wordWave) {
      data = WordWaveDetails.fromMap(data as Map<String, dynamic>);
    } else if (modelType == AIModelType.visionWave) {
      data = VisionWaveDetails.fromMap(data as Map<String, dynamic>);
    }
    return BaseProcess(
      uid: map['uid'] ?? GlobalKey().toString(),
      modelType: modelType,
      task: map['task'],
      modelKey: map['model_key'] as String,
      data: data,
      createdAt: WaveDateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null
          ? null
          : WaveDateTime.parse(map['updated_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseProcess.fromJson(String source) =>
      BaseProcess.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BaseProcess(modelType: $modelType, task: $task, modelKey: $modelKey, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BaseProcess other) {
    if (identical(this, other)) return true;

    return other.modelType == modelType &&
        other.task == task &&
        other.modelKey == modelKey &&
        other.data == data &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return modelType.hashCode ^
        task.hashCode ^
        modelKey.hashCode ^
        data.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
