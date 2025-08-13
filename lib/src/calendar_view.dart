import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../task_scheduler.dart';

/// A class representing a calendar view with utility methods to generate headers
/// for a week view.
class CalendarView {
  /// Represents the abbreviation for Monday.
  static const String monday = 'mon';

  /// Represents the abbreviation for Sunday.
  static const String sunday = 'sun';

  /// Generates a list of schedule resource headers for the week view.
  ///
  /// The [showOneLetterWeekDayName] parameter specifies whether to show only
  /// the first letter of the weekday name. Default is `true`.
  ///
  /// The [firstDayOfWeek] parameter specifies the first day of the week.
  /// Default is `null`, which defaults to Sunday.
  ///
  /// The [upperCaseWeekDayName] parameter specifies whether to display the
  /// weekday name in uppercase. Default is `false`.
  ///
  /// The [showOnlyWeekDay] parameter specifies whether to show only the weekday
  /// without the date. Default is `false`.
  ///
  /// The [showFullMonth] parameter specifies whether to show the entire month or not
  /// Default is `false`.
  ///
  /// Returns a list of [ScheduleResourceHeader] objects representing the headers
  /// for the week view.
  static List<ScheduleResourceHeader> weekView(
      {bool? showOneLetterWeekDayName,
      String? firstDayOfWeek,
      bool? upperCaseWeekDayName,
      bool? showOnlyWeekDay,
      bool? showFullMonth}) {
    bool oneLetterDayWeek = showOneLetterWeekDayName ?? true;
    bool upperCaseDayName = upperCaseWeekDayName ?? false;
    bool weekDayOnly = showOnlyWeekDay ?? false;

    List<ScheduleResourceHeader> headers = [];
    List<DateTime> weekDates =
        _getCurrentWeekDates(firstDayOfWeek, showFullMonth);
    DateTime now = DateTime.now();

    int index = 0;
    for (var element in weekDates) {
      DateTime dateTime = element;
      List<String> dayAbbreviations =
          DateFormat.EEEE().format(dateTime).split('');
      String currentDayLetter = (oneLetterDayWeek)
          ? dayAbbreviations[0]
          : '${dayAbbreviations[0]}${dayAbbreviations[1]}${dayAbbreviations[2]}';
      String title = dayAbbreviations.join('');

      if (upperCaseDayName) {
        currentDayLetter = currentDayLetter.toUpperCase();
      }

      headers.add(ScheduleResourceHeader(
        id: '$index',
        position: index,
        title: title,
        typeOf: CalendarView,
        child: (weekDayOnly)
            ? _onlyWeekDayNameWidget(currentDayLetter, now, dateTime)
            : _weekViewWidget(currentDayLetter, now, dateTime),
      ));

      index++;
    }

    return headers;
  }

