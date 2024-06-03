// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:wave_core/wave_core.dart';

class ResearchDocs {
  final String fileName;
  final String fileUrl;
  String? content;
  final AIModelType modelType;

  ResearchDocs({
    required this.fileName,
    required this.fileUrl,
    this.content,
    this.modelType = AIModelType.reserachWave,
  });

  @override
  String toString() {
    return 'ResearchDocs(fileName: $fileName, fileUrl: $fileUrl, content: $content)';
  }

  factory ResearchDocs.fromMap(Map<String, dynamic> data) => ResearchDocs(
        fileName: data['file_name'],
        fileUrl: data['file_url'],
        content: data['content'],
        modelType: AIModelType.reserachWave,
      );

  Map<String, dynamic> toMap() => {
        'file_name': fileName,
        'file_url': fileUrl,
        'content': content,
      };

  factory ResearchDocs.fromJson(String data) {
    return ResearchDocs.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  ResearchDocs copyWith({
    String? fileName,
    String? fileUrl,
    String? content,
  }) {
    return ResearchDocs(
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      content: content ?? this.content,
    );
  }

  @override
  bool operator ==(covariant ResearchDocs other) {
    if (identical(this, other)) return true;

    return other.fileName == this.fileName &&
        other.fileUrl == this.fileUrl &&
        other.content == this.content;
  }

  @override
  int get hashCode => fileName.hashCode ^ fileUrl.hashCode ^ content.hashCode;
}
