import '../task_scheduler.dart';

/// The `BlockedEntry` class represents an entry in the schedule where a resource
/// is blocked for a specific period of time. This could represent situations such as
/// a maintenance block, unavailable time slots, or other reasons that prevent
/// the resource from being scheduled for tasks during this time.
class BlockedEntry {
  /// The resource that is associated with this blocked entry.
  ResourceScheduleEntry resource;

  /// An optional title for the blocked entry.
  String? title;

  /// The duration for which the resource is blocked.
  int duration;

  /// The constructor for creating a `BlockedEntry` object.
  /// It requires the `resource` and `duration` to be provided, while the `title` is optional.
  BlockedEntry({required this.resource, required this.duration, this.title});
}
