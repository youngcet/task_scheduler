import 'dart:core';

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

  /// static fields
  static const String empty = 'empty';
  static const String blocked = 'blocked';
  static const String booked = 'booked';
  static const int defaultYear = 1991;
  static const int defaultMonth = 1;
  static const int defaultDay = 1;

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

  /// Returns the start time of the schedule entry.
  ///
  /// The start time is calculated based on the default year, month, and day,
  /// combined with the specific hour and minutes of the resource.
  ///
  /// Returns:
  /// - A [DateTime] object representing the start time of the schedule entry.
  DateTime get startTime {
    return DateTime(
        defaultYear, defaultMonth, defaultDay, resource.hour, resource.minutes);
  }

  /// Returns the end time of the schedule entry.
  ///
  /// The end time is calculated by adding the duration (in minutes) to the start time.
  ///
  /// Returns:
  /// - A [DateTime] object representing the end time of the schedule entry.
  DateTime get endTime {
    return startTime.add(Duration(minutes: duration));
  }

  @override
  _ScheduleEntryState createState() => _ScheduleEntryState();
}

class _ScheduleEntryState extends State<ScheduleEntry> {
  // Entry horizontal overlap
  int entryDuration = 1;

  // Entry color
  var blockOriginalColor;

  /// Indicates whether borders should be displayed around the schedule entry.
  ///
  /// When set to `true`, borders will be shown around the schedule entry.
  /// Defaults to `false`.
  bool _showBorders = false;

  /// Indicates whether the top border should be displayed around the schedule entry.
  ///
  /// When set to `true`, the top border will be shown around the schedule entry.
  /// Defaults to `false`.
  bool _showTopBorder = false;

  /// Indicates whether the bottom border should be displayed around the schedule entry.
  ///
  /// When set to `true`, the bottom border will be shown around the schedule entry.
  /// Defaults to `false`.
  bool _showBottomBorder = false;

  @override
  Widget build(BuildContext context) {
    // Check if drag is enabled
    bool isDragAndDrop = widget.options?.isTaskDraggable ?? false;
    blockOriginalColor = widget.color;

    if (widget.data != null) {
      if (widget.data?['type'] == ScheduleEntry.blocked) {
        return _blockedEntry();
      }
    }

    return (isDragAndDrop) ? _draggableSlot() : _nonDraggableSlot();
  }

