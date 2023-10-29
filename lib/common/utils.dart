
Duration timeStringToDuration(String timeStr) {
  final parts = timeStr.split(':'); // Split the time string into parts
  if (parts.length != 3) {
    throw FormatException('Invalid time format: $timeStr');
  }

  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = int.parse(parts[2]);

  // Create a Duration with the extracted values
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String durationToTimeString(Duration duration) {
  final hours = duration.inHours;
  final minutes = (duration.inMinutes % 60);
  final seconds = (duration.inSeconds % 60);

  return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}