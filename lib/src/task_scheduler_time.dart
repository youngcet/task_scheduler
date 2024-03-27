// ScheduleTimeline class for defining timeline settings
class ScheduleTimeline {
  // Hour of the timeline
  int hour;

  // Constructor for ScheduleTimeline
  ScheduleTimeline({required this.hour});

  // Factory constructor for creating ScheduleTimeline with specified hour
  factory ScheduleTimeline.time({int hour = 0}) {
    return ScheduleTimeline(hour: hour);
  }
}
