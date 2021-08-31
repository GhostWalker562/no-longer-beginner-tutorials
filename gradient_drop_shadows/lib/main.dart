import 'package:flutter/material.dart';

import 'gradient_rect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GradientRect(
              boxShadow: GradientBoxShadow(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.blue,
                    Colors.orange,
                  ],
                ),
                blurRadius: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70,
                ),
                child: Center(child: Text('Gradient')),
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(blurRadius: 8),
                ],
              ),
              child: Center(child: Text('Default')),
            ),
          ],
        ),
      ),
    );
  }
}
