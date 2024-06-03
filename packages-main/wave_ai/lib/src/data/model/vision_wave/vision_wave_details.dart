// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:collection/collection.dart';

import 'details_objects_info.dart';
import 'details_output.dart';

class VisionWaveDetails {
  dynamic filters;
  ObjectsInfo? objectsInfo;
  OutputFile? outputFile;
  String? processUid;
  bool? traking;

  VisionWaveDetails({
    this.filters,
    this.objectsInfo,
    this.outputFile,
    this.processUid,
    this.traking,
  });

  @override
  String toString() {
    return 'VisionWaveDetails(filters: $filters, objectsInfo: $objectsInfo, outputFile: $outputFile, processUid: $processUid, traking: $traking)';
  }

  factory VisionWaveDetails.fromMap(Map<String, dynamic> data) =>
      VisionWaveDetails(
        filters: data['filters'] as dynamic,
        objectsInfo: data['objects_info'] == null
            ? null
            : ObjectsInfo.fromMap(data['objects_info'] as Map<String, dynamic>),
        outputFile: data['output_file'] == null
            ? null
            : OutputFile.fromMap(data['output_file'] as Map<String, dynamic>),
        processUid: data['process_uid'] as String?,
        traking: data['traking'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'filters': filters,
        'objects_info': objectsInfo?.toMap(),
        'output_file': outputFile?.toMap(),
        'process_uid': processUid,
        'traking': traking,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VisionWaveDetails].
  factory VisionWaveDetails.fromJson(String data) {
    return VisionWaveDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VisionWaveDetails] to a JSON string.
  String toJson() => json.encode(toMap());

  VisionWaveDetails copyWith({
    dynamic filters,
    ObjectsInfo? objectsInfo,
    OutputFile? outputFile,
    String? processUid,
    bool? traking,
  }) {
    return VisionWaveDetails(
      filters: filters ?? this.filters,
      objectsInfo: objectsInfo ?? this.objectsInfo,
      outputFile: outputFile ?? this.outputFile,
      processUid: processUid ?? this.processUid,
      traking: traking ?? this.traking,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VisionWaveDetails) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      filters.hashCode ^
      objectsInfo.hashCode ^
      outputFile.hashCode ^
      processUid.hashCode ^
      traking.hashCode;
}
