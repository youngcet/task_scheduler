import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_scheduler/src/blocked_entry.dart';
import 'package:task_scheduler/src/task_scheduler_datetime.dart';
import 'config.dart' as config;
import 'package:task_scheduler/src/task_scheduler_event.dart';
import 'package:task_scheduler/src/task_scheduler_header.dart';
import 'package:task_scheduler/src/task_scheduler_settings.dart';
import 'package:task_scheduler/src/task_scheduler_time.dart';
import 'package:task_scheduler/src/task_scheduler_time_format.dart';

/// A StatefulWidget that manages the scheduling and execution of tasks.
///
/// The `TaskScheduler` widget is responsible for displaying a scheduler with configurable time slots, 
/// resource headers, and entries. It allows for the configuration of start and end times, time formats, 
/// and interactions such as drag-and-drop or tapping empty slots.
///
/// It also provides options to configure overlapping entries, blocked entries, and display current time 
/// with or without animation.
class TaskScheduler extends StatefulWidget {
  /// Start time of the scheduler
  final ScheduleTimeline scheduleStartTime;

  /// End time of the scheduler
  final ScheduleTimeline scheduleEndTime;

  /// Headers for resources in the scheduler
  final List<ScheduleResourceHeader> headers;

  /// List of scheduler entries
  final List<ScheduleEntry>? entries;

  /// Time format settings for the scheduler
  final SchedulerTimeSettings? timeFormat;

  /// Options for the scheduler
  final TaskSchedulerSettings? options;

  /// Callback function when an empty slot is pressed
  final Function(Map<String, dynamic>) onEmptySlotPressed;

  /// Callback function when a drag action is accepted
  final Function(Map<String, dynamic>)? onDragAccept;

  /// Configure if entries can overlap
  final bool? allowEntryOverlap;

  /// List of blocked off entries
  final List<BlockedEntry>? blockedEntries;

  /// Animate to current time
  final bool? scrollToCurrentTime;

  /// Show line for the current time
  final bool? showCurrentTimeLine;

  /// Constructor to initialize the TaskScheduler widget with necessary configurations.
  const TaskScheduler(
      {Key? key,
      required this.scheduleStartTime,
      required this.scheduleEndTime,
      required this.headers,
      required this.entries,
      required this.onEmptySlotPressed,
      this.allowEntryOverlap,
      this.options,
      this.timeFormat,
      this.blockedEntries,
      this.scrollToCurrentTime,
      this.showCurrentTimeLine,
      this.onDragAccept})
      : super(key: key);

  @override
  _TaskSchedulerState createState() => _TaskSchedulerState();

  /// Generates a list of time slots within the specified schedule range, with optional minute intervals.
  ///
  /// This function generates a timeline of time slots based on the provided `scheduleStartTime` and 
  /// `scheduleEndTime`. The time slots can be created with custom intervals (e.g., 15 minutes, 30 minutes, etc.) 
  /// if the `timeFormat.minuteInterval` is set. If no interval is provided, the default behavior is to generate 
  /// hourly time slots.
  ///
  /// The function performs the following steps:
  /// 1. If a valid minute interval is provided (`timeFormat.minuteInterval`), it generates time slots at the 
  ///    specified intervals between the start and end times. The interval must not exceed 60 minutes.
  /// 2. If no minute interval is provided, it generates hourly time slots.
  ///
  /// The generated time slots are filtered by comparing them against the valid range, using the `_compareDateTime` 
  /// function to ensure they fall within the schedule's start and end times.
  ///
  /// **Throws**:
  /// - `FlutterError`: If the minute interval is greater than 60.
  ///
  /// **Returns**:
  /// A list of time slots as strings in the format "HH:mm", filtered to only include those within the valid schedule range.
  List<String> getTimeline() {

    List<String> timeSlots = [];

    if (timeFormat?.minuteInterval != null) {
      if (timeFormat!.minuteInterval! > 60) {
        throw FlutterError(
            "TaskSchedulerError Minutes interval should be lower or equal to 60");
      }

      for (int i = scheduleStartTime.hour; i <= scheduleEndTime.hour; i++) {
        for (int j = 0; j < 60; j += timeFormat!.minuteInterval!) {
          String hour = i.toString().padLeft(2, '0');
          String minute = j.toString().padLeft(2, '0');
          String time = '$hour:$minute';
          timeSlots.add(time);
        }
      }
    } else {
      for (int i = scheduleStartTime.hour; i <= scheduleEndTime.hour; i++) {
        String hour = i.toString().padLeft(2, '0');
        String time = '$hour:00';
        timeSlots.add(time);
      }
    }

    timeSlots = _compareDateTime(timeSlots);

    return timeSlots;
  }

