<p align="center">   
    <a href="https://pub.dev/packages/task_scheduler"><img src="https://img.shields.io/pub/v/task_scheduler?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://pub.dev/packages/task_scheduler"><img src="https://badgen.net/pub/points/task_scheduler" alt="Pub points"></a>
    <a href="https://pub.dev/packages/task_scheduler"><img src="https://badgen.net/pub/likes/task_scheduler" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/task_scheduler"><img src="https://badgen.net/pub/popularity/task_scheduler" alt="Pub popularity"></a>
    <br> 
    <a href="https://github.com/youngcet/task_scheduler"><img src="https://img.shields.io/github/stars/youngcet/task_scheduler?style=social" alt="Repo stars"></a>
    <a href="https://github.com/youngcet/task_scheduler/commits/master"><img src="https://img.shields.io/github/last-commit/youngcet/task_scheduler/master?logo=git" alt="Last Commit"></a>
    <a href="https://github.com/youngcet/task_scheduler/pulls"><img src="https://img.shields.io/github/issues-pr/youngcet/task_scheduler" alt="Repo PRs"></a>
    <a href="https://github.com/youngcet/task_scheduler/issues?q=is%3Aissue+is%3Aopen"><img src="https://img.shields.io/github/issues/youngcet/task_scheduler" alt="Repo issues"></a>
    <a href="https://github.com/youngcet/task_scheduler/graphs/contributors"><img src="https://badgen.net/github/contributors/youngcet/task_scheduler" alt="Contributors"></a>
    <a href="https://github.com/youngcet/task_scheduler/blob/master/LICENSE"><img src="https://badgen.net/github/license/youngcet/task_scheduler" alt="License"></a>
    <br>       
    <a href="https://app.codecov.io/gh/youngcet/task_scheduler"><img src="https://img.shields.io/codecov/c/github/youngcet/task_scheduler?logo=codecov&logoColor=white" alt="Coverage Status"></a>
</p>

## Task Scheduler Widget
The Task Scheduler Widget is a Flutter component designed to display a schedule with customizable time slots and tasks. It provides functionalities to schedule tasks, rearrange them, and visualize them efficiently.

