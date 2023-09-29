class TimeNeeded {
  String timeString;
  int timeMinutes;
  TimeNeeded({required this.timeString, required this.timeMinutes});
}

List<TimeNeeded> timeNeededList = [
  TimeNeeded(timeString: '0:30', timeMinutes: 30),
  TimeNeeded(timeString: '1:00', timeMinutes: 60),
  TimeNeeded(timeString: '2:00', timeMinutes: 120),
  TimeNeeded(timeString: '4:00', timeMinutes: 240),
  TimeNeeded(timeString: '8:00', timeMinutes: 480),
];

String timeToText(int minutes) {
  int hour = minutes ~/ 60;
  int mins = minutes % 60;
  return '${hour.toString()}:${mins.toString().padLeft(2, "0")}';
}
