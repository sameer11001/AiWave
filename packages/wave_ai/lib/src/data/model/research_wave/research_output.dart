// ignore_for_file: unnecessary_this

import 'dart:convert';

class ResearchOutput {
  String answer;
  String? mdFileName;
  String? mdFileUrl;
  String? question;

  ResearchOutput({
    required this.answer,
    this.mdFileName,
    this.mdFileUrl,
    this.question,
  });

  @override
  String toString() {
    return 'Output(answer: $answer, mdFileName: $mdFileName, mdFileUrl: $mdFileUrl, question: $question)';
  }

  factory ResearchOutput.fromMap(Map<String, dynamic> data) => ResearchOutput(
        answer: data['answer'] as String,
        mdFileName: data['md_file_name'] as String?,
        mdFileUrl: data['md_file_url'] as String?,
        question: data['question'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'answer': answer,
        'md_file_name': mdFileName,
        'md_file_url': mdFileUrl,
        'question': question,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResearchOutput].
  factory ResearchOutput.fromJson(String data) {
    return ResearchOutput.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResearchOutput] to a JSON string.
  String toJson() => json.encode(toMap());

  ResearchOutput copyWith({
    String? answer,
    String? mdFileName,
    String? mdFileUrl,
    String? question,
  }) {
    return ResearchOutput(
      answer: answer ?? this.answer,
      mdFileName: mdFileName ?? this.mdFileName,
      mdFileUrl: mdFileUrl ?? this.mdFileUrl,
      question: question ?? this.question,
    );
  }

  @override
  bool operator ==(covariant ResearchOutput other) {
    if (identical(this, other)) return true;

    return other.answer == this.answer &&
        other.mdFileName == this.mdFileName &&
        other.mdFileUrl == this.mdFileName &&
        other.question == this.question;
  }

  @override
  int get hashCode =>
      answer.hashCode ^
      mdFileName.hashCode ^
      mdFileUrl.hashCode ^
      question.hashCode;
}
