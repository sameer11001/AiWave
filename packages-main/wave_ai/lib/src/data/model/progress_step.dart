// ignore_for_file: public_member_api_docs, sort_constructors_first
// {[1] Initializing the WordWave process: completed, [2] Detecting the language of the audio: completed, [3] Transcribing the audio: completed, [4] Concatenating the SRT file with the original video: skipped, [5] WordWave process completed: completed}

import 'dart:convert';

import 'package:wave_ai/src/data/enums/process_state.dart';

class ProgressStep {
  final String step;
  final ProcessState state;
  ProgressStep({
    required this.step,
    required this.state,
  });
  

  ProgressStep copyWith({
    String? step,
    ProcessState? state,
  }) {
    return ProgressStep(
      step: step ?? this.step,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'step': step,
      'state': state.toKey(),
    };
  }

  factory ProgressStep.fromMap(Map<String, dynamic> map) {
    return ProgressStep(
      step: map['step'] as String,
      state: ProcessState.fromKey(map['state']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgressStep.fromJson(String source) => ProgressStep.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Progress(step: $step, state: $state)';

  @override
  bool operator ==(covariant ProgressStep other) {
    if (identical(this, other)) return true;
  
    return 
      other.step == step &&
      other.state == state;
  }

  @override
  int get hashCode => step.hashCode ^ state.hashCode;
}
