// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class Media {
  final String fileName;
  final String fileType;
  final String fileUrl;
  Media({
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
  });

  

  Media copyWith({
    String? fileName,
    String? fileType,
    String? fileUrl,
  }) {
    return Media(
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'file_name': fileName,
      'file_type': fileType,
      'file_url': fileUrl,
    };
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      fileName: map['file_name'] as String,
      fileType: map['file_type'] as String,
      fileUrl: map['file_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Media.fromJson(String source) => Media.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Media(fileName: $fileName, fileType: $fileType, fileUrl: $fileUrl)';

  @override
  bool operator ==(covariant Media other) {
    if (identical(this, other)) return true;
  
    return 
      other.fileName == fileName &&
      other.fileType == fileType &&
      other.fileUrl == fileUrl;
  }

  @override
  int get hashCode => fileName.hashCode ^ fileType.hashCode ^ fileUrl.hashCode;
}