  /// Compares a list of time slots against a start and end time, filtering the slots within the valid range.
  ///
  /// This function takes a list of time slots and filters them based on the schedule's start and end times. 
  /// It compares each time slot to the provided start and end times, ensuring that only the time slots 
  /// within the specified range are returned.
  ///
  /// The start and end times are constructed from the `scheduleStartTime` and `scheduleEndTime` values, 
  /// and each slot is compared to these times to determine if it falls within the valid range.
  List<String> _compareDateTime(List<String> slots) {
    String startHour = scheduleStartTime.hour.toString();
    String startMinute = '0';
    String endHour = scheduleEndTime.hour.toString();
    String endMinute = '0';

    String sh = startHour.padLeft(2, '0');
    String sm = startMinute.padLeft(2, '0');
    String eh = endHour.padLeft(2, '0');
    String em = endMinute.padLeft(2, '0');

    String startTime = '$sh:$sm';
    String endTime = '$eh:$em';

    List<String> filteredTimeSlots = slots.where((time) {
      // Compare time slots with the start and end times
      return time.compareTo(startTime) >= 0 && time.compareTo(endTime) <= 0;
    }).toList();

    return filteredTimeSlots;
  }
}

// State class for TaskScheduler widget
class _TaskSchedulerState extends State<TaskScheduler> {
  // Scroll controllers for horizontal and vertical scrolling
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();

  // List to store time slots
  List<String> _timeslots = [];

  // Flag to determine 24-hour format usage
  bool use24HourFormat = true;

  // Settings for the scheduler
  TaskSchedulerSettings settings = TaskSchedulerSettings();

  // Entry list
  List<ScheduleEntry> tasks = [];

  // Timeline divider line height
  int timelineDividerHeight = 0;

  // Default minutes interval
  int defaultInterval = 60;

  // scroll to current time
  bool jumpToCurrentTime = true;

  // display current time line
  bool currentTimeLine = true;

