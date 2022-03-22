import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Great Anti-H*** Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'The Great Anti-H*** Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _mostrecent;

  int _daysSince = 0;
  int _hoursSince = 0;
  int _minutesSince = 0;
  int _secondsSince = 0;

  @override
  void initState() {
    super.initState();
    _mostrecent = _prefs.then((SharedPreferences prefs) {
      int newOrCurrentValue = prefs.getInt('mostrecent') ?? DateTime.now().millisecondsSinceEpoch;
      prefs.setInt('mostrecent', newOrCurrentValue);
      return newOrCurrentValue;
    });
    _calculateDeltas();
    Timer.periodic(const Duration(seconds: 10), (Timer t) => _calculateDeltas());
  }

  void _calculateDeltas() async {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(await _mostrecent);
    var diff = now.difference(date);
    setState(() {
      _daysSince = diff.inDays;
      _hoursSince = diff.inHours;
      _minutesSince = diff.inMinutes;
      _secondsSince = diff.inSeconds;
    });
  }

  void _resetMostRecent() async {
    final SharedPreferences prefs = await _prefs;
    final int mostrecentL = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      _mostrecent = prefs.setInt('mostrecent', mostrecentL).then((bool success) {
        return mostrecentL;
      });
    });

    _calculateDeltas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have gone this long without using the H word:',
            ),
            const Text(
              'Days',
            ),
            Text(
              '$_daysSince',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              'Hours',
            ),
            Text(
              '$_hoursSince',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              'Minutes',
            ),
            Text(
              '$_minutesSince',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              'Seconds',
            ),
            Text(
              '$_secondsSince',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetMostRecent,
        tooltip: 'Reset',
        child: const Icon(Icons.reset_tv),
      ),
    );
  }
}
