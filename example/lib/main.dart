import 'dart:developer';

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
  late TaskScheduler scheduleView;
  late TaskScheduleView taskScheduleView;

  // declare resource headers
  List<ScheduleResourceHeader> headers = [
    ScheduleResourceHeader(
      id: '1',
      position: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Yung',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    ),
    ScheduleResourceHeader(
      id: '2',
      position: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Cedric',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    ),
    ScheduleResourceHeader(
      id: '3',
      position: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Moss',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    ),
    ScheduleResourceHeader(
      id: '4',
      position: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Matt',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    )
  ];

  @override
  void initState() {
    super.initState();

    // instatiate the TaskScheduleView and pass TaskScheduler
    taskScheduleView = TaskScheduleView(
        taskScheduler: TaskScheduler(
      scheduleStartTime: ScheduleTimeline(hour: 8),
      scheduleEndTime: ScheduleTimeline(hour: 17),
      onEmptySlotPressed: handleEmptySlotTap,
      onDragAccept: handleDrop,
      entries: [],
      headers: headers,
      timeFormat: SchedulerTimeSettings(minuteInterval: timeInterval),
    ));

    // declare entries
    List<ScheduleEntry> entries = [
      ScheduleEntry(
        color: Colors.blue,
        id: '123',
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
              content: Text("Support"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Text('Support', style: TextStyle(fontSize: 14)),
      ),
      ScheduleEntry(
        color: Colors.green,
        id: '123444',
        resource: ResourceScheduleEntry(
          index:
              0, // uses this index to add entries against resources, i.e. 0 = 1st resource, 1 = 2nd etc
          hour: 8,
          minutes: 30,
        ),
        duration: 30,
        options: TaskSchedulerSettings(
          isTaskDraggable: true, // false to disable drag
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Plan"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Text(
          'Plan',
          style: TextStyle(fontSize: 14),
        ),
      ),
      ScheduleEntry(
        color: Colors.pink,
        id: '12344',
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
              content: Text("Project"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Text('Project', style: TextStyle(fontSize: 14)),
      ),
      ScheduleEntry(
        color: Colors.orange,
        id: '12345',
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
              content: Text("General"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating));
        },
        child: Text('General', style: TextStyle(fontSize: 14)),
      )
    ];

    scheduleView = taskScheduleView.loadScheduleView(entries: entries);
  }

  void handleDrop(Map<String, dynamic> data) {
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

    setState(() {
      scheduleView = view.updateScheduleView(view, data);
    });
  }

  void handleEmptySlotTap(Map<String, dynamic> data) {
    // Handle the returned data here
    print('Received data from onTap: $data');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("onTap: $data"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating));
  }

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
}
