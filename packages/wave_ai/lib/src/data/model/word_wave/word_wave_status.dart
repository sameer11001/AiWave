import 'dart:async';

import '../../../../wave_ai.dart';

class WordWaveStatus extends BaseStatus {
  WordWaveStatus({
    required super.uid,
    required super.mediaUid,
    required super.modelName,
    required super.state,
    required super.stateMessage,
    super.stateDetails,
    required super.progress,
    required super.timestamp, 
  });

  WordWaveStatus get statusDetails => stateDetails as WordWaveStatus;
  set statusDetails(WordWaveStatus value) => stateDetails = value;

  factory WordWaveStatus.fromMap(Map<String, dynamic> map) {
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
    return WordWaveStatus(
      uid: map['uid'] as String,
      mediaUid: map['media_uid'] as String,
      modelName: map['model_name'] as String,
      state: StatusState.fromKey(map['state']),
      stateMessage: map['state_message'] as String,
      stateDetails: map['state_details'] != null
          ? WordWaveDetails.fromMap(
              map['state_details'] as Map<String, dynamic>)
          : null,
      progress: progress,
      timestamp: map['timestamp'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': uid,
      'model_name': modelName,
      'state': state.toKey(),
      'state_message': stateMessage,
      'state_details': stateDetails?.toMap(),
      'progress': progress.map((e) => e.toMap()).toList(),
      'timestamp': timestamp,
    } as Map<String, dynamic>;
  }

  @override
  WordWaveStatus copyWith({
    String? uid,
    String? mediaUid,
    String? modelName,
    StatusState? state,
    String? stateMessage,
    dynamic stateDetails,
    List<ProgressStep>? progress,
    String? timestamp,
  }) {
    return WordWaveStatus(
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

  final _statusController = StreamController<WordWaveStatus>.broadcast();

  // Stream getter for status changes
  @override
  Stream<WordWaveStatus> onChanged({required String userUid}) {
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

    WordWave.instance.runWithStatusStream(
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
