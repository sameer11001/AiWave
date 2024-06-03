// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../enums/status_details_data_type.dart';

class WordWaveDetailsData {
  final StatusDetailsDataType type;
  final String path;
  final dynamic content;
  WordWaveDetailsData({
    required this.type,
    required this.path,
    required this.content,
  });

  WordWaveDetailsData copyWith({
    StatusDetailsDataType? type,
    String? path,
    dynamic content,
  }) {
    return WordWaveDetailsData(
      type: type ?? this.type,
      path: path ?? this.path,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toKey(),
      'path': path,
      'content': content,
    };
  }

  factory WordWaveDetailsData.fromMap(Map<String, dynamic> map) {
    return WordWaveDetailsData(
      type: StatusDetailsDataType.fromKey(map['type'] as String),
      path: map['path'] as String,
      content: map['content'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory WordWaveDetailsData.fromJson(String source) =>
      WordWaveDetailsData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StatusDetailsData(type: $type, path: $path, content: $content)';

  @override
  bool operator ==(covariant WordWaveDetailsData other) {
    if (identical(this, other)) return true;

    return other.type == type && other.path == path && other.content == content;
  }

  @override
  int get hashCode => type.hashCode ^ path.hashCode ^ content.hashCode;
}
