///static values
library task_scheduler.config;

import 'package:flutter/material.dart';

BorderRadiusGeometry? borderRadius;
int? cellHeight;
int? cellWidth;
double? horizontalTaskPadding;
late double totalHours;
late int totalHeaders;
late int startHour;

ScrollController verticalScrollController = ScrollController();
ScrollController horizontalScrollController = ScrollController();
