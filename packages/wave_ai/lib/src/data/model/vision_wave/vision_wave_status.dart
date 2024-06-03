import 'dart:async';
import 'dart:convert';

import 'package:wave_ai/src/data/services/vision_wave_service.dart';

import '../../enums/process_state.dart';
import '../../enums/status_state.dart';
import '../base_status.dart';
import '../progress_step.dart';
import 'vision_wave_details.dart';

class VisionWaveStatus extends BaseStatus {
  VisionWaveStatus({
    required super.uid,
    required super.mediaUid,
    required super.modelName,
    required super.state,
    required super.stateMessage,
    super.stateDetails,
    required super.progress,
    required super.timestamp,
  });

  VisionWaveStatus get statusDetails => stateDetails as VisionWaveStatus;
  set statusDetails(VisionWaveStatus value) => stateDetails = value;

  @override
  VisionWaveStatus copyWith({
    String? uid,
    String? mediaUid,
    String? modelName,
    StatusState? state,
    String? stateMessage,
    dynamic stateDetails,
    List<ProgressStep>? progress,
    String? timestamp,
  }) {
    return VisionWaveStatus(
      uid: uid ?? this.uid,
      mediaUid: mediaUid ?? this.mediaUid,
      modelName: modelName ?? this.modelName,
      state: state ?? this.state,
      stateMessage: stateMessage ?? this.stateMessage,
      stateDetails: stateDetails ?? this.stateDetails,
      progress: progress ?? this.progress,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'model_name': modelName,
      'state': state.toKey(),
      'state_message': stateMessage,
      'state_details': stateDetails?.toMap(),
      'progress': progress.map((e) => e.toMap()).toList(),
      'timestamp': timestamp,
    };
  }

  factory VisionWaveStatus.fromMap(Map<String, dynamic> map) {
    final progress = <ProgressStep>[];
    final progressMap = map['progress'] as Map<String, dynamic>;
    progressMap.forEach(
      (key, value) {
        progress.add(
          ProgressStep(
            step: key,
            state: ProcessState.fromKey(value as String),
          ),
        );
      },
    );
    return VisionWaveStatus(
      uid: map['uid'] as String,
      mediaUid: map['media_uid'] as String,
      modelName: map['model_name'] as String,
      state: StatusState.fromKey(map['state']),
      stateMessage: map['state_message'] as String,
      stateDetails: map['state_details'] != null
          ? VisionWaveDetails.fromMap(
              map['state_details'] as Map<String, dynamic>)
          : null,
      progress: progress,
      timestamp: map['timestamp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'VisionWaveStatus(uid: $uid, model_name: $modelName, state: $state, state_message: $stateMessage, state_details: $stateDetails, progress: $progress, timestamp: $timestamp)';
  }

  final _statusController = StreamController<VisionWaveStatus>.broadcast();
  // Stream getter for status changes

  @override
  Stream<VisionWaveStatus> onChanged({required String userUid}) {
    // Check if the status is complate
    if (state == StatusState.completed) {
      // Make the stream is done
      _statusController.close();
      return _statusController.stream;
    }
    // Check if the _statusController is already streaming
    if (_statusController.hasListener) {
      // Return the stream
      return _statusController.stream;
    }

    VisionWave.instance.runWithStatusStream(
      userUid: userUid,
      statusUid: uid,
      statusController: _statusController,
    );
    return _statusController.stream;
  }

  // Close the stream
  void dispose() {
    // Cancel the status subscription when no longer needed
    _statusController.close();
  }
}
