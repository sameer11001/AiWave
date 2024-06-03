import 'package:wave_ai/wave_ai.dart';

class Message {
  final String uid;
  final int id;
  String? text;
  ResearchDocs? researchDocs;

  Message({
    required this.uid,
    required this.id,
    this.text,
    this.researchDocs,
  });
}