[![Pub Version](https://img.shields.io/pub/v/task_scheduler)](https://pub.dev/packages/task_scheduler)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/task_scheduler/blob/main/LICENSE)


### Demo
https://youngcet.github.io/taskscheduler.github.io/#/

## Features:

1. **Schedule View:** Display a customizable schedule view for managing tasks and appointments.
   
2. **Resource Headers:** Ability to define resource headers to categorize tasks. Each header can contain custom widgets.
   
3. **Schedule Configuration:**
   - Define the start and end time of the schedule.
   - Customize the time interval for the timeline display.
   - Support for both 12-hour and 24-hour time formats.

4. **Empty Slot Handling:** Trigger custom actions when users click on empty slots in the schedule.

5. **Drag and Drop Functionality:**
   - Allow users to drag and drop tasks within the schedule.
   - Define callbacks to handle dropped tasks, including updating the schedule view.

6. **Entry Management:**
   - Add, and edit entries within the schedule.
   - Customize entry properties such as color, duration, draggable and resizable behavior.
   - Block off specific periods on a schedule for a resource.
   
7. **Entry Interaction:**
   - Define callbacks for handling interactions with entries, such as onTap events.
   - Display custom content within each entry, including text and widgets.

8. **Entry Resizing:**
   - Allow users to resize entries to adjust their duration.
   - Define callbacks to handle resizing events, including update and completion events.
   - Prevent overlapping of entries during resizing with customizable logic.

### Web
[![Web](https://permanentlink.co.za/img/task_scheduler_web.gif)

### Mobile
[![Mobile](https://permanentlink.co.za/img/task_scheduler_mobile.gif)

## Getting started

To use this package, add it to your **pubspec.yaml** file:
```dart
dependencies:
  task_scheduler: ^latest_version
```
Replace **'latest_version'** with the lastest version, e.g. `task_scheduler: ^0.0.1`

## Usage

To use the widget,

1) Import the task scheduler library.
```dart
import 'package:task_scheduler/task_scheduler.dart';

// declare the task scheduler and schedule view  
late TaskScheduler taskScheduler;
late TaskScheduleView taskScheduleView;
```
2) Create an instance of the **`TaskScheduleView`** and pass the **`TaskScheduler`**.
```dart
// define the resource headers
List<ScheduleResourceHeader> headers = [
    ScheduleResourceHeader(
        id: '1', // resource id
        position: 0,    // resource position, this is the order of the resource. 0 = first, 1 = 2nd, and so forth
        // resource widget, to add title, descriptions etc.
        title: 'Yung', // resource title
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
        title: 'Cedric', // resource title
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
         title: 'Moss', // resource title
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
         title: 'Matt', // resource title
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
        entries: [],    // set entries to empty, do not add entries here
        timeFormat: SchedulerTimeSettings(minuteInterval: 30) // minute intervals on the timeline, default 60
    ));
```
3) Load the **`ScheduleView`**.
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
        // custom widget
        child: const Text('Booked'),
    ),
    ScheduleEntry(
        color: Colors.green,
        id: '1234',
        resource: ResourceScheduleEntry(
            index: 0, 
            hour: 8, 
            minutes: 30
        ),
        duration: 30,
        options: TaskSchedulerSettings(
            isTaskDraggable: true
        ),
        onTap: () {},
        child: const Text('Booked'),
    ),
];

// load the view and pass the entries
taskScheduler = taskScheduleView.loadScheduleView(entries: entries);
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
          child: taskScheduler
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
```

ScreenShots
<div style="display: flex;">
    <img src="https://permanentlink.co.za/img/task_scheduler_1.png" alt="Screenshot 1" style="width: 35%; margin-right: 10px;border: 1px solid black;">
    <img src="https://permanentlink.co.za/img/task_scheduler_2.png" alt="Screenshot 2" style="width: 35%; margin-right: 10px;border: 1px solid black;">
</div>
<div style="display: flex;margin-top:40px">
    <img src="https://permanentlink.co.za/img/task_scheduler_5.gif" alt="Screenshot 5" style="width: 40%; margin-right: 10px;border: 1px solid black;">
</div>
<div style="margin-top:40px">
<img src="https://permanentlink.co.za/img/task_scheduler_3.png" alt="Screenshot 3" style="width: 60%;border: 1px solid black;">
</div>

## Hiding the line that shows the current time
```dart
TaskScheduleView view = TaskScheduleView(
        taskScheduler: TaskScheduler(
    scheduleStartTime: ...
    ...
    showCurrentTimeLine: false, // false to hide it, true to show it (default is true)
    ...
));
```

## Empty Slot Click Event Handling
To create new tasks when users click empty slots in the schedule, define a function that handles this action and assign it to the onEmptySlotPressed callback of the `TaskScheduler`.
```dart
TaskScheduleView view = TaskScheduleView(
        taskScheduler: TaskScheduler(
    scheduleStartTime: ...
    ...
    onEmptySlotPressed: handleEmptySlotTap, // pass function here
    ...
));

// Define a function to handle creating a new task when an empty slot is clicked
// This function receives 'data' containing details about the clicked slot,
// such as resource ID, resource information etc.
void handleEmptySlotTap(Map<String, dynamic> data) {
    // implement the logic here to handle empty slot tap
    print('onTap: $data');
}
```
![Resize](https://permanentlink.co.za/img/task_scheduler_resize_3.gif)

## Adding Entries to Your Schedule
While Step 3 showed how to add entries when the schedule loads, this section demonstrates how to add new entries by clicking a button.

In this example, clicking an empty slot in the schedule opens a dialog for creating a new entry. Here, the user can enter a title, set the duration of the task, and click "Create" to add it to the schedule.
<div style="display: flex;margin-top:10px;margin-bottom:20px">
    <img src="https://permanentlink.co.za/img/task_scheduler_4.gif?2545" alt="Screenshot 4" style="width: 40%; margin-right: 10px;border: 1px solid black;">
</div>

```dart
// function to handle click event on empty slots
void handleEmptySlotTap(Map<String, dynamic> data) {
    _createNewEntry(context, data);
}

void _createNewEntry(BuildContext context, Map<String, dynamic> data) {
    List<String> resources = ['Cedric', 'Yung', 'Moss', 'Matt'];

    int resourceIndex = data['resource']['index']; // resource position
    String resourceName = resources[data['resource']['index']]; // resource name

    // get time slot of the clicked empty slot
    String hour = (data['resource']['hour'] < 10) ? '0${data['resource']['hour']}' : data['resource']['hour'].toString();
    String minutes = (data['resource']['minutes'] < 10) ? '0${data['resource']['minutes']}' : data['resource']['minutes'].toString();

    // text controllers for the dialog box
    TextEditingController titleController = TextEditingController();
    TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: titleController,
                decoration: InputDecoration(hintText: "Enter title"),
              ),
              SizedBox(height: 15),
              TextField(
                keyboardType: TextInputType.number,
                controller: durationController,
                decoration: InputDecoration(hintText: "Enter duration"),
              ),
              SizedBox(height: 15),
              Text(
                "Time: $hour:$minutes\nWith: $resourceName", style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                String title = titleController.text;
                String duration = durationController.text;

                Navigator.of(context).pop();

                if (title.isNotEmpty && duration.isNotEmpty){
                  // create a new task scheduler
                  TaskScheduler newTaskScheduler = TaskScheduler(
                    scheduleStartTime: taskScheduler.scheduleStartTime,
                    scheduleEndTime: taskScheduler.scheduleEndTime,
                    onEmptySlotPressed: handleEmptySlotTap, // this is the function defined above
                    onDragAccept: handleDrop,
                    entries: taskScheduler.entries,
                    headers: taskScheduler.headers,
                    timeFormat: taskScheduler.timeFormat,
                  );

                  List<Color> colors = [
                    Colors.purple,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.lime,
                    Colors.cyan,
                    Colors.grey
                  ];
                  
                  // define the new entry
                  ScheduleEntry newEntry = ScheduleEntry(
                      color: colors[Random().nextInt(colors.length)],
                      id: generateId(5),
                      resource: ResourceScheduleEntry(
                        index: resourceIndex,
                        hour: int.parse(hour),
                        minutes: int.parse(minutes),
                      ),
                      duration: int.parse(duration),
                      options: TaskSchedulerSettings(
                        isTaskDraggable: true, // false to disable drag
                      ),
                      onTap: () {
                        print('clicked');
                        // implement onTap logic
                      },
                      child: Text(title, style: TextStyle(fontSize: 14)),
                  );

                  // TaskScheduleView provides a function to check if a slot is available, 
                  // i.e the new entry slot does not overlap with an existing entry
                  if (taskScheduleView.isResourceSlotAvailable(newEntry)){
                    // slot is available, add entry to the new TaskScheduler
                    newTaskScheduler.entries?.add(newEntry);
                  }else{
                    // slot not available
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Error: Slot not Available."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating
                    ));
                  }
                  
                  // re-build the task scheduler
                  setState(() {
                    taskScheduler = newTaskScheduler;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // generate random string 
  String generateId(int length) {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => charset[random.nextInt(charset.length)]).join();
  }
```

## Blocking Off Times
Block off specific periods on a schedule for a resource.

<img src="https://permanentlink.co.za/img/blockedoffentries.png" alt="Blocked Off" style="width: 40%;">

You can specify entries to block with the `BlockedEntry` object.
```dart
BlockedEntry(
    title: 'Lunch break', // entry title (optional)
    resource: ResourceScheduleEntry(
      index: 2, // the resource to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
      hour: 8, // start hour to block
      minutes: 0, // start minutes to blobk
    ), 
    duration: 60 // duration
  ),
```

Define the `BlockedEntry` objects and add them to a list.
```dart
List<BlockedEntry> blockedEntries = [
  BlockedEntry(
    resource: ResourceScheduleEntry(
      index: 2, 
      hour: 8,
      minutes: 0,
    ), 
    duration: 60
  ),
  BlockedEntry(
    resource: ResourceScheduleEntry(
      index: 2, 
      hour: 11,
      minutes: 0,
    ), 
    duration: 120
  ),
  BlockedEntry(
    resource: ResourceScheduleEntry(
      index: 0, 
      hour: 9,
      minutes: 0,
    ), 
    duration: 60
  ),
  BlockedEntry(
    resource: ResourceScheduleEntry(
      index: 1, 
      hour: 10,
      minutes: 30,
    ), 
    duration: 60
  )
];
```
Pass the list to the `blockedEntries` property of `TaskScheduler`.
```dart
taskScheduleView = TaskScheduleView(
    taskScheduler: TaskScheduler(
  scheduleStartTime: ScheduleTimeline(hour: 8),
  ...
  blockedEntries: blockedEntries, // add here
  ...
));
```

## TimeFormat Property
Customize your schedule's timeline with the `SchedulerTimeSettings` options.
```dart
TaskScheduler(
    scheduleStartTime: ScheduleTimeline(hour: 8),
    scheduleEndTime: ScheduleTimeline(hour: 17),    // always define the end time in a 24 hour format and set the `use24HourFormat=false` to use the 12 hour format
    ...
    timeFormat: SchedulerTimeSettings(
        minuteInterval: 30,     // set the minute interval, default is 60 (supported intervals [10, 15, 20, 30, 60])
        use24HourFormat: true,  // set wether the timeline should use 12/24 hour format, default is 24 hour format
        includePeriod: true,    // set to include period on 12 hour format
        includeMinutes: false, // set to add or remove minutes from the clock (this only applies to a 12 hour format with the minute intervals set to 60)
        showHoursOnly: true // show/hide minutes on the timeline
    ),
    ...
)
```

## Working with Drag & Drop
By default, entries can be dropped onto the grid. When adding a new entry, you can define whether it's draggable by setting `isTaskDraggable` to `true` within the entry's options parameter.
```dart
ScheduleEntry(...
...
options: TaskSchedulerSettings(
    isTaskDraggable: true   // set to true to enable drag
),
```
Once set to true, define a function to handle what happens when an entry is dropped and pass it to the TaskScheduler's `onDragAccept` parameter.
```dart
TaskScheduler(
    scheduleStartTime: ScheduleTimeline(hour: 8),
    ....
    onDragAccept: handleDrop // I have passed the function handleDrop
    ...
));

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

If you don't want to manually process the data, TaskScheduleView provides a function to update the schedule view when an entry is dropped.
```dart
void handleDrop(Map<String, dynamic> data) {
    // create an instance of TaskScheduleView
    // create a new TaskScheduler and pass it to the view
    TaskScheduleView view = TaskScheduleView(
        taskScheduler: TaskScheduler(
        scheduleStartTime: taskScheduler.scheduleStartTime,
        scheduleEndTime: taskScheduler.scheduleEndTime,
        onEmptySlotPressed: handleEmptySlotTap,
        onDragAccept: handleDrop,
        entries: taskScheduler.entries,
        headers: taskScheduler.headers,
        timeFormat: taskScheduler.timeFormat,
    ));

    // update the schedule view and rebuild the widget
    setState(() {
        taskScheduler = view.updateScheduleView(view, data);
    });
}
```

### Allow Entry Overlap (Drag & Drop)
`allowEntryOverlap` property allows overlapping of entries. By default entries are not allowed to overlap. 
```dart
void handleDrop(Map<String, dynamic> data) {
    TaskScheduleView view = TaskScheduleView(
        taskScheduler: TaskScheduler(
        scheduleStartTime: taskScheduler.scheduleStartTime,
        ...
        allowEntryOverlap: true, // true to allow entries to overlap when drag and dropped
        ...,
    ));

    // update the schedule view and rebuild the widget
    setState(() {
        // use try-catch to catch an exception when an overlap occurs
        try{
            taskScheduler = view.updateScheduleView(view, data);
        }catch (e){
            print(e.toString());
        }
    });
}
```

## Resizing an Entry
You can change an entry's end time by resizing the entry. 

**Currently, only the end time can be changed through resizing. To change the start time you can use the drag and drop feature.**

### Allow Entry Resize
`taskResizeMode` property allows resizing of an entry.
```dart
ScheduleEntry(
    color: Colors.green,
    id: '123444',
    ...
    options: TaskSchedulerSettings(
        isTaskDraggable: true, 
        taskResizeMode: {
            'allowResize': true,    // if set to true allows an entry to be resizable
            'onResizeEnd': onResizeEnd, // a callback function that is called when resizing is completed
            'onResizeUpdate': onResizeUpdate    // a callback function that is called during resizing of an entry
        },
    ),
    ...
),

 // Define the function to handle resize end event
void onResizeEnd(Map<String, dynamic> resizeData){
    // implement the logic here to handle resize end
    print('onResizeEnd: $resizeData');
}

// Define the function to handle resize update event
void onResizeUpdate(ScheduleEntry entry){
    // implement the logic here to handle resize update
    inspect(entry);
}
```
![Resize](https://permanentlink.co.za/img/task_scheduler_resize_1.gif)

### Preventing Overlapping Entries During Resizing
In `onResizeUpdate` function you can implement your own logic to prevent entries from overlapping (if required). The `TaskScheduleView` also provides `onResizeEntry` function that prevents entries from overlapping.
```dart
// Define the function to handle resize update event
void onResizeUpdate(ScheduleEntry entry){
    // call onResizeEntry function of the TaskScheduleView
    // this will prevent entries from overlapping during resizing
    taskScheduleView.onResizeEntry(entry);
}
```
![Resize](https://permanentlink.co.za/img/task_scheduler_resize_2.gif)

## Calendar Views
**Calendar view** provides a week schedule view. There are two types to choose from, `CalendarView.weekView()` and `CalendarView.weekViewWithMonth()`.

### CalendarView.weekView()
<img src="https://permanentlink.co.za/img/calendarview.png" alt="Calendar view" style="width: 40%;">

### CalendarView.weekViewWithMonth()
<img src="https://permanentlink.co.za/img/calendarweekviewwithmonth.png" alt="Calendar view" style="width: 40%;">


This can be achieved by passing `CalendarView.weekView()` in the `headers` property of the `TaskScheduler`.
```dart
taskScheduleView = TaskScheduleView(
    taskScheduler: TaskScheduler(
  scheduleStartTime: ScheduleTimeline(hour: 8),
  ...
  headers: CalendarView.weekView(), // add this
  ...
));
```

`CalendarView.weekView()` properties
```dart
CalendarView.weekView({
  bool? showOneLetterWeekDayName, // if set to false, week day names will show as 3 letter word, i.e Sunday = Sun, Monday = Mon etc, default is true
  String? firstDayOfWeek, // first day of the week (CalendarView.monday or CalendarView.sunday)
  bool? upperCaseWeekDayName, // upper case the week day name,
  bool? showOnlyWeekDay,  // shows only the week day name without the date
})
```

`CalendarView.weekViewWithMonth()` properties
```dart
CalendarView.weekViewWithMonth({
  String? firstDayOfWeek, // first day of the week (CalendarView.monday or CalendarView.sunday)
})
```

The default `firstDayOfWeek` is Sunday.

## Demo
View demo in the example tab.

## Contributing

### Github Repository
If you have ideas or improvements for this package, we welcome contributions. Please open an issue or create a pull request on our [GitHub repository](https://github.com/youngcet/task_scheduler).

### Join Our Community on Discord! 🎮

Looking for support, updates, or a place to discuss the **Task Scheduler Flutter Widget**? Join our dedicated Discord channel!

👉 [Join the `#task-scheduler-flutter-widget` channel](https://discord.gg/zTSY4n9P)

### What You'll Find:
- **Help & Support**: Get assistance with integrating and using the package.
- **Feature Discussions**: Share ideas for new features or improvements.
- **Bug Reports**: Report issues and collaborate on fixes.
- **Community Interaction**: Engage with fellow developers working on Flutter projects.

We look forward to seeing you there! 🚀

## License

This package is available under the [MIT License](https://github.com/youngcet/task_scheduler/blob/main/LICENSE).


Support the plugin <a href="https://www.buymeacoffee.com/yungcet" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>