import 'package:flutter/material.dart';
import 'package:wave_ai/src/data/model/vision_wave/vision_wave_details.dart';
import 'package:wave_core/wave_core.dart';
import 'package:wave_storage/wave_storage.dart';

class VisionWaveProcess extends BaseProcess {
  final VisionWaveDetails? details;
  VisionWaveProcess({
    required super.modelType,
    required super.task,
    required super.modelKey,
    required super.createdAt,
    required super.uid,
    super.updatedAt,
    this.details,
  });

  @override
  VisionWaveDetails? get data => details;

  @override
  Map<String, dynamic> toMap() {
    return {
      'model_type': modelType,
      'task': task,
      'model_key': modelKey,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'data': data,
    };
  }

  @override
  factory VisionWaveProcess.fromMap(Map<String, dynamic> map) {
    return VisionWaveProcess(
      uid: map['uid'] ?? GlobalKey().toString(),
      modelType: AIModelType.fromKey(map['model_name'] as String),
      task: map['task'] as String,
      modelKey: map['model_key'] as String,
      createdAt: WaveDateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null
          ? null
          : WaveDateTime.parse(map['updated_at'] as String),
      details: map['data'] == null
          ? null
          : VisionWaveDetails.fromMap(map['data'] as Map<String, dynamic>),
    );
  }
}
