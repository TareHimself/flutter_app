import 'dart:async';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async {
    // Hide window title bar
    await windowManager.setTitle("Flutter App");
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.center();
    await windowManager.show();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _toggleFullscreen() async {
    await windowManager.setFullScreen(!(await windowManager.isFullScreen()));
  }

  String pad(int toBePadded, {int minLength = 2}) {
    String returnValue = '$toBePadded';

    int needed = minLength - returnValue.length;

    for (int i = 0; i < needed; i++) {
      returnValue = "0$returnValue";
    }
    return returnValue;
  }

  @override
  void initState() {
    Timer.periodic(
        const Duration(seconds: 1), ((timer) => _incrementCounter()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int timeHours = (_counter / 3600).floor();
    int timeMins = (_counter / 60).floor() % 60;
    int timeSecs = _counter % 60;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://wallpaperz.nyc3.cdn.digitaloceanspaces.com/wallpapers/09cd0bb6-5e4d-4305-8c11-1c4a69ab6af9.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${pad(timeHours)}:${pad(timeMins)}:${pad(timeSecs)}',
                  style: const TextStyle(color: Colors.white, fontSize: 50),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleFullscreen,
            tooltip: 'Toggle Fullscreen',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        ));
  }
}
