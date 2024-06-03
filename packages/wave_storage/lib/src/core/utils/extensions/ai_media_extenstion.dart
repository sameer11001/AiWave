import 'package:wave_core/wave_core.dart';
import 'package:wave_storage/src/data/model/ai_media.dart';

extension MediaExtension on List<AIMedia>{
  List<AIMedia> filterByModelType(AIModelType modelType) => where((media) => media.aiProcesses.any((process) => process.modelType == modelType)).toList();
}