  // A draggable widget
  Widget _draggableSlot() {
    bool isResizable = widget.options?.taskResizeMode?['allowResize'] ?? false;
    bool _showTooltip = false;
    bool _isDraggingTop = false;
    Color entryBorderColor = widget.color.withOpacity(1.0);

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
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _showTopBorder = !_showTopBorder;
                        _showBottomBorder = !_showBottomBorder;
                      });
                    },
                    child: MouseRegion(
                        cursor:
                            _showTopBorder && _showBottomBorder && isResizable
                                ? SystemMouseCursors.resizeUpDown
                                : SystemMouseCursors.basic,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide.none,
                              bottom: _showBottomBorder && isResizable
                                  ? BorderSide(color: Colors.black, width: 2.0)
                                  : BorderSide.none,
                            ),
                          ),
                          child: GestureDetector(
                            onVerticalDragStart: (details) {
                              final touchPosition = details.localPosition.dy;
                              if (touchPosition < 20) {
                                _isDraggingTop = true;
                              } else if (touchPosition >
                                  widget.duration.toDouble() - 20) {
                                _isDraggingTop = false;
                              }
                            },
                            onVerticalDragUpdate: (details) {
                              if (isResizable) {
                                final dragDelta = details.delta.dy;

                                setState(() {
                                  // if (_isDraggingTop) {
                                  //   //widget.duration -= dragDelta.toInt();
                                  //   widget.resource.minutes = dragDelta.toInt();
                                  // } else {
                                  //   widget.duration += dragDelta.toInt();
                                  // }

                                  if (widget.duration >= 10) {
                                    widget.duration += dragDelta.toInt();
                                  }

                                  if (widget.duration < 10) {
                                    widget.duration += 10;
                                  }
                                });

                                if (widget.options
                                        ?.taskResizeMode?['onResizeUpdate'] !=
                                    null) {
                                  widget.options?.taskResizeMode?[
                                      'onResizeUpdate'](ScheduleEntry(
                                    color: widget.color,
                                    id: widget.id,
                                    resource: ResourceScheduleEntry(
                                      index: widget.resource
                                          .index, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
                                      hour: widget.resource.hour,
                                      minutes: widget.resource.minutes,
                                    ),
                                    duration: widget.duration,
                                  ));
                                }
                              }
                            },
                            onVerticalDragEnd: (details) {
                              if (isResizable) {
                                if (widget.options
                                        ?.taskResizeMode?['onResizeEnd'] !=
                                    null) {
                                  widget
                                      .options?.taskResizeMode?['onResizeEnd']({
                                    'id': widget.id,
                                    'resource': widget.resource,
                                    'duration': widget.duration,
                                    'color': widget.color
                                  });
                                }
                              }
                            },
                            child: Material(
                              elevation: 3,
                              //borderRadius: config.borderRadius,
                              child: Stack(
                                children: [
                                  LongPressDraggable<
                                      List<Map<String, dynamic>>>(
                                    // Data is the value this Draggable stores.
                                    data: [
                                      {
                                        'resourceHour': widget.resource.hour,
                                        'resourceMinute':
                                            widget.resource.minutes,
                                        'duration': widget.duration,
                                        'fromId': widget.id,
                                        'resourceIndex': widget.resource.index,
                                        'bgColor': widget.color,
                                        'child': widget.child,
                                        'onTap': widget.onTap,
                                        'data': widget.data,
                                        'taskResizeMode':
                                            widget.options?.taskResizeMode
                                      }
                                    ],
                                    onDragStarted: () {
                                      setState(() {
                                        _showTopBorder = false;
                                        _showBottomBorder = false;
                                      });
                                    },
                                    feedback: GestureDetector(
                                      onTap: widget.onTap as void Function()? ??
                                          () {},
                                      onTapDown: (_) {
                                        setState(() {
                                          _showTooltip = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _showTooltip = false;
                                        });
                                      },
                                      child: Container(
                                        height: ((widget.duration.toDouble() *
                                                config.cellHeight!) /
                                            60), //60 minutes
                                        width: (config.cellWidth!.toDouble() *
                                            entryDuration),
                                        decoration: BoxDecoration(
                                            //borderRadius: config.borderRadius,
                                            color: (widget.color ??
                                                    Theme.of(context)
                                                        .primaryColor)
                                                .withOpacity(0.6)),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 5.0,
                                              top: 5.0,
                                              right: 5.0,
                                              bottom: 5.0),
                                          alignment: Alignment.topLeft,
                                          child: widget.child,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: Container(),
                                    onDraggableCanceled: (velocity, offset) {
                                      //_triggerRebuild();
                                    },
                                    child: GestureDetector(
                                      onLongPress: null,
                                      onTap: widget.onTap as void Function()? ??
                                          () {},
                                      child: Container(
                                          height: ((widget.duration.toDouble() *
                                                  config.cellHeight!) /
                                              60), //.//clamp(0.0, double.infinity), //60 minutes
                                          width: (config.cellWidth!.toDouble() *
                                              entryDuration),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: entryBorderColor,
                                                  width: 2.5,
                                                ),
                                              ),
                                              //borderRadius: config.borderRadius,
                                              color: widget.color
                                                      .withOpacity(0.4) ??
                                                  Theme.of(context)
                                                      .primaryColor),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 5.0,
                                                right: 5.0,
                                                bottom: 5.0),
                                            alignment: Alignment.topLeft,
                                            child: widget.child,
                                          )),
                                    ),
                                    onDragUpdate: (details) {
                                      _showTopBorder = false;
                                      _showBottomBorder = false;
                                      // Get the global position of the drag update
                                      final dragPosition =
                                          details.globalPosition;

                                      // Get the size of the scrollable area
                                      final scrollableSize =
                                          MediaQuery.of(context).size;

                                      // Define the scroll boundaries
                                      const double scrollThreshold = 50.0;
                                      const double scrollSpeed = 200.0;

                                      // Check if the drag position is within the scroll threshold from the edges
                                      final shouldScrollUp =
                                          dragPosition.dy < scrollThreshold;
                                      final shouldScrollDown = dragPosition.dy >
                                          scrollableSize.height -
                                              scrollThreshold;
                                      final shouldScrollLeft =
                                          dragPosition.dx < scrollThreshold;
                                      final shouldScrollRight =
                                          dragPosition.dx >
                                              scrollableSize.width -
                                                  scrollThreshold;

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
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut,
                                      );
                                      config.horizontalScrollController
                                          .animateTo(
                                        config.horizontalScrollController
                                                .offset +
                                            horizontalScrollDelta,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                )))
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

                          String time = '';
                          time = (widget.resource.hour < 10)
                              ? '0${widget.resource.hour}'
                              : '${widget.resource.hour}';
                          time = (widget.resource.minutes < 10)
                              ? '$time:0${widget.resource.minutes}'
                              : '$time:${widget.resource.minutes}';

                          DateTime startTime = DateTime(1991, 01, 01,
                              widget.resource.hour, widget.resource.minutes);
                          DateTime endTime =
                              startTime.add(Duration(minutes: widget.duration));

                          String entryEndTime = (endTime.hour < 10)
                              ? '0${endTime.hour}'
                              : '${endTime.hour}';
                          entryEndTime = (endTime.minute < 10)
                              ? '$entryEndTime:0${endTime.minute}'
                              : '$entryEndTime:${endTime.minute}';

                          return InkWell(
                            onTap: widget.onTap as void Function()? ?? () {},
                            child: Tooltip(
                              message:
                                  isDraggingOver ? '$time - $entryEndTime' : '',
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
                                  )),
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
                                'data': data[0]['data'],
                                'taskResizeMode': data[0]['taskResizeMode']
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
                  //borderRadius: config.borderRadius,
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
                              //borderRadius: config.borderRadius,
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

  /// Creates a widget representing a blocked entry in the schedule.
  ///
  /// The blocked entry is positioned and sized based on the schedule configuration and
  /// the resource's time and duration.
  ///
  /// Returns a [Positioned] widget that contains the blocked entry.
  Widget _blockedEntry() {
    return Positioned(
      top: ((config.cellHeight! * (widget.resource.hour - config.startHour)) +
              ((widget.resource.minutes * config.cellHeight!) / 60))
          .toDouble(),
      left: config.cellWidth! * widget.resource.index.toDouble(),
      child: SizedBox(
        width: (config.cellWidth!.toDouble() * entryDuration) -
            config.horizontalTaskPadding!,
        child: Padding(
          padding:
              EdgeInsets.only(left: config.horizontalTaskPadding!.toDouble()),
          child: Material(
            child: Stack(
              children: [
                InkWell(
                  onTap: widget.onTap as void Function()? ?? () {},
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height:
                          ((widget.duration.toDouble() * config.cellHeight!) /
                              60),
                      width: (config.cellWidth!.toDouble() * entryDuration),
                      decoration: BoxDecoration(
                          border: const Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            right: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          color: widget.color ?? Theme.of(context).primaryColor,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: const Alignment(-0.9, -0.8),
                            stops: const [0.0, 0.5, 0.5, 1],
                            colors: [
                              widget.color,
                              widget.color,
                              widget.color.withOpacity(0.5),
                              widget.color.withOpacity(0.5),
                            ],
                            tileMode: TileMode.repeated,
                          )),
                      child: Center(
                        child: Text(
                          widget.data!['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey[500]),
                        ),
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

  _addBorders(bool enableResize) {
    return (enableResize)
        ? BoxDecoration(
            border: Border(
              top: BorderSide(color: widget.color),
              bottom: BorderSide(color: widget.color),
            ),
          )
        : null;
  }
}
