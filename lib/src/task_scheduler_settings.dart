import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../task_scheduler.dart';

class TaskSchedulerSettings {
  /// Height of each scheduler slot in pixels.
  /// Determines the vertical space allocated for a single time interval.
  /// For example, a `cellHeight` of 50 means each slot row will be 50 pixels tall.
  int? cellHeight;

  /// Width of each scheduler slot in pixels.
  /// Relevant for horizontal layouts where time slots are displayed side-by-side.
  int? cellWidth;

  /// Horizontal padding (left and right) applied to each task entry.
  /// Controls the spacing between the entry content and the slot boundaries.
  double? horizontalTaskPadding;

  /// Color of the timeline dividers.
  /// These are the lines that separate different time slots in the schedule.
  Color? dividerColor;

  /// Background color of the schedule view.
  /// Defines the overall backdrop for the timeline and resource columns.
  Color? backgroundColor;

  /// Border radius applied to each task entry.
  /// Controls how rounded the corners of each entry appear.
  BorderRadiusGeometry? borderRadius;

  /// Whether an entry (task/event) can be dragged to a different time or resource.
  /// If `true`, users can reposition entries via drag-and-drop.
  bool? isTaskDraggable;

  /// Allowed task schedule intervals and their corresponding pixel heights.
  /// Keys represent time intervals in minutes (e.g., '5', '10', '15').
  /// Values define the calculated pixel height for each interval.
  /// Used to control how granular the schedule timeline is.
  Map<String, int> allowedIntervals = {
    '5': 20,
    '10': 42,
    '15': (kIsWeb) ? 55 : 50,
    '20': 90,
    '30': 70,
    '60': 195
  };

  /// Configuration for task resizing behavior.
  /// - `allowResize`: Whether users can change a task's duration by resizing it.
  /// - `onResizeEnd`: Callback triggered when resizing is complete.
  /// - `onResizeUpdate`: Callback triggered continuously as a task is being resized.
  Map<String, dynamic>? taskResizeMode = {
    'allowResize': false,
    'onResizeEnd': (Map<String, dynamic> resizeData) {},
    'onResizeUpdate': (ScheduleEntry entries) {},
  };

  // constructor
  TaskSchedulerSettings(
      {this.dividerColor,
      this.backgroundColor,
      this.isTaskDraggable,
      this.taskResizeMode});
}
