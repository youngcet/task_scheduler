/// Class for defining timeline settings.
///
/// This class holds the hour of the timeline.
class ScheduleTimeline {
  /// The hour of the timeline.
  int hour;

  /// Creates a new instance of the ScheduleTimeline.
  ///
  /// Requires an `hour` value.
  ScheduleTimeline({required this.hour});

  /// Factory constructor for creating a ScheduleTimeline.
  ///
  /// Defaults to `hour: 0` if no value is provided.
  factory ScheduleTimeline.time({int hour = 0}) {
    return ScheduleTimeline(hour: hour);
  }
}
