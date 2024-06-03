// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:collection/collection.dart';

class OutputFile {
  String? path;

  OutputFile({this.path});

  @override
  String toString() => 'OutputFile(path: $path)';

  factory OutputFile.fromMap(Map<String, dynamic> data) => OutputFile(
        path: data['path'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'path': path,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OutputFile].
  factory OutputFile.fromJson(String data) {
    return OutputFile.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OutputFile] to a JSON string.
  String toJson() => json.encode(toMap());

  OutputFile copyWith({
    String? path,
  }) {
    return OutputFile(
      path: path ?? this.path,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OutputFile) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => path.hashCode;
}
