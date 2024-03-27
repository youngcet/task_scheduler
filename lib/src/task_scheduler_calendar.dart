import 'package:flutter/widgets.dart';

class TaskSchedulerCalendar extends StatefulWidget {
  final int startHour;
  final int startHourMinute;
  final int endHourHour;
  final int endHourHourMinute;
  final int minuteInterval;

  const TaskSchedulerCalendar({
    Key? key,
    required this.startHour,
    required this.startHourMinute,
    required this.endHourHour,
    required this.endHourHourMinute,
    required this.minuteInterval,
  }) : super(key: key);

  @override
  _TaskSchedulerCalendarState createState() => _TaskSchedulerCalendarState();
}

class _TaskSchedulerCalendarState extends State<TaskSchedulerCalendar> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