  /// Generates a list of schedule resource headers for the week view with month.
  ///
  /// The [firstDayOfWeek] parameter specifies the first day of the week.
  /// Default is `null`, which defaults to Sunday.
  ///
  /// Returns a list of [ScheduleResourceHeader] objects representing the headers
  /// for the week view with month.
  static Widget _weekViewWidget(
      String currentDayLetter, DateTime now, DateTime dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          currentDayLetter,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 3,
        ),
        (now.day == dateTime.day)
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${dateTime.day}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              )
            : Text(
                '${dateTime.day}',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
      ],
    );
  }

  /// Generates a list of [DateTime] objects representing the dates of the
  /// current week.
  ///
  /// The [startDay] parameter specifies the first day of the week. Default is
  /// [CalendarView.sunday].
  ///
  /// Returns a list of [DateTime] objects representing the dates of the current week.
  static Widget _onlyWeekDayNameWidget(
      String day, DateTime now, DateTime dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        (now.day == dateTime.day)
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              )
            : Text(
                day,
                style: const TextStyle(fontSize: 20),
              ),
      ],
    );
  }

  /// Generates a list of schedule resource headers for the week view with month.
  ///
  /// The [firstDayOfWeek] parameter specifies the first day of the week.
  /// Default is `null`, which defaults to Sunday.
  ///
  /// The [showFullMonth] parameter specifies whether to show the entire month or not
  /// Default is `false`.
  ///
  /// Returns a list of [ScheduleResourceHeader] objects representing the headers
  /// for the week view with month.
  static List<ScheduleResourceHeader> weekViewWithMonth(
      {String? firstDayOfWeek, bool? showFullMonth}) {
    List<ScheduleResourceHeader> headers = [];
    List<DateTime> weekDates =
        _getCurrentWeekDates(firstDayOfWeek, showFullMonth);
    DateTime now = DateTime.now();
    String monthAbbreviation = DateFormat('MMM').format(now);

    int index = 0;
    for (var element in weekDates) {
      DateTime dateTime = element;
      List<String> dayAbbreviations =
          DateFormat.EEEE().format(dateTime).split('');
      String currentDayName =
          '${dayAbbreviations[0]}${dayAbbreviations[1]}${dayAbbreviations[2]}';
      String title = dayAbbreviations.join('');

      headers.add(ScheduleResourceHeader(
        id: '$index',
        position: index,
        typeOf: CalendarView,
        height: 100,
        title: title,
        child: Card(
            color: (now.day == dateTime.day) ? Colors.blue : Colors.white,
            elevation: 4, // Adjust the elevation to change the shadow intensity
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12), // Adjust the border radius as needed
            ),
            child:
                _getWidget(now, dateTime, monthAbbreviation, currentDayName)),
      ));

      index++;
    }

    return headers;
  }

  // This method returns a widget that displays the month abbreviation, day, and day name.
  // It checks if the provided `dateTime` matches the current day (based on `now.day`).
  // If it is the current day, the text is styled with white color, otherwise it uses the default style.
  static Widget _getWidget(DateTime now, DateTime dateTime,
      String monthAbbreviation, String currentDayName) {
    return (now.day == dateTime.day)
        ? Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  monthAbbreviation,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      '${dateTime.day}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  currentDayName,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  monthAbbreviation,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      '${dateTime.day}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  currentDayName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }

  /// Retrieves the dates for the current week.
  ///
  /// The [startDay] parameter specifies the first day of the week.
  /// Default is `null`, which defaults to Sunday.
  ///
  /// Returns a list of [DateTime] objects representing the dates of the current week.
  static List<DateTime> _getCurrentWeekDates(
      String? startDay, bool? showFullMonth) {
    bool _showFullMonth = showFullMonth ?? false;
    if (!_showFullMonth) {
      String weekStartDay = startDay ?? sunday;
      List<DateTime> weekDates = [];

      // Get today's date
      DateTime today = DateTime.now();

      // Find the first day of the current week (Sunday)
      DateTime firstDayOfWeek = (weekStartDay == CalendarView.monday)
          ? today.subtract(Duration(days: today.weekday - 1))
          : today.subtract(Duration(days: today.weekday % 7));

      // Add the dates of the current week to the list
      for (int i = 0; i < 7; i++) {
        weekDates.add(firstDayOfWeek.add(Duration(days: i)));
      }

      return weekDates;
    } else {
      String weekStartDay = startDay ?? sunday;
      List<DateTime> weekDates = [];

      // Get today's date
      DateTime today = DateTime.now();
      var lastDayOfTheMonth = (today.month < 12)
          ? DateTime(today.year, today.month + 1, 0)
          : DateTime(today.year + 1, 1, 0);

      // Find the first day of the current week (Sunday)
      // DateTime firstDayOfWeek = (weekStartDay == CalendarView.monday)
      //     ? today.subtract(Duration(days: today.weekday - 1))
      //     : today.subtract(Duration(days: today.weekday % 7));

      // Add the dates of the current week to the list
      for (int i = 1; i <= lastDayOfTheMonth.day; i++) {
        weekDates.add(DateTime(today.year, today.month, i));
      }

      return weekDates;
    }
  }
}
