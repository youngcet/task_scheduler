import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_scheduler/src/task_scheduler_datetime.dart';
import 'package:task_scheduler/src/task_scheduler_settings.dart';
import 'config.dart' as config;


class ScheduleEntry extends StatefulWidget {
  /// Entry duration
  int duration;

  /// Entry resource
  ResourceScheduleEntry resource;

  /// Entry background color
  Color color;

  /// Entry onTap function
  final Function? onTap;

  /// Entry widget
  final Widget? child;

  // Entry id
  final String id;

  // Entry on drag callback
  final Function(Map<String, dynamic>)? onDragCallback;

  // Entry meta data
  final Map<String, dynamic>? data;

  // Task scheduler settings
  final TaskSchedulerSettings? options;

  ScheduleEntry(
      {Key? key,
      required this.duration,
      required this.resource,
      required this.id,
      required this.color,
      this.onTap,
      this.child,
      this.data,
      this.onDragCallback,
      this.options})
      : super(key: key);

  @override
  _ScheduleEntryState createState() => _ScheduleEntryState();
}

class _ScheduleEntryState extends State<ScheduleEntry> {
  // Entry horizontal overlap
  int entryDuration = 1;

  // Entry color
  var blockOriginalColor;

  @override
  Widget build(BuildContext context) {
    // Check if drag is enabled
    bool isDragAndDrop = widget.options?.isTaskDraggable ?? false;

    blockOriginalColor = widget.color;
    return (isDragAndDrop) ? _draggableSlot() : _nonDraggableSlot();
  }

