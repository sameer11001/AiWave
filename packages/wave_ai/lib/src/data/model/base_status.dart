import '../enums/status_state.dart';
import 'progress_step.dart';

class BaseStatus {
  final String uid;
  final String mediaUid;
  final String modelName;
  final StatusState state;
  final String stateMessage;
  dynamic stateDetails;
  final List<ProgressStep> progress;
  final String timestamp;
  BaseStatus({
    required this.uid,
    required this.mediaUid,
    required this.modelName,
    required this.state,
    required this.stateMessage,
    this.stateDetails,
    required this.progress,
    required this.timestamp,
  });

  // Create a Stream of the status with T type of BaseStatus to override the
  // status with the correct type of status
  Stream<BaseStatus> onChanged({required String userUid}) {
    return const Stream.empty();
  }

  // Create a copy of the status
  BaseStatus copyWith({
    String? uid,
    String? mediaUid,
    String? modelName,
    StatusState? state,
    String? stateMessage,
    dynamic stateDetails,
    List<ProgressStep>? progress,
    String? timestamp,
  }) {
    return BaseStatus(
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
}
