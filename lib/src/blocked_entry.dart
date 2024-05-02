import '../task_scheduler.dart';

class BlockedEntry {
  /// Resource
  ResourceScheduleEntry resource;

  /// duration
  int duration;

  // constructor
  BlockedEntry({
    required this.resource,
    required this.duration,
  });
}
