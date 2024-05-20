## 0.0.1

* Initial release.

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

## 0.0.3

* Added a line to indicate the current time.
* Implemented transparency for past events when dragged.
* Fixed confusion when setting intervals of 30 minutes and selecting 5 minutes.
* Introduced a moving clock visible in a small popup window during dragging.
* Updated left-hand clock section to show only main hours when intervals of 5 minutes or smaller are set.
* Enhanced weekly and monthly views to show small details based on resource colors.