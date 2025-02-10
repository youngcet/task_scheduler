/// A class for configuring time settings in the scheduler.
class SchedulerTimeSettings {
  /// Indicates whether to use a 24-hour time format (e.g., 14:00).
  bool? use24HourFormat;

  /// Indicates whether to include the period (AM/PM) in the time format.
  bool? includePeriod;

  /// The interval for minutes, e.g., 5-minute or 15-minute increments.
  ///
  /// Allowed intervals [5, 10, 15, 20, 30, 60].
  int? minuteInterval;

  /// Indicates whether to include minutes in the time display.
  bool? includeMinutes;

  /// If true, only hours will be shown on the clock, excluding minutes.
  bool? showHoursOnly;

  /// Constructor for creating an instance of [SchedulerTimeSettings].
  ///
  /// Allows customization of various time settings such as hour format,
  /// minute interval, and visibility of minutes or hours.
  SchedulerTimeSettings(
      {this.minuteInterval,
      this.use24HourFormat,
      this.includePeriod,
      this.includeMinutes,
      this.showHoursOnly});

  /// Factory constructor for creating a [SchedulerTimeSettings] instance
  /// with a focus on hour formatting options.
  ///
  /// - [format]: Whether to use a 24-hour time format. Default is `false`.
  /// - [period]: Whether to include the period (AM/PM). Default is `false`.
  /// - [interval]: Minute interval for the time picker. Default is `0`.
  /// - [includeMinutes]: Whether to include minutes in the display. Default is `true`.
  /// - [showHoursOnly]: Whether to show only hours on the clock. Default is `false`.
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
