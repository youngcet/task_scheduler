/// This class represents a resource's specific schedule entry details.
/// It stores information about when a particular resource is scheduled, 
/// such as the hour, minutes, and an index which might correspond to its position or order in a schedule.
class ResourceScheduleEntry {
  /// The index of the resource entry.
  int index;

  /// The hour of the schedule entry.
  int hour;

  /// The minutes of the schedule entry.
  int minutes;

  /// Constructor for the ResourceScheduleEntry class.
  /// It initializes the class with the required `index`, `hour`, and `minutes`.
  /// These parameters must be provided when creating an instance of the class.
  ResourceScheduleEntry({
    required this.index,
    required this.hour,
    required this.minutes,
  });
}
