Duration convertStringToDuration(String timeString) {
  List<String> timeComponents = timeString.split(':');
  int hours = int.parse(timeComponents[0]);
  int minutes = int.parse(timeComponents[1]);
  List<String> secondsComponents = timeComponents[2].split(',');
  int seconds = int.parse(secondsComponents[0]);
  int milliseconds = int.parse(secondsComponents[1]);

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}