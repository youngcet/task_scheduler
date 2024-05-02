import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:task_scheduler/src/blocked_entry.dart';
import 'package:task_scheduler/src/calendar_view.dart';
import 'package:task_scheduler/src/task_scheduler_datetime.dart';
import 'package:task_scheduler/src/task_scheduler_timeline.dart';
import 'config.dart' as config;
import 'package:task_scheduler/src/task_scheduler_event.dart';
import 'package:task_scheduler/src/task_scheduler_header.dart';
import 'package:task_scheduler/src/task_scheduler_settings.dart';
import 'package:task_scheduler/src/task_scheduler_time.dart';
import 'package:task_scheduler/src/task_scheduler_time_format.dart';

/// Widget for displaying a task scheduler.
class TaskScheduler extends StatefulWidget {
  // Start time of the schedule
  final ScheduleTimeline scheduleStartTime;

  // End time of the schedule
  final ScheduleTimeline scheduleEndTime;

  // Headers for resources in the scheduler
  final List<ScheduleResourceHeader> headers;

  // List of schedule entries
  final List<ScheduleEntry>? entries;

  // Time format settings for the scheduler
  final SchedulerTimeSettings? timeFormat;

  // Options for the scheduler
  final TaskSchedulerSettings? options;

  // Callback function when an empty slot is pressed
  final Function(Map<String, dynamic>) onEmptySlotPressed;

  // Callback function when a drag action is accepted
  final Function(Map<String, dynamic>)? onDragAccept;

  // Configure if entries can overlap
  final bool? allowEntryOverlap;

  // block off Resources
  final List<BlockedEntry>? blockedEntries;

  // Constructor for TaskScheduler widget
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
      this.onDragAccept})
      : super(key: key);

  @override
  _TaskSchedulerState createState() => _TaskSchedulerState();

  // Method to get the timeline for the scheduler
  List<String> getTimeline() {
    DateTime currentDateTime = DateTime.now();

    List<String> timeSlots = [];
    List<String> slots = [];

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

  // Method to compare time slots with start and end times
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

  @override
  void initState() {
    super.initState();

    if (widget.timeFormat?.minuteInterval != null) {
      defaultInterval = widget.timeFormat!.minuteInterval!;
    }

    _validateData();

    settings.backgroundColor = widget.options?.backgroundColor;
    settings.cellHeight = _getCellHeight(defaultInterval);
    settings.cellWidth = _getCellWidth(widget.headers.length);
    settings.horizontalTaskPadding = 0;
    settings.borderRadius = const BorderRadius.all(Radius.circular(8.0));
    settings.dividerColor = widget.options?.dividerColor;

    config.horizontalTaskPadding = settings.horizontalTaskPadding;
    config.cellHeight = settings.cellHeight;
    config.cellWidth = settings.cellWidth;
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
  }

  // Method to validate schedule start and end times
  void _validateData() {
    if (widget.scheduleStartTime.hour == 0 ||
        widget.scheduleEndTime.hour == 0) {
      throw FlutterError(
          "TaskSchedulerError startTime or endTime hour can not be zero.");
    }

    if (widget.scheduleEndTime.hour < 12 || widget.scheduleEndTime.hour > 23) {
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
          "TaskSchedulerError minute intervals [10, 15, 20, 30, 60]");
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
                      buildScheduleGrid(),
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

  Widget buildScheduleGrid() {
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

  // Function to calculate the height of timeline divider based on interval
  int _getTimelineDividerHeight(int interval) {
    int height = 0;

    switch (interval) {
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

  // Function to generate 24-hour timeline
  List<String> _get24HourTimeline() {
    DateTime currentDateTime = DateTime.now();

    List<String> timeSlots = [];
    List<String> slots = [];

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

  // Function to add period (AM/PM) to time slots
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

  // Function to check and filter start and end times
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

  // Function to filter time slots between start and end times
  List<String> filterTimes(
      List<String> times, String startTime, String endTime) {
    int startMinutes = convertToMinutesPastMidnight(startTime);
    int endMinutes = convertToMinutesPastMidnight(endTime);

    return times.where((time) {
      int currentMinutes = convertToMinutesPastMidnight(time);
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    }).toList();
  }

  // Function to convert time to minutes past midnight
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

  // Function to filter time slots between start and end times with AM/PM period
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
  int _getCellWidth(int size) {
    int width = 0;

    switch (size) {
      case 1:
        width = 320;
        break;
      case 2:
        width = 170;
        break;
      default:
        width = 150;
        break;
    }

    return width;
  }

  // Function to add empty slots to the schedule grid
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

  // Function to add a new entry
  bool addNewEntry(ScheduleEntry toAdd) {
    bool taskExists = false;

    for (ScheduleEntry task in tasks ?? []) {
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

  // Widget timesline
  Widget addTimeSlot(String time) {
    double remainder = 60 / defaultInterval;

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
                .replaceAll('am', ':${min}am')
                .replaceAll('pm', ':${min}pm');
          }
        }
      }
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