  // timer
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.showCurrentTimeLine != null) {
      currentTimeLine = widget.showCurrentTimeLine!;
    }

    if (widget.timeFormat?.minuteInterval != null) {
      defaultInterval = widget.timeFormat!.minuteInterval!;
    }

    _validateData();

    settings.backgroundColor = widget.options?.backgroundColor;
    settings.cellHeight = _getCellHeight(defaultInterval);
    // settings.cellWidth = _getCellWidth(widget.headers.length);
    settings.horizontalTaskPadding = 0;
    settings.borderRadius = const BorderRadius.all(Radius.circular(8.0));
    settings.dividerColor = widget.options?.dividerColor;

    config.horizontalTaskPadding = settings.horizontalTaskPadding;
    config.cellHeight = settings.cellHeight;
    // config.cellWidth = settings.cellWidth;
    config.totalHours =
        ((widget.scheduleEndTime.hour - widget.scheduleStartTime.hour))
            .toDouble();
    config.totalHeaders = widget.headers.length;
    config.startHour = widget.scheduleStartTime.hour;
    config.borderRadius = settings.borderRadius;
    tasks = widget.entries ?? [];

    if (widget.timeFormat?.use24HourFormat != null) {
      use24HourFormat = widget.timeFormat!.use24HourFormat!;
    }

    _timeslots = _get24HourTimeline();
    timelineDividerHeight = _getTimelineDividerHeight(defaultInterval);

    jumpToCurrentTime = widget.scrollToCurrentTime ?? true;
    Future.delayed(Duration.zero).then((_) {
      int hour = DateTime.now().hour;
      if (jumpToCurrentTime == true) {
        if (hour > widget.scheduleStartTime.hour) {
          double scrollOffset = (hour - widget.scheduleStartTime.hour) *
              config.cellHeight!.toDouble();
          config.verticalScrollController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
          timeVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
        }
      }
    });

    if (currentTimeLine) {
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    if (currentTimeLine) {
      _timer?.cancel();
    }

    super.dispose();
  }

  /// Validates the data related to the schedule start and end times, as well as the minute interval.
  ///
  /// This function checks several conditions to ensure the schedule's start and end times, 
  /// as well as the minute interval, meet the required criteria. If any condition is violated, 
  /// an appropriate error is thrown.
  ///
  /// - Ensures the end time is within the valid range of 12 to 23 hours.
  /// - Ensures the start time is not later than the end time.
  /// - Ensures the end time is within a valid 24-hour range (not in the early AM hours).
  /// - Checks if the provided minute interval is within the allowed intervals.
  void _validateData() {
    // if (widget.scheduleStartTime.hour == 0 ||
    //     widget.scheduleEndTime.hour == 0) {
    //   throw FlutterError(
    //       "TaskSchedulerError startTime or endTime hour can not be zero.");
    // }

    if (widget.scheduleEndTime.hour < 12 || widget.scheduleEndTime.hour > 24) {
      throw FlutterError(
          "TaskSchedulerError endTime hour should be lower or equal to 23 and greater than 12.");
    }

    if (widget.scheduleEndTime.hour < widget.scheduleStartTime.hour) {
      throw FlutterError(
          "TaskSchedulerError start time should not be greater than end time hour.");
    }

    if (widget.scheduleEndTime.hour >= 1 && widget.scheduleEndTime.hour < 10) {
      throw FlutterError(
          "TaskSchedulerError endTime hour should be in a 24-hour format.");
    }

    if (!settings.allowedIntervals.containsKey('$defaultInterval')) {
      throw FlutterError(
          "TaskSchedulerError minute intervals [5, 10, 15, 20, 30, 60]");
    }
  }

  @override
  Widget build(BuildContext context) {
    config.horizontalScrollController.addListener(() {
      dayHorizontalController.jumpTo(config.horizontalScrollController.offset);
    });
    config.verticalScrollController.addListener(() {
      timeVerticalController.jumpTo(config.verticalScrollController.offset);
    });

    return GestureDetector(
      child: Container(
        color: settings.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SingleChildScrollView(
              controller: dayHorizontalController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: 60,
                  ),
                  for (int i = 0; i < config.totalHeaders; i++)
                    widget.headers[i],
                ],
              ),
            ),
            Container(
              height: 1,
              color: settings.dividerColor ?? Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: timeVerticalController,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (int i = 0; i < _timeslots.length; i++)
                                addTimeSlot(_timeslots[i]),
                            ],
                          ),
                          Container(
                            height: (config.totalHours * config.cellHeight!) +
                                timelineDividerHeight -
                                config.cellHeight!,
                            width: 1,
                            color: settings.dividerColor ??
                                Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      buildScheduleGrid(context),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScheduleGrid(BuildContext context) {
    config.cellWidth = _getCellWidth(context, config.totalHeaders);
    // Widget to build the schedule grid with scrollbars
    return Scrollbar(
      controller: config.verticalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), // prevent bounce mode on ios
        controller: config.verticalScrollController,
        child: Scrollbar(
          controller: config.horizontalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: config.horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: (config.totalHours * config.cellHeight!) +
                          settings.allowedIntervals['$defaultInterval']!,
                      width:
                          (config.totalHeaders * config.cellWidth!).toDouble(),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (var i = 0; i < config.totalHours; i++)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          (config.cellHeight! - 1).toDouble(),
                                    ),
                                    const Divider(
                                      height: 1,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (var i = 0; i < config.totalHeaders; i++)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      width: (config.cellWidth! - 1).toDouble(),
                                    ),
                                    Container(
                                      width: 1,
                                      height: (config.totalHours *
                                              config.cellHeight!) +
                                          config.cellHeight! / defaultInterval,
                                      color: Colors.black12,
                                    )
                                  ],
                                )
                            ],
                          ),
                          for (int i = 0; i < tasks.length; i++) tasks[i],
                          if (currentTimeLine)
                            _calculateHorizontalLinePosition()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Calculates the position of a horizontal line representing the current time.
  ///
  /// This widget positions a horizontal line based on the current time relative to the
  /// start time of the schedule. The line's vertical position is calculated by converting
  /// the current time into minutes and then mapping it to the height of the cells in the schedule.
  ///
  /// Returns:
  /// - A [Positioned] widget containing a [Container] representing the horizontal line.
  Widget _calculateHorizontalLinePosition() {
    DateTime now = DateTime.now();
    int totalMinutesNow = now.hour * 60 + now.minute;
    num totalMinutesStart = widget.scheduleStartTime.hour * 60 + 0;

    double totalOffset = (totalMinutesNow - totalMinutesStart) *
        config.cellHeight!.toDouble() /
        60.0;

    return Positioned(
      left: 0,
      top: totalOffset,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 1,
            width: (config.totalHeaders * config.cellWidth!).toDouble(),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  /// Function to calculate the height of timeline divider based on interval
  int _getTimelineDividerHeight(int interval) {
    int height = 0;

    switch (interval) {
      case 5: 
        height = 545;
        break;
      case 10:
        height = (kIsWeb) ? 270 : 270;
        break;
      case 20:
        height = 320;
        break;
      case 30:
        height = 200;
        break;
      case 60:
        height = 380;
        break;
      default:
        height = (kIsWeb) ? 250 : 250;
        break;
    }

    return height;
  }

  /// Generates a list of time slots between the schedule's start and end times in 24-hour format.
  ///
  /// This function creates a list of time slots based on the schedule's start time, end time, 
  /// and the minute interval (if specified). It ensures the intervals are valid (<= 60 minutes) 
  /// and adjusts the time slots according to the specified interval or defaults to hourly intervals.
  ///
  /// If the minute interval is provided, it generates time slots with that interval, otherwise,
  /// it defaults to creating time slots every hour (e.g., "08:00", "09:00").
  List<String> _get24HourTimeline() {
    //DateTime currentDateTime = DateTime.now();

    List<String> timeSlots = [];
    //List<String> slots = [];

    if (widget.timeFormat?.minuteInterval != null) {
      if (widget.timeFormat!.minuteInterval! > 60) {
        throw FlutterError(
            "TaskSchedulerError Minutes interval should be lower or equal to 60");
      }

      for (int i = widget.scheduleStartTime.hour;
          i <= widget.scheduleEndTime.hour;
          i++) {
        for (int j = 0; j < 60; j += widget.timeFormat!.minuteInterval!) {
          String hour = i.toString().padLeft(2, '0');
          String minute = j.toString().padLeft(2, '0');
          String time = '$hour:$minute';
          timeSlots.add(time);
        }
      }
    } else {
      for (int i = widget.scheduleStartTime.hour;
          i <= widget.scheduleEndTime.hour;
          i++) {
        String hour = i.toString().padLeft(2, '0');
        String time = '$hour:00';
        timeSlots.add(time);
      }
    }

    timeSlots = _checkStartEndTimes(timeSlots);

    return timeSlots;
  }

  // Function to generate 12-hour timeline
  List<String> _get12HourTimeline() {
    List<String> timeSlots = [];
    List<String> slots = [];
    String startHour = widget.scheduleStartTime.hour.toString();
    String startMinute = '0';

    int endHourIn12HourFormat = widget.scheduleEndTime.hour;
    endHourIn12HourFormat = (endHourIn12HourFormat > 12)
        ? endHourIn12HourFormat - 12
        : endHourIn12HourFormat;

    String endHour = endHourIn12HourFormat.toString();
    String endMinute = '0';

    String sh = startHour.padLeft(2, '0');
    String sm = startMinute.padLeft(2, '0');
    String eh = endHour.padLeft(2, '0');
    String em = endMinute.padLeft(2, '0');

    String startTime = '$sh:$sm';
    String endTime = '$eh:$em';

    bool includePeriod = false;

    if (widget.timeFormat?.includePeriod != null) {
      includePeriod = widget.timeFormat!.includePeriod!;
    }

    if (widget.timeFormat!.minuteInterval != null) {
      if (widget.timeFormat!.minuteInterval! > 60) {
        throw FlutterError(
            "TaskSchedulerError Minutes interval should be lower or equal to 60");
      }

      for (int i = widget.scheduleStartTime.hour;
          i <= widget.scheduleEndTime.hour;
          i++) {
        int h = i;

        if (i > 12) {
          h = h - 12;
        }

        for (int j = 0; j < 60; j += widget.timeFormat!.minuteInterval!) {
          String hour = h.toString().padLeft(2, '0');
          String minute = j.toString().padLeft(2, '0');
          String time = '$hour:$minute';
          timeSlots.add(time);
        }
      }

      timeSlots = _addPeriod(timeSlots);
      timeSlots = filterTimes(timeSlots, startTime, '${endTime}pm');

      if (!includePeriod) {
        String slotString = timeSlots.join(',');
        slotString = slotString.replaceAll('am', '').replaceAll('pm', '');

        timeSlots = slotString.split(',');
      }
    } else {
      for (int i = widget.scheduleStartTime.hour;
          i <= widget.scheduleEndTime.hour;
          i++) {
        String hour = i.toString().padLeft(2, '0');
        String time = (includePeriod) ? '$hour:00am' : '$hour:00';

        if (i > 12) {
          int h = i - 12;
          hour = h.toString().padLeft(2, '0');
          time = (includePeriod) ? '$hour:00pm' : '$hour:00';
        }

        time = _addMinutes(time);
        timeSlots.add(time);
      }
    }

    return timeSlots;
  }

  /// Adds a period (AM/PM) suffix to each time slot in the list.
  ///
  /// This function iterates through a list of time slots in "HH:MM" format 
  /// and appends the appropriate "am" or "pm" suffix to each slot based on 
  /// whether the hour is before or after noon. The resulting list of time slots 
  /// will include the correct period suffix for each time.
  ///
  /// - [slots]: A list of time slots in "HH:MM" format (e.g., "08:00", "13:30") 
  ///   to which the "am" or "pm" period will be added.
  ///
  /// Returns a list of time slots with the period suffix added (e.g., "08:00am", "01:00pm").
  List<String> _addPeriod(List<String> slots) {
    List<String> newSlots = [];
    String suffix = 'am';

    for (var slot in slots) {
      final parts = slot.split(':');
      final hour = int.parse(parts[0]);

      if (hour >= 12) {
        suffix = 'pm';
      }

      newSlots.add('$slot$suffix');
    }

    return newSlots;
  }

  /// Filters a list of time slots to include only those within the schedule's 
  /// start and end time range.
  ///
  /// This function compares each time slot in the provided list with the 
  /// schedule's start and end times. Only the time slots that fall within 
  /// the range (inclusive) are included in the returned list.
  ///
  /// - [slots]: A list of time slots in "HH:MM" format (e.g., "08:00", "14:30") 
  ///   to be filtered based on the schedule's start and end times.
  ///
  /// Returns a list of time slots that are within the start and end times range.
  List<String> _checkStartEndTimes(List<String> slots) {
    String startHour = widget.scheduleStartTime.hour.toString();
    String startMinute = '0';
    String endHour = widget.scheduleEndTime.hour.toString();
    String endMinute = '0';

    String sh = startHour.padLeft(2, '0');
    String sm = startMinute.padLeft(2, '0');
    String eh = endHour.padLeft(2, '0');
    String em = endMinute.padLeft(2, '0');

    String startTime = '$sh:$sm';
    String endTime = '$eh:$em';

    List<String> filteredTimeSlots = slots.where((time) {
      // Compare time slots with the start and end times
      return time.compareTo(startTime) >= 0 && time.compareTo(endTime) <= 0;
    }).toList();

    return filteredTimeSlots;
  }

  /// Filters a list of times to include only those within the specified time range.
  ///
  /// This function converts the provided `startTime` and `endTime` to the total 
  /// number of minutes past midnight, then filters the list of times, returning 
  /// only those that fall within the range between `startTime` and `endTime` 
  /// (inclusive).
  ///
  /// - [times]: A list of time strings in 12-hour format (e.g., "01:00am") to filter.
  /// - [startTime]: The start time in 12-hour format (e.g., "08:00am").
  /// - [endTime]: The end time in 12-hour format (e.g., "05:00pm").
  ///
  /// Returns a list of times that are within the specified range.
  List<String> filterTimes(
      List<String> times, String startTime, String endTime) {
    int startMinutes = convertToMinutesPastMidnight(startTime);
    int endMinutes = convertToMinutesPastMidnight(endTime);

    return times.where((time) {
      int currentMinutes = convertToMinutesPastMidnight(time);
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    }).toList();
  }

  /// Converts a 12-hour formatted time string to the total number of minutes 
  /// past midnight (00:00).
  /// 
  /// This function takes a time string in the 12-hour format (e.g., "01:30pm") 
  /// and converts it to the total number of minutes that have passed since midnight.
  ///
  /// - [time]: The time string in 12-hour format (e.g., "08:45am", "01:30pm").
  ///
  /// Returns the total number of minutes since midnight.
  int convertToMinutesPastMidnight(String time) {
    List<String> parts = time.replaceAll(RegExp(r'[a-zA-Z]'), '').split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    if (time.toLowerCase().contains('pm') && hours != 12) {
      hours += 12;
    } else if (time.toLowerCase().contains('am') && hours == 12) {
      hours = 0;
    }

    return hours * 60 + minutes;
  }

  // Function to filter time slots between start and end times in 12-hour format
  List<String> _checkStartEndTimes12HourFormat(List<String> slots) {
    String startHour = widget.scheduleStartTime.hour.toString();
    String startMinute = '0';
    String endHour = widget.scheduleEndTime.hour.toString();
    String endMinute = '0';

    String sh = startHour.padLeft(2, '0');
    String sm = startMinute.padLeft(2, '0');
    String eh = endHour.padLeft(2, '0');
    String em = endMinute.padLeft(2, '0');

    String startTime = '$sh:$sm';
    String endTime = '$eh:$em';

    List<String> filteredTimeSlots = filterTimes(slots, startTime, endTime);

    return filteredTimeSlots;
  }

  /// Filters a list of times to include only those within the specified time range.
  /// 
  /// This function converts the provided `startTime` and `endTime` from 12-hour 
  /// to 24-hour format (if necessary) and then filters the list of times, 
  /// returning only those that fall within the range between `startTime` and 
  /// `endTime` (inclusive).
  ///
  /// - [times]: A list of time strings in 12-hour format (e.g., "01:00pm") to filter.
  /// - [startTime]: The start time in 12-hour format (e.g., "08:00am").
  /// - [endTime]: The end time in 12-hour format (e.g., "05:00pm").
  ///
  /// Returns a list of times that are within the specified range.
  List<String> filterTimesWithPeriod(
      List<String> times, String startTime, String endTime) {
    // Convert the end time from 12-hour to 24-hour format
    if (endTime.toLowerCase().contains('pm') && !endTime.startsWith('12')) {
      List<String> parts =
          endTime.replaceAll(RegExp(r'[a-zA-Z]'), '').split(':');
      int hours = int.parse(parts[0]) + 12;
      endTime = '$hours:${parts[1]}';
    } else if (endTime.toLowerCase().contains('am') &&
        endTime.startsWith('12')) {
      endTime = '00:${endTime.substring(3, 5)}';
    }

    return times.where((time) {
      // Convert time from 12-hour to 24-hour format for comparison
      String formattedTime = time.endsWith('pm')
          ? '${int.parse(time.substring(0, 2)) + 12}:${time.substring(3, 5)}'
          : time;

      // Compare the times in HH:MM format
      return formattedTime.compareTo(startTime) >= 0 &&
          formattedTime.compareTo(endTime) <= 0;
    }).toList();
  }

  // Function to add minutes to time if necessary
  String _addMinutes(String time) {
    if (widget.timeFormat?.includeMinutes != null) {
      if (!widget.timeFormat!.includeMinutes!) {
        time = time.replaceAll(':00', '');
      }
    }

    return time;
  }

  // Function to format DateTime object to 'h:mm a' format
  DateTime _formatDateTime(DateTime dateTime) {
    DateFormat formatter = DateFormat('h:mm a');
    String formattedTime = formatter.format(dateTime); // Format to '8:30 AM'

    // Extract hour and minute from the formatted time string
    List<String> timeComponents = formattedTime.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1].split(' ')[0]); // Extract minute
    String period = timeComponents[1].split(' ')[1]; // Extract AM/PM

    // Create a new DateTime object with the extracted components
    return DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
  }

  // Function to calculate cell height based on interval
  int _getCellHeight(int interval) {
    int height = 0;

    switch (interval) {
      case 5:
        height = 500;
        break;
      case 10:
        height = 230;
        break;
      case 20:
        height = 240;
        break;
      case 30:
        height = 130;
        break;
      case 60:
        height = 190;
        break;
      default:
        height = 200;
        break;
    }

    return height;
  }

  // Function to calculate cell width based on size
  int _getCellWidth(BuildContext context, int size) {
    double screenWidth = MediaQuery.of(context).size.width;
    int width = 0;

    switch (size) {
      case 1:
        width = (screenWidth).toInt();
        break;
      case 2:
        width = (screenWidth ~/ 2).toInt();
        break;
      default:
        width = (kIsWeb) ? (screenWidth ~/ size).toInt() : (screenWidth ~/ 3).toInt();
        break;
    }

    return width;
  }

  /// Adds empty schedule slots for each resource and time slot.
  ///
  /// This function iterates over the provided time slots and resources, creating 
  /// empty schedule entries for each time slot that occurs before the schedule 
  /// end time. These empty slots are added as transparent entries in the schedule.
  ///
  /// - [minutesIntervals]: The duration (in minutes) for each empty slot.
  /// - [timeSlots]: A list of time slots in "HH:mm" format to generate empty slots for.
  void addEmptySlots(int minutesIntervals, List<String> timeSlots) {
    for (ScheduleResourceHeader res in widget.headers) {
      for (int i = 0; i < timeSlots.length; i++) {
        List<String> timeparts = timeSlots[i].split(':');
        int hour = int.parse(timeparts[0]);
        int minute = int.parse(timeparts[1]);

        DateTime currentDateTime = DateTime.now();
        DateTime timePlannerDateTime = DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day,
          widget.scheduleEndTime.hour,
          0,
          currentDateTime.second,
          currentDateTime.millisecond,
          currentDateTime.microsecond,
        );

        DateTime timelineDateTime = DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day,
          hour,
          minute,
          currentDateTime.second,
          currentDateTime.millisecond,
          currentDateTime.microsecond,
        );

        if (timelineDateTime.isBefore(timePlannerDateTime) ||
            !timelineDateTime.isAfter(timePlannerDateTime)) {
          addNewEntry(ScheduleEntry(
            color: Colors.transparent,
            id: res.id,
            resource: ResourceScheduleEntry(
                index: res
                    .position, // uses resource index to assign an entry, i.e. 0 = 1st resource, 1 = 2nd etc
                hour: int.parse(timeparts[0]),
                minutes: int.parse(timeparts[1])),
            duration: minutesIntervals,
            options: TaskSchedulerSettings(isTaskDraggable: false),
            onDragCallback: (Map<String, dynamic> data) {
              if (widget.onDragAccept != null) {
                widget.onDragAccept!(data);
              }
            },
            onTap: () {
              widget.onEmptySlotPressed({
                'resource_id': res.id,
                'resource_title': res.title,
                'resource': {
                  'index': res.position,
                  'hour': int.parse(timeparts[0]),
                  'minutes': int.parse(timeparts[1])
                },
              });
            },
            child: Text(''),
          ));
        }
      }
    }
  }

  /// Adds a new schedule entry if it doesn't already exist.
  ///
  /// This function checks if the task with the same time and ID already exists in
  /// the `tasks` list. If it exists, the entry is not added, and the function
  /// returns `false`. Otherwise, the new task is added to the list, and the 
  /// function returns `true`.
  ///
  /// - [toAdd]: The new [ScheduleEntry] to add to the list.
  ///
  /// Returns a boolean indicating whether the entry was successfully added.
  bool addNewEntry(ScheduleEntry toAdd) {
    bool taskExists = false;

    for (ScheduleEntry task in tasks) {
      if (task.resource.hour == toAdd.resource.hour &&
          task.resource.minutes == toAdd.resource.minutes &&
          task.id == toAdd.id) {
        taskExists = true;
        break;
      }
    }

    if (taskExists) {
      return false;
    } else {
      tasks.add(toAdd);
      return true;
    }
  }

  /// Adds a time slot widget with the formatted time.
  ///
  /// This function takes a time string, formats it based on the user's time 
  /// settings (12-hour or 24-hour format), and returns a widget displaying 
  /// the formatted time in a specific layout.
  Widget addTimeSlot(String time) {
    double remainder = 60 / defaultInterval;
    bool showHoursOnly = widget.timeFormat?.showHoursOnly ?? false;

    if (widget.timeFormat?.use24HourFormat != null) {
      if (!widget.timeFormat!.use24HourFormat!) {
        bool includePeriod = widget.timeFormat?.includePeriod ?? false;
        bool includeMinutes = widget.timeFormat?.includeMinutes ?? true;

        List<String> timeParts = time.split(':');

        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        if (hour > 12) {
          hour -= 12;
          time = (hour < 10) ? '0$hour' : '$hour';
          time = (minute < 10) ? '$time:0$minute' : '$time:$minute';

          if (includePeriod) {
            time = '${time}pm';
            time = time.replaceAll(':00', '');
          }
        } else {
          if (includePeriod) {
            time = (hour == 12) ? '${time}pm' : '${time}am';
            time = time.replaceAll(':00', '');
          }
        }

        if (!includeMinutes && defaultInterval == 60) {
          time = time.replaceAll(':00', '');
        } else {
          if (includePeriod) {
            String min = (minute < 10) ? '0$minute' : '$minute';
            time = time
                .replaceAll(':${minute}am', ':${min}am')
                .replaceAll(':${minute}pm', ':${min}pm');
          }
        }
      }
    }

    if (use24HourFormat && showHoursOnly && !time.contains('00')) {
      time = '';
    }

    if (time.startsWith('24')){
      time = time.replaceAll('24', '00');
    }

    return SizedBox(
      height: ((config.cellHeight!.toDouble() / remainder)),
      width: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Center(
            child: Text(
          time,
          style: const TextStyle(fontSize: 14.0),
        )),
      ),
    );
  }
}
