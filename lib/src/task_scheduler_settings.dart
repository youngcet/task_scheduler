import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../task_scheduler.dart';

class TaskSchedulerSettings {
  /// Slot height.
  int? cellHeight;

  /// Slot width
  int? cellWidth;

  /// Slot horizontal padding (Left and Right).
  double? horizontalTaskPadding;

  /// Timeline divider color
  Color? dividerColor;

  /// Schedule view background
  Color? backgroundColor;

  /// Entry border radius
  BorderRadiusGeometry? borderRadius;

  // Wether an Entry is draggable
  bool? isTaskDraggable;

  // Allowed task schedule intervals
  Map<String, int> allowedIntervals = {
    '10': 42,
    '15': (kIsWeb) ? 55 : 50,
    '20': 90,
    '30': 70,
    '60': 195
  };

  // Entry resizable options
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
