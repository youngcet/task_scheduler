import 'package:flutter/material.dart';
import 'config.dart' as config;

// ScheduleResourceHeader class for header widget in the schedule
class ScheduleResourceHeader extends StatelessWidget {
  // resource title
  final String? title;

  // Child widget for the header
  final Widget child;

  // id for the header
  final String id;

  // position for the header
  final int position;

  // height for the header
  final double? height;

  // Constructor for ScheduleResourceHeader
  const ScheduleResourceHeader(
      {Key? key,
      required this.child,
      required this.id,
      required this.position,
      this.title,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 70,
      width: config.cellWidth!.toDouble(),
      child: Center(
        child: child,
      ),
    );
  }
}
