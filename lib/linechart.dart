import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class LineChart extends StatefulWidget {
  LineChart({
    Key key,
    this.title,
    this.width = 300,
    this.height = 100,
    this.data,
    this.maxValue,
    this.minValue,
    this.currentWeek,
  }) : super(key: key);
  final String title;
  final double width;
  final double height;
  final List<List<double>> data;
  final double maxValue;
  final double minValue;
  final int currentWeek;

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  void getInit() {
    deltaH = (widget.height - 40) /
        (widget.maxValue - min(widget.minValue, 0) + 1.0);
    deltaW = widget.width / 9.0;
  }

  @override
  void initState() {
    getInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: CustomPaint(
            painter: LinePainter(
              widget.width,
              widget.height,
              widget.data,
              widget.maxValue,
              widget.minValue,
              widget.currentWeek,
            ),
          ),
        ),

        // Zero shape
        Positioned(
          right: 20,
          top: (widget.maxValue + 1) * deltaH - 11,
          child: Container(
            width: 36,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                '0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),

        // Max shape
        Positioned(
          right: 20,
          top: deltaH - 11,
          child: Container(
            width: 36,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                'MAX',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),

        // MIN shape
        Positioned(
          right: 20,
          top: (widget.maxValue - widget.minValue + 1) * deltaH - 11,
          child: Container(
            width: 36,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                'MIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  final double width;
  final double height;
  final List<List<double>> data;
  final double maxValue;
  final double minValue;
  final int currentWeek;

  LinePainter(
    this.width,
    this.height,
    this.data,
    this.maxValue,
    this.minValue,
    this.currentWeek,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var path = Path();

    //draw zero line
    path.reset();
    paint.color = Colors.grey;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    path
      ..moveTo(0, (maxValue + 1) * deltaH)
      ..lineTo(width, (maxValue + 1) * deltaH);
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(<double>[3.0, 8.0]),
      ),
      paint,
    );

    //draw max line
    path.reset();
    paint.color = Colors.blue;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    path
      ..moveTo(0, deltaH)
      ..lineTo(width, deltaH);
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(<double>[3.0, 8.0]),
      ),
      paint,
    );

    //draw min line
    path.reset();
    paint.color = Colors.red;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    path
      ..moveTo(0, (maxValue - minValue + 1) * deltaH)
      ..lineTo(width, (maxValue - minValue + 1) * deltaH);
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(<double>[3.0, 8.0]),
      ),
      paint,
    );

    //draw chart
    path.reset();
    paint.color = Colors.blue;
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    if (currentWeek == 0) {
      path.moveTo(deltaW, convertYAxis(data[currentWeek][0]) * deltaH);
    } else {
      path
        ..moveTo(0, convertYAxis(data[currentWeek - 1][6]) * deltaH)
        ..lineTo(deltaW, convertYAxis(data[currentWeek][0]) * deltaH);
    }
    for (var i = 1; i < 7; i++) {
      path.lineTo(
          (i + 1) * deltaW, convertYAxis(data[currentWeek][i]) * deltaH);
    }
    if (currentWeek < 11) {
      path
        ..lineTo(8 * deltaW, convertYAxis(data[currentWeek + 1][0]) * deltaH)
        ..lineTo(9 * deltaW, convertYAxis(data[currentWeek + 1][1]) * deltaH);
    }
    canvas.drawPath(path, paint);

    paint.color = Colors.blue;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.fill;
    if (currentWeek == 0) {
      canvas.drawCircle(
          Offset(deltaW, convertYAxis(data[currentWeek][0]) * deltaH),
          6,
          paint);
    } else {
      canvas.drawCircle(
          Offset(0, convertYAxis(data[currentWeek - 1][6]) * deltaH), 6, paint);
      canvas.drawCircle(
          Offset(deltaW, convertYAxis(data[currentWeek][0]) * deltaH),
          6,
          paint);
    }
    for (var i = 1; i < 7; i++) {
      canvas.drawCircle(
          Offset((i + 1) * deltaW, convertYAxis(data[currentWeek][i]) * deltaH),
          6,
          paint);
    }
    if (currentWeek < 11) {
      canvas.drawCircle(
          Offset(8 * deltaW, convertYAxis(data[currentWeek + 1][0]) * deltaH),
          6,
          paint);
      canvas.drawCircle(
          Offset(9 * deltaW, convertYAxis(data[currentWeek + 1][1]) * deltaH),
          6,
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double convertYAxis(double y) {
    return (maxValue - min(minValue, 0) + 1) - y;
  }
}

double deltaH;
double deltaW;
