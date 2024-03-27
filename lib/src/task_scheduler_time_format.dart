// SchedulerTimeSettings class for configuring time settings in the scheduler
class SchedulerTimeSettings {
  // Whether to use 24-hour format
  bool? use24HourFormat;

  // Whether to include period (AM/PM)
  bool? includePeriod;

  // Interval for minutes
  int? minuteInterval;

  // Whether to include minutes
  bool? includeMinutes;

  // Constructor for SchedulerTimeSettings
  SchedulerTimeSettings({
    this.minuteInterval,
  });

  // Factory constructor for creating SchedulerTimeSettings with hour format
  factory SchedulerTimeSettings.hourFormat({
    bool format = false,
    bool period = false,
    int interval = 0,
    bool includeMinutes = false,
  }) {
    return SchedulerTimeSettings(
      minuteInterval: interval,
    );
  }
}
