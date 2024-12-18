import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_scheduler/task_scheduler.dart';

// Task Schedule View class
class TaskScheduleView {
  // Task Scheduler
  final TaskScheduler taskScheduler;

  // Constructor for TaskScheduleView
  TaskScheduleView({required this.taskScheduler});

  // Method to load the schedule view with given entries
  TaskScheduler loadScheduleView({required List<ScheduleEntry> entries}) {
    // Clear existing entries
    taskScheduler.entries?.clear();

    List<String> timeSlots = taskScheduler.getTimeline();
    _addEmptySlots(timeSlots);
    _blockEntries();

    taskScheduler.entries?.addAll(entries);

    return taskScheduler;
  }

  /// Handles the resizing of a schedule entry.
  ///
  /// This function adjusts the duration of the given [ScheduleEntry] if it
  /// overlaps with other entries or extends beyond the schedule's closing hour.
  ///
  /// - If the entry extends beyond the closing hour, its duration is reduced
  ///   to fit within the closing hour.
  /// - If the entry overlaps with other entries of the same resource, its
  ///   duration is reduced to avoid overlap.
  ///
  /// The function assumes a fixed date for the calculation since only the time
  /// of the entries matters.
  ///
  /// Parameters:
  /// - [entry]: The schedule entry that is being resized.
  void onResizeEntry(ScheduleEntry entry) {
    int resourceId = entry.resource.index;
    String id = entry.id;
    int entryIndex =
        taskScheduler.entries?.indexWhere((task) => task.id == id) ?? -1;

    // hard coded year, month and day because the date doesn't matter, only time
    DateTime entryStartTime = DateTime(
        ScheduleEntry.defaultYear,
        ScheduleEntry.defaultMonth,
        ScheduleEntry.defaultDay,
        entry.resource.hour,
        entry.resource.minutes);
    DateTime entryEndTime =
        entryStartTime.add(Duration(minutes: entry.duration));
    DateTime closingHour = DateTime(
        ScheduleEntry.defaultYear,
        ScheduleEntry.defaultMonth,
        ScheduleEntry.defaultDay,
        taskScheduler.scheduleEndTime.hour,
        0);

    if (entryEndTime.isAfter(closingHour)) {
      Duration difference = entryEndTime.difference(closingHour);
      int differenceInMinutes = difference.inMinutes;
      taskScheduler.entries?[entryIndex].duration -= differenceInMinutes;
    } else {
      List<ScheduleEntry> filteredEntries = taskScheduler.entries!
          .where((entry) =>
              entry.id != id &&
              entry.resource.index == resourceId &&
              entry.color != Colors.transparent)
          .toList();

      filteredEntries.removeWhere((element) {
        DateTime startTime = DateTime(
            ScheduleEntry.defaultYear,
            ScheduleEntry.defaultMonth,
            ScheduleEntry.defaultDay,
            element.resource.hour,
            element.resource.minutes);

        return entryEndTime.isAfter(startTime);
      });

      for (var element in filteredEntries) {
        DateTime startTime = DateTime(
            ScheduleEntry.defaultYear,
            ScheduleEntry.defaultMonth,
            ScheduleEntry.defaultDay,
            element.resource.hour,
            element.resource.minutes);

        if (entryEndTime.isAfter(startTime)) {
          // entry overlaps with another entry
          // minus the difference in minutes
          //taskScheduler.entries![entryIndex].duration = 30;
          Duration difference = entryEndTime.difference(startTime);
          int differenceInMinutes = difference.inMinutes;
          taskScheduler.entries?[entryIndex].duration -= differenceInMinutes;
        }
      }
    }
  }

  void _updateDuration(int entryIndex, int differenceInMinutes) {
    if (taskScheduler.entries != null &&
        taskScheduler.entries!.length > entryIndex) {
      int currentDuration = taskScheduler.entries![entryIndex].duration;
      int newDuration = (currentDuration * 2) - differenceInMinutes;
      taskScheduler.entries![entryIndex].duration =
          max(currentDuration, newDuration);
    }
  }

