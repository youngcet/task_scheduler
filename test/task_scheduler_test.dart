import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_scheduler/task_scheduler.dart';

void main() {
  group('MyApp widget test', () {
    testWidgets('MyApp widget builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('MyHomePage title is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: MyHomePage(title: 'Task Scheduler Demo')));
      expect(find.text('Task Scheduler Demo'), findsOneWidget);
    });

    testWidgets('ScheduleView contains ScheduleEntry widgets',
        (WidgetTester tester) async {
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
          id: '2',
          position: 1,
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
          id: '3',
          position: 2,
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
          id: '4',
          position: 3,
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

      final List<ScheduleEntry> entries = [
        ScheduleEntry(
          color: Colors.blue,
          id: '123',
          resource: ResourceScheduleEntry(index: 0, hour: 9, minutes: 60),
          duration: 60,
          options: TaskSchedulerSettings(isTaskDraggable: true),
          onTap: () {},
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

      final taskScheduleView = TaskScheduleView(
          taskScheduler: TaskScheduler(
              scheduleStartTime: ScheduleTimeline(hour: 8),
              scheduleEndTime: ScheduleTimeline(hour: 17),
              onEmptySlotPressed: (Map<String, dynamic> data) {},
              onDragAccept: (Map<String, dynamic> data) {},
              headers: headers,
              entries: [],
              timeFormat: SchedulerTimeSettings(minuteInterval: 30)));

      TaskScheduler scheduleView =
          taskScheduleView.loadScheduleView(entries: entries);

      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: Center(child: scheduleView))));
      expect(find.byType(ScheduleEntry), findsNWidgets(78));
    });
  });
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: MyHomePage(title: 'Task Scheduler Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

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
  int timeInterval = 30;

  late TaskScheduler scheduleView;
  late TaskScheduleView taskScheduleView;

  List<ScheduleResourceHeader> headers = [
    ScheduleResourceHeader(
      id: '1',
      position: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'title 1',
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
            'title 2',
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
            'title 3',
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
            'title 4',
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
          print('new entry clicked');
        },
        child: Text('Booked'),
      ),
      ScheduleEntry(
        color: Colors.green,
        id: '1234',
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
          print('new entry clicked');
        },
        child: Text('Booked'),
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
          child:
              scheduleView), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
