// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:wave_core/wave_core.dart';

import 'package:wave_storage/src/data/model/base_process.dart';

class AIMedia {
  final String uid;
  final String userUid;
  final String filePath;
  final String fileName;
  final String fileType;
  final String fileUrl;
  final String? data;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<BaseProcess> aiProcesses;

  AIMedia({
    required this.uid,
    required this.userUid,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    this.data,
    this.thumbnailUrl,
    required this.createdAt,
    this.updatedAt,
    this.aiProcesses = const [],
  });

  AIMedia copyWith({
    String? uid,
    String? userUid,
    String? filePath,
    String? fileName,
    String? fileType,
    String? fileUrl,
    String? data,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BaseProcess>? aiProcesses,
  }) {
    return AIMedia(
      uid: uid ?? this.uid,
      userUid: userUid ?? this.userUid,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileUrl: fileUrl ?? this.fileUrl,
      data: data ?? this.data,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      aiProcesses: aiProcesses ?? this.aiProcesses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'user_uid': userUid,
      'file_path': filePath,
      'file_name': fileName,
      'file_type': fileType,
      'file_url': fileUrl,
      'data': data,
      'thumbnail_url': thumbnailUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'ai_processes': aiProcesses.map((e) => e.toMap()).toList(),
    };
  }

  factory AIMedia.fromMap(Map<String, dynamic> map) {
    return AIMedia(
      uid: map['uid'] as String,
      userUid: map['user_uid'] as String,
      filePath: map['file_path'] as String,
      fileName: map['file_name'] as String,
      fileType: map['file_type'] as String,
      fileUrl: map['file_url'] as String,
      data: map['data'],
      thumbnailUrl: map['thumbnail_url'],
      createdAt: WaveDateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? WaveDateTime.parse(map['updated_at'] as String)
          : null,
      aiProcesses: (map['ai_processes'] as List<dynamic>)
          .map((e) => BaseProcess.fromMap(e))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AIMedia.fromJson(String source) =>
      AIMedia.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Media(uid: $uid, userUid: $userUid, filePath: $filePath, fileName: $fileName, fileType: $fileType, fileUrl: $fileUrl, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant AIMedia other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userUid == userUid &&
        other.filePath == filePath &&
        other.fileName == fileName &&
        other.fileType == fileType &&
        other.fileUrl == fileUrl &&
        other.data == data &&
        other.thumbnailUrl == thumbnailUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        userUid.hashCode ^
        filePath.hashCode ^
        fileName.hashCode ^
        fileType.hashCode ^
        fileUrl.hashCode ^
        data.hashCode ^
        thumbnailUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  BaseProcess? getProcessByUid(String processUid) {
    try {
      return aiProcesses.firstWhere(
        (element) => element.uid == processUid,
      );
    } catch (_) {
      return null;
    }
  }

  BaseProcess? getProcessByModelType(AIModelType modelType) {
    try {
      return aiProcesses.firstWhere(
        (element) => element.modelType == modelType,
      );
    } catch (_) {
      return null;
    }
  }
}
