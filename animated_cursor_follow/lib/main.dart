import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'animated_cursor_position.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedCursor(child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedCursorMouseRegion(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white10,
              ),
              child: CupertinoButton(
                color: Colors.redAccent,
                onPressed: () {
                  print('Hello');
                },
                child: Text('Click me!'),
              ),
            ),
            SizedBox(height: 50),
            AnimatedCursorMouseRegion(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 2),
                color: Colors.white10,
              ),
              child: Container(
                height: 50,
                width: 50,
                color: Colors.blue,
                child: Center(child: Text('Hello')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
