
## Task Scheduler Widget
The Task Scheduler Widget is a Flutter component designed to display a schedule with customizable time slots and tasks. It provides functionalities to schedule tasks, rearrange them, and visualize them efficiently.

[![Pub Version](https://img.shields.io/pub/v/task_scheduler)](https://pub.dev/packages/task_scheduler)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/task_scheduler/blob/main/LICENSE)

## Features

- **Schedule Tasks:** Users can schedule tasks for different time slots.
- **Drag and Drop:** Tasks can be rearranged by dragging and dropping them to different time slots.
- **Color-coded Entries:** Tasks are color-coded for better visualization.
- **Responsive Design:** The app is designed to work on various screen sizes.

### Videos
[Web](https://permanentlink.co.za/videos/task_scheduler_web.mp4)

### Mobile
[Mobile](https://permanentlink.co.za/videos/task_scheduler_mobile.mp4)

## Getting started

To use this package, add it to your pubspec.yaml file:
```dart
dependencies:
  task_scheduler: ^latest_version
```
Replace 'latest_version' with the lastest version, e.g. `task_scheduler: ^0.0.1`

## Usage

To use the widget,

1) Import the task scheduler library.
```dart
import 'package:task_scheduler/task_scheduler.dart';

// declare the task scheduler and schedule view  
late TaskScheduler scheduleView;
late TaskScheduleView taskScheduleView;
```
2) Create an instance of the TaskScheduleView and pass the TaskScheduler.
```dart
// define the resource headers
List<ScheduleResourceHeader> headers = [
    ScheduleResourceHeader(
        id: '1', // resource id
        position: 0,    // resource position, this is the order of the resource. 0 = first, 1 = 2nd, and so forth
        // resource widget, to add title, descriptions etc.
        child: Column(  
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text(
            'Yung',
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(
            height: 3,
            ),
        ],
        ),
    ),
    ScheduleResourceHeader(
        id: '2',    // resource id
        position: 1,    // resource position
        // resource widget
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text(
            'Cedric',
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(
            height: 3,
            ),
        ],
        ),
    ),
    ScheduleResourceHeader(
        id: '3',    // resource id
        position: 2,     // resource position
         // resource widget
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text(
            'Moss',
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(
            height: 3,
            ),
        ],
        ),
    ),
    ScheduleResourceHeader(
        id: '4',    // resource id
        position: 3,    // resource position
         // resource widget
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text(
            'Matt',
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(
            height: 3,
            ),
        ],
        ),
    )
];

// Instatiate the TaskScheduleView and  pass the TaskScheduler
taskScheduleView = TaskScheduleView(
    taskScheduler: TaskScheduler(
        scheduleStartTime: ScheduleTimeline(hour: 8),   // start time
        scheduleEndTime: ScheduleTimeline(hour: 17),    // end time 
        onEmptySlotPressed: (Map<String, dynamic> data) {},     // Callback function when an empty slot is pressed
        onDragAccept: (Map<String, dynamic> data) {},      // Callback function when an entry is dropped from dragging
        headers: headers,  // resource headers
        entries: [],    // set entries to empty, do not set entries here
        timeFormat: SchedulerTimeSettings(minuteInterval: 30) // minute intervals on the timeline, default 60
    ));
```
3) Load the ScheduleView.
```dart
// to load the schedule view, first add entries/tasks
List<ScheduleEntry> entries = [
    ScheduleEntry(
        color: Colors.blue, // entry background color
        id: '123',      // entry id
        // resource to assign the entry to
        resource: ResourceScheduleEntry(
            index: 0,   // resource position
            hour: 9,    // entry start hour
            minutes: 60),   // entry start minute
        duration: 60,   // entry duration
        // entry options
        options: TaskSchedulerSettings(
            isTaskDraggable: true   // if set to true, the entry is draggable, default false
        ),
        onTap: () {},   // Callback function when an entry is pressed
        // entry widget
        child: const Text('Booked'),
    ),
    ScheduleEntry(
        color: Colors.green,
        id: '1234',
        resource: ResourceScheduleEntry(index: 0, hour: 8, minutes: 30),
        duration: 30,
        options: TaskSchedulerSettings(isTaskDraggable: true),
        onTap: () {},
        child: const Text('Booked'),
    ),
];

// load the view and pass the entries
scheduleView = taskScheduleView.loadScheduleView(entries: entries);
```
4) Render the view.
```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: scheduleView
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
```

