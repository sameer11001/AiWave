

import 'dart:developer';

void logError(String error) {
  log(error, name: "WaveAI: Error");
}

void logInfo(String info) {
  log(info, name: "WaveAI: Info");
}

void logWarning(String warning) {
  log(warning, name: "WaveAI: Warning");
}

void logDebug(String debug) {
  log(debug, name: "WaveAI: Debug");
}

extension LogExtension on String {
  void logError() {
    log(this, name: "WaveAI: Error");
  }

  void logInfo() {
    log(this, name: "WaveAI: Info");
  }

  void logWarning() {
    log(this, name: "WaveAI: Warning");
  }

  void logDebug() {
    log(this, name: "WaveAI: Debug");
  }
}