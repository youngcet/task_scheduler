import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_scheduler/task_scheduler.dart';

// Task Schedule View class
class TaskScheduleView {
  // Task Scheduler
  final TaskScheduler taskScheduler;

  // Constructor for TaskScheduleView
  const TaskScheduleView({required this.taskScheduler});

  // Method to load the schedule view with given entries
  TaskScheduler loadScheduleView({required List<ScheduleEntry> entries}) {
    // Clear existing entries
    taskScheduler.entries?.clear();

    List<String> timeSlots = taskScheduler.getTimeline();
    _addEmptySlots(timeSlots);
    taskScheduler.entries?.addAll(entries);

    return taskScheduler;
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
          isTaskDraggable: true, // false to disable drag
        ),
        onTap: data['onTap'],
        child: data['child'],
      ));
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
            onTap: () {
              taskScheduler.onEmptySlotPressed({
                'resource_id': res.id,
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
}
