import 'dart:convert';

class UserProcess {
  String? uid;
  String? mediaUid;
  String? modelName;
  String? task;
  String? modelKey;
  dynamic data;
  String? createdAt;
  dynamic updatedAt;

  UserProcess({
    this.uid,
    this.mediaUid,
    this.modelName,
    this.task,
    this.modelKey,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Process(uid: $uid, mediaUid: $mediaUid, modelName: $modelName, task: $task, modelKey: $modelKey, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory UserProcess.fromMap(Map<String, dynamic> data) => UserProcess(
        uid: data['uid'] as String?,
        mediaUid: data['media_uid'] as String?,
        modelName: data['model_name'] as String?,
        task: data['task'] as String?,
        modelKey: data['model_key'] as String?,
        data: data['data'] as dynamic,
        createdAt: data['created_at'] as String?,
        updatedAt: data['updated_at'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'media_uid': mediaUid,
        'model_name': modelName,
        'task': task,
        'model_key': modelKey,
        'data': data,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserProcess].
  factory UserProcess.fromJson(String data) {
    return UserProcess.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Process] to a JSON string.
  String toJson() => json.encode(toMap());

  UserProcess copyWith({
    String? uid,
    String? mediaUid,
    String? modelName,
    String? task,
    String? modelKey,
    dynamic data,
    String? createdAt,
    dynamic updatedAt,
  }) {
    return UserProcess(
      uid: uid ?? this.uid,
      mediaUid: mediaUid ?? this.mediaUid,
      modelName: modelName ?? this.modelName,
      task: task ?? this.task,
      modelKey: modelKey ?? this.modelKey,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(covariant UserProcess other) {
    if (identical(other, this)) return true;

    return other.uid == uid &&
        other.mediaUid == mediaUid &&
        other.modelName == modelName &&
        other.task == task &&
        other.modelKey == modelKey &&
        other.data == data &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      mediaUid.hashCode ^
      modelName.hashCode ^
      task.hashCode ^
      modelKey.hashCode ^
      data.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
