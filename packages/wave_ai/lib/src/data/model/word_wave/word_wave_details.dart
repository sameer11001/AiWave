// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../enums/language.dart';
import '../../enums/status_details_data_type.dart';
import 'word_wave_details_data.dart';

class WordWaveDetails {
  final String? processUid;
  final Language language;
  final List<WordWaveDetailsData> data;
  WordWaveDetails({
    this.processUid,
    required this.language,
    required this.data,
  });

  WordWaveDetails copyWith({
    String? processUid,
    Language? language,
    List<WordWaveDetailsData>? data,
  }) {
    return WordWaveDetails(
      processUid: processUid ?? this.processUid,
      language: language ?? this.language,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'process_uid': processUid,
      'language_code': language.toKey(),
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory WordWaveDetails.fromMap(Map<String, dynamic> map) {
    return WordWaveDetails(
      processUid: map['process_uid'] as String?,
      language: Language.fromKey(map['language_code'] as String),
      data: (map['data'])
          .map<WordWaveDetailsData>(
              (m) => WordWaveDetailsData.fromMap(m))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WordWaveDetails.fromJson(String source) =>
      WordWaveDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StatusDetails(processUid: $processUid, language: $language, data: $data)';

  @override
  bool operator ==(covariant WordWaveDetails other) {
    if (identical(this, other)) return true;

    return other.processUid == processUid &&
        other.language == language &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => processUid.hashCode ^ language.hashCode ^ data.hashCode;

  WordWaveDetailsData? getDataByType({StatusDetailsDataType? type}) {
    try {
      return data.firstWhere((element) => element.type == type);
    } catch (_) {
      return null;
    }
  }
}
