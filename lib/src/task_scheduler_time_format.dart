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

  // show only hours on the clock
  bool? showHoursOnly;

  // Constructor for SchedulerTimeSettings
  SchedulerTimeSettings(
      {this.minuteInterval,
      this.use24HourFormat,
      this.includePeriod,
      this.includeMinutes,
      this.showHoursOnly});

  // Factory constructor for creating SchedulerTimeSettings with hour format
  factory SchedulerTimeSettings.hourFormat({
    bool format = false,
    bool period = false,
    int interval = 0,
    bool includeMinutes = true,
    bool showHoursOnly = false,
  }) {
    return SchedulerTimeSettings(
        minuteInterval: interval,
        use24HourFormat: format,
        includePeriod: period,
        includeMinutes: includeMinutes,
        showHoursOnly: showHoursOnly);
  }
}
