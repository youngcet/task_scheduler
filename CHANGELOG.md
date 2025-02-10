## 0.0.4 11/02/2025
* Support for 5-Minute Intervals: Added support for scheduling tasks in 5-minute increments.
* **Dynamic Cell Widths:** Introduced MediaQuery to dynamically adjust cell widths based on screen size, ensuring the UI is responsive across different devices (mobile, tablet, desktop).
* Full Month Support for Calendar Views:
    * **Week View:** Added a `showFullMonth` option to display an entire month instead of a single week.
        ```dart
            CalendarView.weekView({
                ...
                bool? showFullMonth, // shows the full month instead of a week
            })
        ```
    * **Week View With Month:** Introduced a `showFullMonth` option to extend the view to a full month.
        ```dart
            CalendarView.weekViewWithMonth({
                ...
                bool? showFullMonth, // shows the full month instead of a week
            })
        ```
* Added `spanOverDays` property to ScheduleEntry, allowing entries to extend across multiple days.
    ```dart
        ScheduleEntry(
            ...
            spanOverDays: 2, // the entry will span over 2 days
        )
    ```
* Added `type` property to ScheduleEntry, allowing entries to be assigned a type.
* Added `typeOf` property to ScheduleResourceHeader, allowing resources to be assigned a type of.
* Implemented a function to convert a Map into a `ScheduleEntry` object using the `TaskScheduleView`.
    ```dart
        taskScheduleView.castToScheduleEntry(data); // where data is the Map object
    ```
* Implemented a function to retrieve a list of resource entries.
    ```dart
        taskScheduleView.getResourceEntries(resourceId);
    ```

## 0.0.3+2

* Removed restrictions to allow start and end times to extend up to midnight, covering the full 24-hour day.
* Fixed minute duplication in the 12-hour format when including the period (AM/PM).

## 0.0.3+1

* Updated Task Cards with a more cleaner layout
* Updated blocked entries to include title and stripes

## 0.0.3

* Added a line to indicate the current time.
* Implemented transparency for past events when dragged.
* Introduced a start and end time popup during dragging.
* Updated left-hand clock section to hide minutes.
* Fix widget resize issue.

## 0.0.2

* Updated min Dart SDK to 2.12.0
* Entry Resizing
    - Allow users to resize entries to adjust their duration.
    - Define callbacks to handle resizing events, including update and completion events.
    - Prevent overlapping of entries during resizing with customizable logic.
* Added Calendar Views
    - **Calendar view** provides a week schedule view. There are two types to choose from, `CalendarView.weekView()` and `CalendarView.weekViewWithMonth()`.
* Block off specific periods on a schedule for a resource.
* Choose between 12-hour and 24-hour time formats.

## 0.0.1

* Initial release.