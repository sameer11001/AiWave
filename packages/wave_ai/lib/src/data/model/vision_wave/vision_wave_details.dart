import 'dart:convert';

class VisionWaveDetails {
  final List<dynamic>? filters;
  final String outputFile;
  final bool traking;

  VisionWaveDetails({
    this.filters,
    required this.outputFile,
    required this.traking,
  });

  VisionWaveDetails copyWith({
    String? processUid,
    String? filters,
    String? outputFile,
    bool? traking,
  }) {
    return VisionWaveDetails(
      filters: this.filters,
      outputFile: this.outputFile,
      traking: this.traking,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filters': filters,
      'output_file': outputFile,
      'traking': traking
    };
  }

  factory VisionWaveDetails.fromMap(Map<String, dynamic> map) {
    return VisionWaveDetails(
      filters: map['filters'] as List<dynamic>?,
      outputFile: map['output_file']['path'],
      traking: map['traking'] as bool,
    );
  }

  @override
  String toString() {
    return 'StateDetails(filters: $filters, outputFile: $outputFile, traking: $traking)';
  }

  factory VisionWaveDetails.fromJson(String data) {
    return VisionWaveDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(covariant VisionWaveDetails other) {
    if (identical(other, this)) return true;
    return other.traking == traking &&
        other.filters == filters &&
        other.outputFile == outputFile;
  }

  @override
  int get hashCode => filters.hashCode ^ outputFile.hashCode ^ traking.hashCode;
}
