// ignore_for_file: unnecessary_this

import 'dart:convert';

class ResearchDocs {
  String? fileName;
  String? fileUrl;
  String? content;

  ResearchDocs({this.fileName, this.fileUrl, this.content});

  @override
  String toString() {
    return 'ResearchDocs(fileName: $fileName, fileUrl: $fileUrl, content: $content)';
  }

  factory ResearchDocs.fromMap(Map<String, dynamic> data) => ResearchDocs(
        fileName: data['file_name'] as String?,
        fileUrl: data['file_url'] as String?,
        content: data['content'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'file_name': fileName,
        'file_url': fileUrl,
        'content': content,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResearchDocs].
  factory ResearchDocs.fromJson(String data) {
    return ResearchDocs.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResearchDocs] to a JSON string.
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
