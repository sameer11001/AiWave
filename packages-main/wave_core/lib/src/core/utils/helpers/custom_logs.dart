

import 'dart:developer';

void logError(String error) {
  log(error, name: "[WaveCore: Error]");
}

void logInfo(String info) {
  log(info, name: "[WaveCore: Info]");
}

void logWarning(String warning) {
  log(warning, name: "[WaveCore: Warning]");
}

void logDebug(String debug) {
  log(debug, name: "[WaveCore: Debug]");
}

extension LogExtension on String {
  void logError() {
    log(this, name: "[WaveCore: Error]");
  }

  void logInfo() {
    log(this, name: "[WaveCore: Info]");
  }

  void logWarning() {
    log(this, name: "[WaveCore: Warning]");
  }

  void logDebug() {
    log(this, name: "[WaveCore: Debug]");
  }
}