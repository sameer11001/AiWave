import 'package:chewie/chewie.dart';

import '../helpers/utils.dart';

extension WordWave on List<Map<String, dynamic>> {
  Subtitles toWordWaveSubTitle() {
    return Subtitles(map(
      (e) => Subtitle(
        index: e['index'] as int,
        start: convertStringToDuration(e['start'] as String),
        end: convertStringToDuration(e['end'] as String),
        text: e['text'] as String,
      ),
    ).toList());
  }
}

extension DurationX on Duration {
  String fixedString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(inHours);
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));

    if (inHours > 0) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