ScreenShots
<div style="display: flex;">
    <img src="https://permanentlink.co.za/img/task_scheduler_1.png" alt="Screenshot 1" style="width: 35%; margin-right: 10px;border: 1px solid black;">
    <img src="https://permanentlink.co.za/img/task_scheduler_2.png" alt="Screenshot 2" style="width: 35%; margin-right: 10px;border: 1px solid black;">
</div>
<div style="margin-top:40px">
<img src="https://permanentlink.co.za/img/task_scheduler_3.png" alt="Screenshot 3" style="width: 60%;border: 1px solid black;">
</div>

## Working with Drag & Drop
By default, the grid accepts dropping entries on them. When you add a new entry you can define wether you want the entry to be draggable or not by setting `isTaskDraggable=true` in an entry's `options` parameter.
```dart
ScheduleEntry(...
...
options: TaskSchedulerSettings(
    isTaskDraggable: true   // set to true to enable drag
),
```
Once set to true, define a function to handle what happens when an entry is dropped pass it to the TaskScheduler.
```dart
TaskScheduler(
      scheduleStartTime: ScheduleTimeline(hour: 8),...
      ....
      onDragAccept: handleDrop // I have passed the function handleDrop

// declare the onDragAccept callback function that takes 1 argument 'data'
// this function is called when an entry is dropped
void handleDrop(Map<String, dynamic> data) {}){
    // 'data' holds information about an entry when it is dropped
    // data such as resourceId, resourceIndex, etc. 
    
    // you can access the values from data and process them as needed
    String id = data['id'];
    String hour = data['hour'];
    String min = data['minutes'];
    String resourceIdx = data['resourceIndex'];
    String duration = data['duration'];
    ...

    // print data to see the information about the entry and keys to access the values
    print(data);
}
```

If you don't want to manually process the data, TaskScheduleView provides a function to update the schedule view.
```dart
void handleDrop(Map<String, dynamic> data) {
    // create an instance of TaskScheduleView
    // pass the curent scheduleView
    TaskScheduleView view = TaskScheduleView(
        taskScheduler: TaskScheduler(
        scheduleStartTime: scheduleView.scheduleStartTime,
        scheduleEndTime: scheduleView.scheduleEndTime,
        onEmptySlotPressed: handleEmptySlotTap,
        onDragAccept: handleDrop,
        entries: scheduleView.entries,
        headers: scheduleView.headers,
        timeFormat: scheduleView.timeFormat,
    ));

    // update the schedule view and rebuild the widget
    setState(() {
        scheduleView = view.updateScheduleView(view, data);
    });
}
```

## Handling Clicks on Empty Slots
You can define a function that handles what happens when an empty slot is clicked and pass that function to the ``onEmptySlotPressed` of the TaskScheduler.
```dart
TaskScheduleView view = TaskScheduleView(
        taskScheduler: TaskScheduler(
    scheduleStartTime: ...
    ...
    onEmptySlotPressed: handleEmptySlotTap, // pass function here
    ...
));

// define the function that takes 1 argument 'data'
void handleEmptySlotTap(Map<String, dynamic> data) {
    // Handle the returned data here
    print('Received data from onTap: $data');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("onTap: $data"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating));
  }
```

## Demo
View demo in the example tab.

## Contributing

If you have ideas or improvements for this package, we welcome contributions. Please open an issue or create a pull request on our [GitHub repository](https://github.com/youngcet/task_schedule).

## License

This package is available under the [MIT License](https://github.com/youngcet/task_schedule/blob/main/LICENSE).
