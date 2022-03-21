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
      title: 'Flutter Demo',
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
  int _mostrecent = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _loadMostrecent();
  }

  void _loadMostrecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mostrecent = (prefs.getInt('mostrecent') ?? DateTime.now().millisecondsSinceEpoch);
    });
  }

  void _resetMostRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mostrecent = DateTime.now().millisecondsSinceEpoch;
      prefs.setInt('mostrecent', _mostrecent);
    });
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
              'You have gone X many minutes without using the H word:',
            ),
            Text(
              '$_mostrecent',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetMostRecent,
        tooltip: 'Reset',
        child: const Icon(Icons.reset_tv),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