  // Method to update the schedule view
  TaskScheduler updateScheduleView(
      TaskScheduleView view, Map<String, dynamic> data) {
    String id = data['fromId'];
    String resourceIndex = view.taskScheduler.headers[data['resourceIndex']].id;
    String fromResourceIndex =
        view.taskScheduler.headers[data['fromResourceIndex']].id;
    int duration = data['duration'];

    int bookedhour = data['hour'];
    int bookedminutes = data['minutes'];

    String hour = bookedhour.toString();
    String min = bookedminutes.toString();
    if (bookedhour < 10) {
      hour = '0$hour';
    }

    if (bookedminutes < 10) {
      min = '0$min';
    }

    String starthour = '$hour:$min';
    int indexToRemove =
        view.taskScheduler.entries?.indexWhere((task) => task.id == id) ?? -1;

    if (indexToRemove != -1) {
      bool isSlotAvailable = true;

      // check if entries are set to overlap or not
      bool allowOverlapping = taskScheduler.allowEntryOverlap ?? false;
      if (!allowOverlapping) {
        DateTime newStartTime = DateTime(1999, 1, 1, bookedhour, bookedminutes);
        DateTime newEndTime =
            newStartTime.add(Duration(minutes: data['duration']));
        DateTime closingHour =
            DateTime(1999, 1, 1, taskScheduler.scheduleEndTime.hour, 0);

        if (newEndTime.isAfter(closingHour) &&
            !newEndTime.isAtSameMomentAs(closingHour)) {
          isSlotAvailable = false;
        }

        if (isSlotAvailable) {
          taskScheduler.entries?.forEach((entry) {
            // String entryType = entry.data?['data'];
            // Colors.transparent means an empty slot
            if (entry.color != Colors.transparent &&
                entry.resource.index == data['resourceIndex'] && entry.id != id) {
              DateTime entryStartTime = DateTime(
                  1999, 1, 1, entry.resource.hour, entry.resource.minutes);
              DateTime entryEndTime =
                  entryStartTime.add(Duration(minutes: entry.duration));

              if (!(newStartTime.isAfter(entryEndTime) ||
                      (newEndTime.isBefore(entryStartTime))) &&
                  !newEndTime.isAtSameMomentAs(entryStartTime) &&
                  !newStartTime.isAtSameMomentAs(entryEndTime)) {
                isSlotAvailable = false;
                return;
              }
            }
          });
        }
      }

      if (isSlotAvailable) {
        view.taskScheduler.entries?.removeAt(indexToRemove);

        view.taskScheduler.entries?.add(ScheduleEntry(
          color: data['bgColor'],
          id: id,
          resource: ResourceScheduleEntry(
              index: data['resourceIndex'],
              hour: bookedhour,
              minutes: bookedminutes),
          duration: data['duration'],
          options: TaskSchedulerSettings(
              isTaskDraggable: true, taskResizeMode: data['taskResizeMode']),
          onTap: data['onTap'],
          child: data['child'],
          data: data['data'],
        ));
      } else {
        // throw an exception since overlap is the only reason a slot is not available
        throw Exception(
            'Overlapping Entry Periods Detected at $bookedhour:$bookedminutes');
      }
    }

    return view.taskScheduler;
  }

  // Method to check if a new entry can be added
  bool _addNewEntry(ScheduleEntry toAdd) {
    bool taskExists = false;

    for (ScheduleEntry task in taskScheduler.entries ?? []) {
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
      taskScheduler.entries?.add(toAdd);
      return true;
    }
  }

