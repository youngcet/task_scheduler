import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_scheduler/task_scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Scheduler',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Task Scheduler Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // minute intervals
  int timeInterval = 30;

  // declare the TaskScheduler and TaskScheduleView
  late TaskScheduler taskScheduler;
  late TaskScheduleView taskScheduleView;

  List<String> resources = ['Cedric', 'Yung', 'Moss', 'Matt'];

  String selectedItem = 'Custom Header';
  final List<String> items = [
    'Custom Header',
    'Week View',
    'Week View With Month'
  ];

  final List<String> intervals = [
    '10',
    '15',
    '20',
    '30',
    '60'
  ];

  List<ScheduleResourceHeader> taskSchedulerHeader = [];

  // declare resource headers
  List<ScheduleResourceHeader> headers = [
    ScheduleResourceHeader(
        id: '1',
        title: 'Cedric',
        position: 0,
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2016/11/29/01/44/hands-1866619_640.jpg'), // Replace URL with your image URL
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: Text(
                  'Cedric',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        )),
    ScheduleResourceHeader(
        id: '2',
        title: 'Yung',
        position: 1,
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/02/17/08/46/face-639139_640.jpg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: Text(
                  'Yung',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        )),
    ScheduleResourceHeader(
        id: '3',
        position: 2,
        title: 'Moss',
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/09/25/09/49/light-956980_640.jpg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: Text(
                  'Moss',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        )),
    ScheduleResourceHeader(
        id: '4',
        position: 3,
        title: 'Matt',
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/06/30/15/55/camera-2458579_640.jpg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: const Text(
                  'Matt',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        )),
    ScheduleResourceHeader(
        id: '5',
        position: 4,
        title: 'Minnieh',
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2020/04/23/19/15/face-5083690_1280.jpg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: Text(
                  'Minnieh',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        )),
    ScheduleResourceHeader(
        id: '6',
        position: 5,
        title: 'Emon',
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.cyan,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/11/26/01/46/valley-2977990_640.jpg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: const Text(
                  'Emon',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        )),
    ScheduleResourceHeader(
        id: '7',
        position: 6,
        title: 'Mpho',
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.yellow,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/10/10/16/58/hand-2837954_640.jpg'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                ),
                child: const Text(
                  'Mpho',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ))
  ];

  @override
  void initState() {
    super.initState();

    // declare entries
    List<ScheduleEntry> entries = [
      ScheduleEntry(
          color: Colors.blue,
          id: generateId(5),
          resource: ResourceScheduleEntry(
            index:
                0, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 9,
            minutes: 60,
          ),
          duration: 60,
          options: TaskSchedulerSettings(
            isTaskDraggable: true, // false to disable drag
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Team Meeting"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Team Meeting',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                "Daily team sync-up",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          )),
      ScheduleEntry(
          color: Colors.green,
          id: generateId(5),
          resource: ResourceScheduleEntry(
            index:
                0, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 8,
            minutes: 30,
          ),
          duration: 30,
          options: TaskSchedulerSettings(
            isTaskDraggable: true, // false to disable drag
            taskResizeMode: {
              'allowResize': true,
              'onResizeEnd': onResizeEnd,
              'onResizeUpdate': onResizeUpdate
            },
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Code Review"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Code Review',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                'Review pull requests',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          )),
      ScheduleEntry(
          color: Colors.pink,
          id: generateId(5),
          resource: ResourceScheduleEntry(
            index:
                1, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 8,
            minutes: 0,
          ),
          duration: 120,
          options: TaskSchedulerSettings(
            isTaskDraggable: true, // false to disable drag
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Client Presentation"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Client Presentation',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                'Update client meeting',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          )),
      ScheduleEntry(
        color: Colors.orange,
        id: generateId(5),
        resource: ResourceScheduleEntry(
          index:
              3, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
          hour: 8,
          minutes: 0,
        ),
        duration: 240,
        options: TaskSchedulerSettings(
          isTaskDraggable: true, // false to disable drag
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Development Session"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Development Session',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              'Feature development work',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      ScheduleEntry(
        color: Colors.yellow,
        id: generateId(5),
        resource: ResourceScheduleEntry(
          index:
              5, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
          hour: 9,
          minutes: 0,
        ),
        duration: 60,
        options: TaskSchedulerSettings(
          isTaskDraggable: true, // false to disable drag
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Task Scheduler"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Task Scheduler',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              'Bug fixing',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      ScheduleEntry(
        color: Colors.yellow,
        id: generateId(5),
        resource: ResourceScheduleEntry(
          index:
              2, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
          hour: 14,
          minutes: 0,
        ),
        duration: 60,
        options: TaskSchedulerSettings(
          isTaskDraggable: true, // false to disable drag
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Testing and QA"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Testing and QA',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              'Test new features',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      )
    ];

    List<BlockedEntry> blockedEntries = [
      BlockedEntry(
          resource: ResourceScheduleEntry(
            index:
                2, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 8,
            minutes: 0,
          ),
          duration: 60),
      BlockedEntry(
          resource: ResourceScheduleEntry(
            index:
                2, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 11,
            minutes: 0,
          ),
          duration: 120),
      BlockedEntry(
          resource: ResourceScheduleEntry(
            index:
                0, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 9,
            minutes: 0,
          ),
          duration: 60),
      BlockedEntry(
          resource: ResourceScheduleEntry(
            index:
                1, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 10,
            minutes: 30,
          ),
          duration: 60),
      BlockedEntry(
          resource: ResourceScheduleEntry(
            index:
                5, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 8,
            minutes: 30,
          ),
          duration: 240),
      BlockedEntry(
          title: 'Lunch break',
          resource: ResourceScheduleEntry(
            index:
                0, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 13,
            minutes: 0,
          ),
          duration: 30),
      BlockedEntry(
          title: 'Lunch break',
          resource: ResourceScheduleEntry(
            index:
                1, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 13,
            minutes: 0,
          ),
          duration: 30),
      BlockedEntry(
          title: 'Lunch break',
          resource: ResourceScheduleEntry(
            index:
                2, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 13,
            minutes: 0,
          ),
          duration: 30),
      BlockedEntry(
          title: 'Lunch break',
          resource: ResourceScheduleEntry(
            index:
                3, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 13,
            minutes: 0,
          ),
          duration: 30),
      BlockedEntry(
          title: 'Lunch break',
          resource: ResourceScheduleEntry(
            index:
                4, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 13,
            minutes: 0,
          ),
          duration: 30),
      BlockedEntry(
          title: 'Lunch break',
          resource: ResourceScheduleEntry(
            index:
                5, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 13,
            minutes: 0,
          ),
          duration: 30),
      BlockedEntry(
          title: 'Off',
          resource: ResourceScheduleEntry(
            index:
                6, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
            hour: 8,
            minutes: 0,
          ),
          duration: 600),
    ];

    // instatiate the TaskScheduleView and pass TaskScheduler
    taskScheduleView = TaskScheduleView(
        taskScheduler: TaskScheduler(
      scheduleStartTime: ScheduleTimeline(hour: 8),
      scheduleEndTime: ScheduleTimeline(hour: 17),
      onEmptySlotPressed: handleEmptySlotTap,
      onDragAccept: handleDrop,
      entries: [],
      blockedEntries: blockedEntries,
      headers: headers,
      timeFormat: SchedulerTimeSettings(
        minuteInterval: timeInterval,
        use24HourFormat: true,
      ),
    ));

    taskScheduler = taskScheduleView.loadScheduleView(entries: entries);
  }

  void handleDrop(Map<String, dynamic> data) {
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
    
    setState(() {
      try {
        taskScheduler = view.updateScheduleView(view, data);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating));
      }
    });
  }

  void onResizeEnd(Map<String, dynamic> resizeData) {
    // Define the function to handle resize end event
    // You can implement the logic here to handle resize end
    print('onResizeEnd');
  }

  void onResizeUpdate(ScheduleEntry entry) {
    // Define the function to handle resize update event
    // You can implement the logic here to handle resize update
    print('onResizeUpdate');
    taskScheduleView.onResizeEntry(entry);
  }

  void _createNewEntry(BuildContext context, Map<String, dynamic> data) {
    print(data);
    int resourceIndex = data['resource']['index'];
    String resourceName = data['resource_title'];
    String hour = (data['resource']['hour'] < 10)
        ? '0${data['resource']['hour']}'
        : data['resource']['hour'].toString();
    String minutes = (data['resource']['minutes'] < 10)
        ? '0${data['resource']['minutes']}'
        : data['resource']['minutes'].toString();

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
                "Time: $hour:$minutes\nResource: $resourceName",
                style: TextStyle(fontSize: 14),
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

                if (title.isNotEmpty && duration.isNotEmpty) {
                  // create a new task scheduler
                  TaskScheduler newTaskScheduler = TaskScheduler(
                    scheduleStartTime: taskScheduler.scheduleStartTime,
                    scheduleEndTime: taskScheduler.scheduleEndTime,
                    onEmptySlotPressed: handleEmptySlotTap,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '08:00 AM - 10:00 AM',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  );

                  // check that the resource slot is available
                  if (taskScheduleView.isResourceSlotAvailable(newEntry)) {
                    // slot is available, add entry
                    newTaskScheduler.entries?.add(newEntry);
                  } else {
                    // slot not available
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Error: Slot not Available."),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating));
                  }

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

  String generateId(int length) {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  void handleEmptySlotTap(Map<String, dynamic> data) {
    // Handle the returned data here
    _createNewEntry(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.all(16.0), // Add padding around the dropdown
              child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Make the row as wide as its content
                  children: <Widget>[
                    const Text(
                      'Select Header:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10), // Align the dropdown to the left
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      value: selectedItem,
                      onChanged: (String? newValue) {
                        if (newValue == 'Custom Header') {
                          taskSchedulerHeader = headers;
                        }

                        if (newValue == 'Week View') {
                          taskSchedulerHeader = CalendarView.weekView();
                        }

                        if (newValue == 'Week View With Month') {
                          taskSchedulerHeader =
                              CalendarView.weekViewWithMonth();
                        }

                        TaskScheduler newTaskScheduler = TaskScheduler(
                          scheduleStartTime: taskScheduler.scheduleStartTime,
                          scheduleEndTime: taskScheduler.scheduleEndTime,
                          onEmptySlotPressed: handleEmptySlotTap,
                          onDragAccept: handleDrop,
                          entries: taskScheduler.entries,
                          headers: taskSchedulerHeader,
                          timeFormat: taskScheduler.timeFormat,
                        );

                        setState(() {
                          selectedItem = newValue!;
                          taskScheduler = newTaskScheduler;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Showing $selectedItem')),
                        );
                      },
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const Text(
                      'Select Intervals:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      value: timeInterval.toString(),
                      onChanged: (String? newValue) {
                        SchedulerTimeSettings schedulerTimeSettings = taskScheduler.timeFormat!;
                        schedulerTimeSettings.minuteInterval = int.parse(newValue!);

                        TaskScheduler newTaskScheduler = TaskScheduler(
                          scheduleStartTime: taskScheduler.scheduleStartTime,
                          scheduleEndTime: taskScheduler.scheduleEndTime,
                          onEmptySlotPressed: handleEmptySlotTap,
                          onDragAccept: handleDrop,
                          entries: taskScheduler.entries,
                          headers: taskScheduler.headers,
                          timeFormat: taskScheduler.timeFormat,
                        );
                        inspect(taskScheduler);
                        setState(() {
                          timeInterval = int.parse(newValue);
                          //taskScheduler = newTaskScheduler;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Showing $newValue minute intervals')),
                        );
                      },
                      items:
                          intervals.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(child: taskScheduler),
            ),
          ],
        ));
  }
}
