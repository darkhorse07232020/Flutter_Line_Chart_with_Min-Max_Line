import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_first_app/linechart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  List<List<double>> learningData = [
    [1, 1, -1, 1, 1, 1, 1],
    [1, -1, -1, 1, 1, -1, -1],
    [1, 1, -1, 1, 1, 1, 1],
    [1, -1, -1, 1, -1, 1, 1],
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2;
    double width = MediaQuery.of(context).size.width * 1;
    changeList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          // color: Colors.red,
          decoration: BoxDecoration(border: Border.all(width: 1)),
          height: height,
          width: width,
          child: LineChart(
            width: width,
            height: height,
            data: widget.learningData,
            maxValue: maxValue,
            minValue: minValue,
            currentWeek: 2,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  changeList() {
    maxValue = widget.learningData[0][0];
    minValue = widget.learningData[0][0];
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 7; j++) {
        if (i == 0 && j == 0) continue;
        widget.learningData[i][j] += (j == 0
            ? widget.learningData[i - 1][6]
            : widget.learningData[i][j - 1]);
        minValue = min(minValue, widget.learningData[i][j]);
        maxValue = max(maxValue, widget.learningData[i][j]);
      }
    }
    print(widget.learningData);
    print(maxValue);
    print(minValue);
  }
}

double maxValue = -100.0;
double minValue = 100.0;
