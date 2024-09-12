import '../task_scheduler.dart';

class BlockedEntry {
  /// Resource
  ResourceScheduleEntry resource;

  // title
  String? title;

  /// duration
  int duration;

  // constructor
  BlockedEntry({required this.resource, required this.duration, this.title});
}
