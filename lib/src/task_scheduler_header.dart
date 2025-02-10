import 'package:flutter/material.dart';
import 'config.dart' as config;

/// A widget representing a resource header in a task scheduler.
///
/// This widget is typically used to display headers for resources in a schedule
/// view, such as days, rooms, or any other categorized resources.
class ScheduleResourceHeader extends StatelessWidget {
  /// The title of the resource (optional).
  final String? title;

  /// The child widget to be displayed within the header.
  final Widget child;

  /// A unique identifier for the header.
  final String id;

  /// The position of the header in the schedule (e.g., column index).
  final int position;

  /// The height of the header (optional). Defaults to 70 if not provided.
  final double? height;

  /// The object type for the header.
  final Object? typeOf;

  /// Creates an instance of [ScheduleResourceHeader].
  ///
  /// - [child]: The widget to be displayed within the header (required).
  /// - [id]: A unique identifier for the header (required).
  /// - [position]: The position of the header in the schedule (required).
  /// - [title]: An optional title for the header.
  /// - [height]: An optional height for the header. Defaults to 70 if not provided.
  /// - [typeOf]: The object type for the header.
  const ScheduleResourceHeader(
      {Key? key,
      required this.child,
      required this.id,
      required this.position,
      this.typeOf,
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
