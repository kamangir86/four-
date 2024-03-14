import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rectangle with Dynamic Lines',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rectangle with Dynamic Lines'),
        ),
        body: Center(
          child: CustomPaint(
            size: Size(300, 200),
            painter: RectangleWithLinesPainter(),
          ),
        ),
      ),
    );
  }
}

class RectangleWithLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    Offset startPoint1 = Offset(150, 100);
    Offset endPoint11 = Offset(150, 0);
    Offset endPoint12 = Offset(150, size.height);
    canvas.drawLine(startPoint1, endPoint11, paint);
    canvas.drawLine(startPoint1, endPoint12, paint);

    Offset startPoint2 = Offset(75, 100);
    Offset endPoint21 = Offset(0, 100);
    Offset endPoint22 = Offset(size.width, 100);
    canvas.drawLine(startPoint2, endPoint21, paint);

    Offset closestEdge1 = findClosestEdge(startPoint2, size);
    Offset closestEdge2 = findClosestEdge(endPoint12, size);

    // Draw the horizontal line to the closest edges
    canvas.drawLine(startPoint2, closestEdge1, paint);
    canvas.drawLine(endPoint12, closestEdge2, paint);
  }

  Offset findClosestEdge(Offset point, Size size) {
    double topDistance = point.dy;
    double bottomDistance = size.height - point.dy;
    double leftDistance = point.dx;
    double rightDistance = size.width - point.dx;

    double minDistance = min(topDistance, min(bottomDistance, min(leftDistance, rightDistance)));

    if (minDistance == topDistance) {
      return Offset(point.dx, 0);
    } else if (minDistance == bottomDistance) {
      return Offset(point.dx, size.height);
    } else if (minDistance == leftDistance) {
      return Offset(0, point.dy);
    } else {
      return Offset(size.width, point.dy);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