  // Method to add empty slots
  void _addEmptySlots(List<String> timeSlots) {
    for (ScheduleResourceHeader res in taskScheduler.headers) {
      for (int i = 0; i < timeSlots.length; i++) {
        List<String> timeparts = timeSlots[i].split(':');
        int hour = int.parse(timeparts[0]);
        int minute = int.parse(timeparts[1]);

        DateTime currentDateTime = DateTime.now();
        DateTime timePlannerDateTime = DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day,
          taskScheduler.scheduleEndTime.hour,
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
          _addNewEntry(ScheduleEntry(
            color: Colors.transparent,
            id: res.id,
            resource: ResourceScheduleEntry(
                index: res
                    .position, // uses resource index to assign an entry, i.e. 0 = 1st resource, 1 = 2nd etc
                hour: int.parse(timeparts[0]),
                minutes: int.parse(timeparts[1])),
            duration: taskScheduler.timeFormat?.minuteInterval ?? 60,
            options: TaskSchedulerSettings(isTaskDraggable: true),
            onDragCallback: (Map<String, dynamic> data) {
              if (taskScheduler.onDragAccept != null) {
                taskScheduler.onDragAccept!(data);
              }
            },
            data: const {'type': ScheduleEntry.empty},
            onTap: () {
              taskScheduler.onEmptySlotPressed({
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

  /// Blocks entries based on the blocked entries list.
  ///
  /// If [taskScheduler.blockedEntries] is not null, this method iterates through each
  /// entry and blocks the corresponding slots in the scheduler.
  void _blockEntries() {
    if (taskScheduler.blockedEntries != null) {
      for (BlockedEntry entry in taskScheduler.blockedEntries!) {
        int interval = taskScheduler.timeFormat!.minuteInterval ?? 60;
        int numberOfSlots = entry.duration ~/ interval;

        DateTime startTime = DateTime(
            ScheduleEntry.defaultYear,
            ScheduleEntry.defaultMonth,
            ScheduleEntry.defaultDay,
            entry.resource.hour,
            entry.resource.minutes);
        DateTime endTime = startTime;

        for (int i = 0; i < numberOfSlots; i++) {
          _addNewEntry(ScheduleEntry(
            color: Colors.grey.shade300,
            id: generateId(5),
            resource: ResourceScheduleEntry(
                index: entry.resource.index,
                hour: endTime.hour,
                minutes: endTime.minute),
            duration: interval,
            options: TaskSchedulerSettings(isTaskDraggable: false),
            data: {'type': ScheduleEntry.blocked, 'title': entry.title ?? ''},
          ));

          endTime = endTime.add(Duration(minutes: interval));
        }
      }
    }
  }

  /// Generates a random ID of the specified [length].
  ///
  /// Returns a randomly generated string ID consisting of alphanumeric characters.
  String generateId(int length) {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  /// Checks if a resource slot is available for the given [entryToAdd].
  ///
  /// Returns `true` if the slot is available, `false` otherwise.
  bool isResourceSlotAvailable(ScheduleEntry entryToAdd) {
    bool isSlotAvailable = true;

    // check if entries are set to overlap or not
    DateTime newStartTime = DateTime(
        1999, 1, 1, entryToAdd.resource.hour, entryToAdd.resource.minutes);
    DateTime newEndTime =
        newStartTime.add(Duration(minutes: entryToAdd.duration));
    DateTime closingHour =
        DateTime(1999, 1, 1, taskScheduler.scheduleEndTime.hour, 0);

    if (newEndTime.isAfter(closingHour) &&
        !newEndTime.isAtSameMomentAs(closingHour)) {
      isSlotAvailable = false;
    }

    if (isSlotAvailable) {
      taskScheduler.entries?.forEach((entry) {
        // Colors.transparent means an empty slot
        if (entry.color != Colors.transparent &&
            entry.resource.index == entryToAdd.resource.index) {
          DateTime entryStartTime =
              DateTime(1999, 1, 1, entry.resource.hour, entry.resource.minutes);
          DateTime entryEndTime =
              entryStartTime.add(Duration(minutes: entry.duration));

          if (!(newStartTime.isAfter(entryEndTime) ||
                  (newEndTime.isBefore(entryStartTime))) &&
              !newEndTime.isAtSameMomentAs(entryStartTime) &&
              !newStartTime.isAtSameMomentAs(entryEndTime)) {
            isSlotAvailable = false;
            return;
          }
        }
      });
    }

    return isSlotAvailable;
  }
}
