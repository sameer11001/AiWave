

import 'dart:developer';

void logError(String error) {
  log(error, name: "[WaveStorage: Error]");
}

void logInfo(String info) {
  log(info, name: "[WaveStorage: Info]");
}

void logWarning(String warning) {
  log(warning, name: "[WaveStorage: Warning]");
}

void logDebug(String debug) {
  log(debug, name: "[WaveStorage: Debug]");
}

extension LogExtension on String {
  void logError() {
    log(this, name: "[WaveStorage: Error]");
  }

  void logInfo() {
    log(this, name: "[WaveStorage: Info]");
  }

  void logWarning() {
    log(this, name: "[WaveStorage: Warning]");
  }

  void logDebug() {
    log(this, name: "[WaveStorage: Debug]");
  }
}