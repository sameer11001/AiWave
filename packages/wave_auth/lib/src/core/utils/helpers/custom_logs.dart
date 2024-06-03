

import 'dart:developer';

void logError(String error) {
  log(error, name: "[WaveAuth: Error]");
}

void logInfo(String info) {
  log(info, name: "[WaveAuth: Info]");
}

void logWarning(String warning) {
  log(warning, name: "[WaveAuth: Warning]");
}

void logDebug(String debug) {
  log(debug, name: "[WaveAuth: Debug]");
}

extension LogExtension on String {
  void logError() {
    log(this, name: "[WaveAuth: Error]");
  }

  void logInfo() {
    log(this, name: "[WaveAuth: Info]");
  }

  void logWarning() {
    log(this, name: "[WaveAuth: Warning]");
  }

  void logDebug() {
    log(this, name: "[WaveAuth: Debug]");
  }
}