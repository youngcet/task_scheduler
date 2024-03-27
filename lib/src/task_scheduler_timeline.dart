import 'package:flutter/material.dart';
import 'config.dart' as config;

// Widget to show the timeline
class SchedulerTimeline extends StatelessWidget {
  /// time
  final String? time;

  /// minute intervals
  final int? minutesIntervals;

  /// constructor
  const SchedulerTimeline({
    Key? key,
    this.time,
    this.minutesIntervals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double remainder = 60 / minutesIntervals!;

    return SizedBox(
      height: ((config.cellHeight!.toDouble() / remainder) - 0),
      width: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Center(
            child: Text(
          time!,
          style: const TextStyle(fontSize: 14.0),
        )),
      ),
    );
  }
}
