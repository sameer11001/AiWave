import 'package:aiwave/app/core/utils/helpers/utils.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_core/wave_core.dart';

extension ResearchX on ResearchOutput {
  ResearchDocs toResearchDocs() {
    final doc = ResearchDocs(
      fileName: mdFileName ?? 'Untitled',
      fileUrl: mdFileUrl ?? '',
      content: answer,
      modelType: AIModelType.reserachWave,
    );

    return doc;
  }
}

extension StringX on String {
  String fixedString() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _d = convertStringToDuration(this);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(_d.inHours);
    String twoDigitMinutes = twoDigits(_d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_d.inSeconds.remainder(60));

    if (_d.inHours > 0) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
