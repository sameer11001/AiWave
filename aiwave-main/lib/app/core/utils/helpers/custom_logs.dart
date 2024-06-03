import 'dart:developer';

void logError(String error, {String? name}) {
  log(error, name: name != null ? "Error<$name>" : "Error");
}

void logInfo(String info, {String? name}) {
  log(info, name: name != null ? "Info<$name>" : "Info");
}

void logWarning(String warning, {String? name}) {
  log(warning, name: name != null ? "Warning<$name>" : "Warning");
}

void logDebug(String debug, {String? name}) {
  log(debug, name: name != null ? "Debug<$name>" : "Debug");
}

extension LogExtension on String {
  void logError() {
    log(this, name: "Error");
  }

  void logInfo() {
    log(this, name: "Info");
  }

  void logWarning() {
    log(this, name: "Warning");
  }

  void logDebug() {
    log(this, name: "Debug");
  }
}
