// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BaseStatusDetails {
  final String processUid;
  BaseStatusDetails({
    required this.processUid,
  });

  BaseStatusDetails copyWith({
    String? processUid,
  }) {
    return BaseStatusDetails(
      processUid: processUid ?? this.processUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'processUid': processUid,
    };
  }

  factory BaseStatusDetails.fromMap(Map<String, dynamic> map) {
    return BaseStatusDetails(
      processUid: map['processUid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseStatusDetails.fromJson(String source) => BaseStatusDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BaseStatusDetails(processUid: $processUid)';

  @override
  bool operator ==(covariant BaseStatusDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.processUid == processUid;
  }

  @override
  int get hashCode => processUid.hashCode;
}