  // A draggable widget
  Widget _draggableSlot() {
    return (widget.color != Colors.transparent)
        ? Positioned(
            top: ((config.cellHeight! *
                        (widget.resource.hour - config.startHour)) +
                    ((widget.resource.minutes * config.cellHeight!) / 60))
                .toDouble(),
            left: config.cellWidth! * widget.resource.index.toDouble(),
            child: SizedBox(
              width: (config.cellWidth!.toDouble() * entryDuration) -
                  config.horizontalTaskPadding!,
              child: Padding(
                padding: EdgeInsets.only(
                    left: config.horizontalTaskPadding!.toDouble()),
                child: Material(
                  elevation: 3,
                  borderRadius: config.borderRadius,
                  child: Stack(
                    children: [
                      LongPressDraggable<List<Map<String, dynamic>>>(
                        // Data is the value this Draggable stores.
                        data: [
                          {
                            'resourceHour': widget.resource.hour,
                            'resourceMinute': widget.resource.minutes,
                            'duration': widget.duration,
                            'fromId': widget.id,
                            'resourceIndex': widget.resource.index,
                            'bgColor': widget.color,
                            'child': widget.child,
                            'onTap': widget.onTap,
                            'data': widget.data
                          }
                        ],
                        feedback: GestureDetector(
                          onTap: widget.onTap as void Function()? ?? () {},
                          child: Container(
                            height: ((widget.duration.toDouble() *
                                    config.cellHeight!) /
                                60), //60 minutes
                            width:
                                (config.cellWidth!.toDouble() * entryDuration),
                            decoration: BoxDecoration(
                                borderRadius: config.borderRadius,
                                color: widget.color ??
                                    Theme.of(context).primaryColor),
                            child: Center(
                              child: widget.child,
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          child: const Center(),
                        ),
                        onDraggableCanceled: (velocity, offset) {
                          //_triggerRebuild();
                        },
                        child: GestureDetector(
                          onLongPress: null,
                          onTap: widget.onTap as void Function()? ?? () {},
                          child: Container(
                            height: ((widget.duration.toDouble() *
                                    config.cellHeight!) /
                                60), //60 minutes
                            width:
                                (config.cellWidth!.toDouble() * entryDuration),
                            decoration: BoxDecoration(
                                borderRadius: config.borderRadius,
                                color: widget.color ??
                                    Theme.of(context).primaryColor),
                            child: Center(
                              child: widget.child,
                            ),
                          ),
                        ),
                        onDragUpdate: (details) {
                          // Get the global position of the drag update
                          final dragPosition = details.globalPosition;

                          // Get the size of the scrollable area
                          final scrollableSize = MediaQuery.of(context).size;

                          // Define the scroll boundaries
                          const double scrollThreshold = 50.0;
                          const double scrollSpeed = 200.0;

                          // Check if the drag position is within the scroll threshold from the edges
                          final shouldScrollUp =
                              dragPosition.dy < scrollThreshold;
                          final shouldScrollDown = dragPosition.dy >
                              scrollableSize.height - scrollThreshold;
                          final shouldScrollLeft =
                              dragPosition.dx < scrollThreshold;
                          final shouldScrollRight = dragPosition.dx >
                              scrollableSize.width - scrollThreshold;

                          // Calculate the scroll directions and amounts
                          double verticalScrollDelta = 0.0;
                          double horizontalScrollDelta = 0.0;
                          if (shouldScrollUp) {
                            verticalScrollDelta = -scrollSpeed;
                          } else if (shouldScrollDown) {
                            verticalScrollDelta = scrollSpeed;
                          }

                          if (shouldScrollLeft) {
                            horizontalScrollDelta = -scrollSpeed;
                          } else if (shouldScrollRight) {
                            horizontalScrollDelta = scrollSpeed;
                          }
                          // Scroll the content based on the calculated deltas
                          config.verticalScrollController.animateTo(
                            config.verticalScrollController.offset +
                                verticalScrollDelta,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                          config.horizontalScrollController.animateTo(
                            config.horizontalScrollController.offset +
                                horizontalScrollDelta,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Positioned(
            top: ((config.cellHeight! *
                        (widget.resource.hour - config.startHour)) +
                    ((widget.resource.minutes * config.cellHeight!) / 60))
                .toDouble(),
            left: config.cellWidth! * widget.resource.index.toDouble(),
            child: SizedBox(
              width: (config.cellWidth!.toDouble() * entryDuration) -
                  config.horizontalTaskPadding!,
              child: Padding(
                padding: EdgeInsets.only(
                    left: config.horizontalTaskPadding!.toDouble()),
                child: Material(
                  child: Stack(
                    children: [
                      DragTarget<List<Map<String, dynamic>>>(
                        builder: (
                          BuildContext context,
                          List<dynamic> accepted,
                          List<dynamic> rejected,
                        ) {
                          final isDraggingOver = accepted.isNotEmpty;
            
                          if (isDraggingOver &&
                              widget.color ==
                                  Color(int.parse('E6EFF9', radix: 16) +
                                      0xFF000000)) {
                            widget.color = Colors.transparent;
                          }

                          final color = isDraggingOver
                              ? Colors.blue[100]
                              : Colors.transparent;

                          return InkWell(
                            onTap: widget.onTap as void Function()? ?? () {},
                            child: Material(
                              color: color,
                              child: Container(
                                height: ((widget.duration.toDouble() *
                                        config.cellHeight!) /
                                    60), 
                                width: (config.cellWidth!.toDouble() *
                                    entryDuration), 
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors
                                          .grey, 
                                      width:
                                          0.5,
                                    ),
                                    right: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  color: widget.color ??
                                      Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: widget.child,
                                ),
                              ),
                            ),
                          );
                        },
                        onAccept: (List<Map<String, dynamic>> data) {
                          final String id = widget.id;
                          final int resourceIndex = widget.resource.index;
                          final int startHour = widget.resource.hour;
                          final int minutes = widget.resource.minutes;
                          final int duration = data[0]['duration'];
                          final Widget? child = widget.child;

                          setState(() {
                            if (widget.onDragCallback != null) {
                              widget.onDragCallback!({
                                'id': id,
                                'resourceIndex': resourceIndex,
                                'hour': startHour,
                                'minutes': minutes,
                                'duration': duration,
                                'fromHour': data[0]['resourceHour'],
                                'fromMinute': data[0]['resourceMinute'],
                                'fromDuration': data[0]['duration'],
                                'fromResourceIndex': data[0]['resourceIndex'],
                                'child': data[0]['child'],
                                'bgColor': data[0]['bgColor'],
                                'fromId': data[0]['fromId'],
                                'onTap': data[0]['onTap'],
                                'data': data[0]['data']
                              }); // Call the callback function
                            }
                          });
                        },
                        onLeave: (data) {
                          widget.color = blockOriginalColor;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // Non-draggable widget
  Widget _nonDraggableSlot() {
    return (widget.color != Colors.transparent)
        ? Positioned(
            top: ((config.cellHeight! *
                        (widget.resource.hour - config.startHour)) +
                    ((widget.resource.minutes * config.cellHeight!) / 60))
                .toDouble(),
            left: config.cellWidth! * widget.resource.index.toDouble(),
            child: SizedBox(
              width: (config.cellWidth!.toDouble() * entryDuration) -
                  config.horizontalTaskPadding!,
              child: Padding(
                padding: EdgeInsets.only(
                    left: config.horizontalTaskPadding!.toDouble()),
                child: Material(
                  elevation: 3,
                  borderRadius: config.borderRadius,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: widget.onTap as void Function()? ?? () {},
                        child: Container(
                          height: ((widget.duration.toDouble() *
                                  config.cellHeight!) /
                              60),
                          width: (config.cellWidth!.toDouble() * entryDuration),
                          decoration: BoxDecoration(
                              borderRadius: config.borderRadius,
                              color: widget.color ??
                                  Theme.of(context).primaryColor),
                          child: Center(
                            child: widget.child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Positioned(
            top: ((config.cellHeight! *
                        (widget.resource.hour - config.startHour)) +
                    ((widget.resource.minutes * config.cellHeight!) / 60))
                .toDouble(),
            left: config.cellWidth! * widget.resource.index.toDouble(),
            child: SizedBox(
              width: (config.cellWidth!.toDouble() * entryDuration) -
                  config.horizontalTaskPadding!,
              child: Padding(
                padding: EdgeInsets.only(
                    left: config.horizontalTaskPadding!.toDouble()),
                child: Material(
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: widget.onTap as void Function()? ?? () {},
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            height: ((widget.duration.toDouble() *
                                    config.cellHeight!) /
                                60),
                            width:
                                (config.cellWidth!.toDouble() * entryDuration),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              color: widget.color ??
                                  Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
