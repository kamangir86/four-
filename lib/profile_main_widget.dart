import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourplus/main.dart';

ValueNotifier<List<double>> verticalSheetsSize =
    ValueNotifier<List<double>>([]);
ValueNotifier<List<double>> horizontalSheetsSize =
    ValueNotifier<List<double>>([]);
GlobalKey key = GlobalKey();

class ProfileMainWidget extends StatefulWidget {
  const   ProfileMainWidget(
      {required this.height, required this.width, super.key});

  final double height;
  final double width;

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  List<MyDragTargetDetails<Profile>> myList = [];
  List<MyDragTargetDetails<Profile>> data = [];

  var sizeOfSizeWidget = 300.0;


  @override
  Widget build(BuildContext context) {
    var availableWidth = MediaQuery.sizeOf(context).width;
    var availableHeight = MediaQuery.sizeOf(context).height - 244;

    data = myList;
    List<MyDragTargetDetails<Profile>> dataCopy = List.from(data);

    dataCopy.insertAll(0, [
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: false),
        offset: Offset(widget.width / 2, 0),
        fixed: true,
        changedOffset: false,
        start: const Offset(0, 0),
        end: Offset(widget.width, 0),
      ),
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: false),
        offset: Offset(widget.width / 2, widget.height),
        fixed: true,
        changedOffset: false,
        start: Offset(0, widget.height),
        end: Offset(widget.width, widget.height),
      ),
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: true),
        offset: Offset(widget.width / 2, 0),
        fixed: true,
        changedOffset: false,
        start: const Offset(0, 0),
        end: Offset(0, widget.height),
      ),
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: true),
        offset: Offset(widget.width / 2, 0),
        fixed: true,
        changedOffset: false,
        start: Offset(widget.width, 0),
        end: Offset(widget.width, widget.height),
      ),
    ]);

    for (var i = 0; i < data.length; i++) {
      Edge edge;
      if (!data[i].fixed || data[i].changedOffset) {
        edge = findDrawableEdges(dataCopy, data[i], i);
      } else {
        edge = data[i].edge!;
      }

      data[i].edge = edge;

      if (data[i].data.name == ProfileName.vertical) {
        var point = (edge.left + (edge.right - edge.left) / 2).ceil();
        if (!data[i].fixed && !data[i].changedOffset) {
          data[i].offset = Offset(point.toDouble(), edge.top + (edge.bottom - edge.top) / 2);
          data[i].fixed = true;
          data[i].start = Offset(point.toDouble(), edge.top);
          data[i].end = Offset(point.toDouble(), edge.bottom);
        }
      } else if (data[i].data.name == ProfileName.horizontal) {
        var point = (edge.top + (edge.bottom - edge.top) / 2).ceil();
        if (!data[i].fixed && !data[i].changedOffset) {
          data[i].offset = Offset(
              edge.left + (edge.right - edge.left) / 2, point.toDouble());
          data[i].fixed = true;
          data[i].start = Offset(edge.left, point.toDouble());
          data[i].end = Offset(edge.right, point.toDouble());
        }
      }
    }

    computeSizeOfSheets(data, Size(widget.width, widget.height));

    return Container(
      color: Colors.transparent,
      height: availableHeight,
      width: availableWidth,
      margin: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              width: sizeOfSizeWidget,
              child: ValueListenableBuilder<List<double>?>(
                valueListenable: verticalSheetsSize,
                builder: (BuildContext context, value, Widget? child) {
                  return VerticalSize(
                    height: widget.height,
                    splits: value, // [25, 25, 25, 25],
                    onChangeSize: (int newValue, int index) {
                      changeSizeOfSheet(index, newValue,
                          axis: Axis.horizontal);
                    },
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CustomPaint(
                      key: key,
                      painter: MyPainter(data: myList),
                      size: Size(widget.width, widget.height),
                    ),
                    MyDragTaget<Profile>(
                      size: Size(widget.width, widget.height),
                      onAcceptWithDetails: (data) {
                        myList.add(data);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  height: sizeOfSizeWidget,
                  child: ValueListenableBuilder<List<double>?>(
                    builder: (BuildContext context, List<double>? value,
                        Widget? child) {
                      return HorizontalSize(
                        width: widget.width,
                        splits: value, // [150, 75,75],
                        onChangeSize: (int newValue, int index) {
                          changeSizeOfSheet(
                            index,
                            newValue,
                            axis: Axis.vertical,
                          );
                        },
                      );
                    },
                    valueListenable: horizontalSheetsSize,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Edge findDrawableEdges(List<MyDragTargetDetails<Profile>> allLines,
      MyDragTargetDetails<Profile> target, int index) {
    double x = target.offset.dx;
    double y = target.offset.dy;

    double topEdge = double.infinity;
    double bottomEdge = double.negativeInfinity;
    double leftEdge = double.negativeInfinity;
    double rightEdge = double.infinity;

    List<MyDragTargetDetails<Profile>> lines = List.from(allLines);
    lines.removeRange(index + 4, lines.length);

    for (var line in lines) {
      double startX = line.start!.dx;
      double startY = line.start!.dy;
      double endX = line.end!.dx;
      double endY = line.end!.dy;

      // Check for vertical lines
      if (startY == endY && (x >= startX && x <= endX)) {
        if (y >= startY && (x >= startX && x <= endX)) {
          bottomEdge = max(bottomEdge, endY);
        }
        if (y <= endY && (x >= startX && x <= endX)) {
          topEdge = min(topEdge, startY);
        }
      }

      // Check for horizontal lines
      if (startX == endX && (y >= startY && y <= endY)) {
        if (x >= startX && (y >= startY && y <= endY)) {
          leftEdge = max(leftEdge, startX);
        }
        if (x <= endX && (y >= startY && y <= endY)) {
          rightEdge = min(rightEdge, endX);
        }
      }
    }

    return Edge(
        top: bottomEdge, bottom: topEdge, left: leftEdge, right: rightEdge);
  }

  void computeSizeOfSheets(List<MyDragTargetDetails<Profile>> data, Size size) {
    List<double>? vSheetsSize;
    List<double>? hSheetsSize;

    List<MyDragTargetDetails<Profile>> vElement = [];
    List<MyDragTargetDetails<Profile>> hElement = [];

    data.forEach((element) {
      if (element.data.isVertical) {
        vElement.add(element);
      } else {
        hElement.add(element);
      }
    });

    vSheetsSize = [];
    hSheetsSize = [];

    List<double> vDistances = [];
    List<double> hDistances = [];

    if (hElement.isNotEmpty) {
      hElement.forEach((element) {
        vSheetsSize!.add(element.start!.dy);
      });

      vSheetsSize.sort();
      vSheetsSize.insert(0, 0);
      vSheetsSize.add(size.height);
      List<double> uniqueNumbers = [];

      for (var number in vSheetsSize) {
        if (!uniqueNumbers.contains(number)) {
          uniqueNumbers.add(number);
        }
      }

      vSheetsSize = uniqueNumbers;

      for (int i = 0; i < vSheetsSize.length - 1; i++) {
        double distance = vSheetsSize[i + 1] - vSheetsSize[i];
        vDistances.add(distance);
      }
    }

    if (vElement.isNotEmpty) {
      vElement.forEach((element) {
        hSheetsSize!.add(element.start!.dx);
      });

      hSheetsSize.sort();
      hSheetsSize.insert(0, 0);
      hSheetsSize.add(size.width);
      List<double> uniqueNumbers = [];

      for (var number in hSheetsSize) {
        if (!uniqueNumbers.contains(number)) {
          uniqueNumbers.add(number);
        }
      }

      hSheetsSize = uniqueNumbers;
      for (int i = 0; i < hSheetsSize.length - 1; i++) {
        double distance = hSheetsSize[i + 1] - hSheetsSize[i];
        hDistances.add(distance);
      }
    }

    verticalSheetsSize = ValueNotifier(vDistances);
    horizontalSheetsSize = ValueNotifier(hDistances);
  }

  void changeSizeOfSheet(int index, int newValue, {required Axis axis}) {
    // horizontalSheetsSize = ValueNotifier(hDistances);

    if (axis == Axis.horizontal) {
      //مجموع را از اول تا اندکس
      var sum = 0.0;
      var remainingValue = 0.0;

      if (index == verticalSheetsSize.value.length - 1) {
        for (int i = 0; i <= index - 1; i++) {
          sum += verticalSheetsSize.value[i];
        }
        remainingValue = sum + verticalSheetsSize.value[index] - newValue;
      } else {
        for (int i = 0; i <= index; i++) {
          sum += verticalSheetsSize.value[i];
        }
        remainingValue = sum - verticalSheetsSize.value[index] + newValue;
      }

      for (int i = 0; i < data.length; i++) {
        if (!data[i].data.isVertical) {
          if (data[i].start!.dy == sum) {
            data[i].start =
                Offset(data[i].start!.dx, remainingValue.toDouble());
            data[i].end = Offset(data[i].end!.dx, remainingValue.toDouble());
            data[i].offset = Offset(
                data[i].offset.dx,
                data[i].start!.dy +
                    ((data[i].end!.dy - data[i].start!.dy) / 2));
            data[i].changedOffset = true;
          }
        }
        if (data[i].data.isVertical) {
          if (data[i].start!.dy == sum) {
            data[i].start =
                Offset(data[i].start!.dx, remainingValue.toDouble());
            data[i].offset = Offset(
                data[i].offset.dx,
                data[i].start!.dy +
                    ((data[i].end!.dy - data[i].start!.dy) / 2));
            data[i].changedOffset = true;
          }
          if (data[i].end!.dy == sum) {
            data[i].end = Offset(data[i].end!.dx, remainingValue.toDouble());
            data[i].offset = Offset(
                data[i].offset.dx,
                data[i].start!.dy +
                    ((data[i].end!.dy - data[i].start!.dy) / 2));
            data[i].changedOffset = true;
          }
        }
      }
    }
    if (axis == Axis.vertical) {
      //مجموع را از اول تا اندکس
      var sum = 0.0;
      var remainingValue = 0.0;

      if (index == horizontalSheetsSize.value.length - 1) {
        for (int i = 0; i <= index - 1; i++) {
          sum += horizontalSheetsSize.value[i];
        }
        remainingValue = sum + horizontalSheetsSize.value[index] - newValue;
      } else {
        for (int i = 0; i <= index; i++) {
          sum += horizontalSheetsSize.value[i];
        }
        remainingValue = sum - horizontalSheetsSize.value[index] + newValue;
      }

      // sum += remainingValue;

      for (int i = 0; i < data.length; i++) {
        if (data[i].data.isVertical) {
          if (data[i].start!.dx == sum) {
            data[i].start =
                Offset(remainingValue.toDouble(), data[i].start!.dy);
            data[i].end = Offset(remainingValue.toDouble(), data[i].end!.dy);

            data[i].offset = Offset(
                data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2),
                data[i].offset.dy);
            data[i].changedOffset = true;
          }
        }
        if (!data[i].data.isVertical) {
          if (data[i].start!.dx == sum) {
            // if(data[i].offset.dx > sum) {
            //   data[i].offset = Offset(data[i].offset.dx - ((sum - remainingValue.toDouble()) / 2), data[i].offset.dy);
            // } else {
            //   data[i].offset = Offset(data[i].offset.dx + ((sum - remainingValue.toDouble()) / 2), data[i].offset.dy);
            // }

            data[i].start =
                Offset(remainingValue.toDouble(), data[i].start!.dy);
            data[i].offset = Offset(
                data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2),
                data[i].offset.dy);
            data[i].changedOffset = true;
          }
          if (data[i].end!.dx == sum) {
            data[i].end = Offset(remainingValue.toDouble(), data[i].end!.dy);
            data[i].offset = Offset(
                data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2),
                data[i].offset.dy);
            data[i].changedOffset = true;
          }
        }
      }
    }

    setState(() {});
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.data});

  double ratio = 1;
  int sizeScale = 65;
  List<MyDragTargetDetails<Profile>> data;
  var z1 = 0.0;
  var z2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width > size.height) {
      ratio = size.width / size.height;
    } else {
      ratio = size.height / size.width;
    }

    z1 = sizeScale.toDouble();
    z2 = z1 + (z1 / 3);

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    drawAroud(canvas, size, paint);

    for (var i = 0; i < data.length; i++) {
      Edge edge;
      edge = data[i].edge!;

      if (data[i].data.name == ProfileName.vertical || data[i].data.name == ProfileName.horizontal) {
        drawSplitter(canvas, paint, data[i].data.isVertical, size,
            start: data[i].start!,
            end: data[i].end!);
        /*if (data[i].changedOffset) {
          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: Offset(data[i].offset.dx, edge.top),
              end: Offset(data[i].offset.dx, edge.bottom));
        } else {
          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: Offset(edge.left + (edge.right - edge.left) / 2, edge.top),
              end: Offset(
                  edge.left + (edge.right - edge.left) / 2, edge.bottom));
        }*/
      } else
      if (data[i].data.name == ProfileName.horizontal) {
        /*if (data[i].changedOffset) {
          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: Offset(edge.left, data[i].offset.dy),
              end: Offset(edge.right, data[i].offset.dy));
        } else {
          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: Offset(edge.left, edge.top + (edge.bottom - edge.top) / 2),
              end: Offset(edge.right, edge.top + (edge.bottom - edge.top) / 2));
        }*/
      } else
      if (data[i].data.name == ProfileName.double) {
        if (data[i].changedOffset) {
          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: Offset(data[i].offset.dx, edge.top),
              end: Offset(data[i].offset.dx, edge.bottom));
        } else {

          data[i].start = Offset(edge.left + (edge.right - edge.left) / 3, edge.top);
          data[i].end = Offset(edge.left + (edge.right - edge.left) / 3, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx, (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].start2 = Offset((edge.left + (edge.right - edge.left) / 3) * 2, edge.top);
          data[i].end2 = Offset((edge.left + (edge.right - edge.left) / 3) * 2, edge.bottom);
          data[i].offset2 = Offset(data[i].start2!.dx, (data[i].end2!.dy - data[i].start2!.dy) / 2);

          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: data[i].start!, end: data[i].end!);

        drawSplitter(canvas, paint, data[i].data.isVertical, size,
            start: data[i].start2!, end: data[i].end2!);
        }
      } else
      if (data[i].data.name == ProfileName.fillH) {} else
      if (data[i].data.name == ProfileName.fillV) {} else
      if (data[i].data.name == ProfileName.left) {} else
      if (data[i].data.name == ProfileName.right) {} else
      if (data[i].data.name == ProfileName.top) {} else
      if (data[i].data.name == ProfileName.topRight) {} else
      if (data[i].data.name == ProfileName.topLeft) {} else
      if (data[i].data.name == ProfileName.dLeft) {} else
      if (data[i].data.name == ProfileName.dRight) {}
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawAroud(Canvas canvas, Size size, Paint paint) {
    // path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    // path.addRect(Rect.fromLTWH(z1, z1, size.width - (2 * z1), size.height - (2 * z1)));
    // path.addRect(Rect.fromLTWH(z2, z2, size.width - (2 * z2), size.height - (2 * z2)));

    var paint2 = Paint();
    paint2.color = Colors.blue;
    paint2.style = PaintingStyle.fill;

    var paint3 = Paint();
    paint3.color = Colors.white;
    paint3.style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawRect(
        Rect.fromLTWH(z1, z1, size.width - (2 * z1), size.height - (2 * z1)),
        paint);
    canvas.drawRect(
        Rect.fromLTWH(z2, z2, size.width - (2 * z2), size.height - (2 * z2)),
        paint2);
    canvas.drawRect(
        Rect.fromLTWH(z2, z2, size.width - (2 * z2), size.height - (2 * z2)),
        paint);

    canvas.drawLine(const Offset(0, 0), Offset(z2, z2), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - z2, z2), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(z2, size.height - z2), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - z2, size.height - z2), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - z2, size.height - z2), paint);
  }

  void drawSplitter(Canvas canvas, Paint paint, bool isVertical, Size size,
      {required Offset start, required Offset end}) {
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black;

    var path = Path();
    var paint2 = Paint();
    paint2.style = PaintingStyle.stroke;
    paint2.color = Colors.white;
    paint2.style = PaintingStyle.fill;

    if (isVertical) {
      var topEdg = true;
      var bottomEdge = true;

      if (start.dy == 0)
        topEdg = true;
      else
        topEdg = false;

      if (end.dy == size.height)
        bottomEdge = true;
      else
        bottomEdge = false;

      var vp1 = Offset((start.dx - z1 / 2), start.dy + (topEdg ? z1 : z1 / 2));
      var vp2 = Offset((start.dx + z1 / 2), start.dy + (topEdg ? z1 : z1 / 2));
      var vp3 = Offset((start.dx + (z2 - (z1 / 2))),
          start.dy + (z2 - (topEdg ? 0 : z1 / 2)));
      var vp4 = Offset((end.dx + (z2 - (z1 / 2))),
          end.dy - (z2 - (bottomEdge ? 0 : z1 / 2)));
      var vp5 = Offset((end.dx + z1 / 2), end.dy - (bottomEdge ? z1 : z1 / 2));
      var vp6 = Offset((end.dx - z1 / 2), end.dy - (bottomEdge ? z1 : z1 / 2));
      var vp7 = Offset((end.dx - (z2 - (z1 / 2))),
          end.dy - (z2 - (bottomEdge ? 0 : z1 / 2)));
      var vp8 = Offset((start.dx - (z2 - (z1 / 2))),
          start.dy + (z2 - (topEdg ? 0 : z1 / 2)));

      path.moveTo(vp1.dx, vp1.dy);
      path.lineTo(vp2.dx, vp2.dy);
      path.lineTo(vp3.dx, vp3.dy);
      path.lineTo(vp4.dx, vp4.dy);
      path.lineTo(vp5.dx, vp5.dy);
      path.lineTo(vp6.dx, vp6.dy);
      path.lineTo(vp7.dx, vp7.dy);
      path.lineTo(vp8.dx, vp8.dy);
      path.close();

      canvas.drawPath(path, paint2);

      canvas.drawLine(vp1, vp6, paint); // خطوط داخلی
      canvas.drawLine(vp2, vp5, paint); // خطوط داخلی
      canvas.drawLine(vp1, vp2, paint); // خط بالا

      canvas.drawLine(vp8, vp7, paint); // خطوط خارجی
      canvas.drawLine(vp3, vp4, paint); // خطوط خارجی
      canvas.drawLine(vp6, vp5, paint); // خط پایین

      canvas.drawLine(vp8, vp1, paint); // خطوط مورب
      canvas.drawLine(vp3, vp2, paint); // خطوط مورب
      canvas.drawLine(vp7, vp6, paint); // خطوط مورب
      canvas.drawLine(vp4, vp5, paint); // خطوط مورب

      final ParagraphBuilder paragraphBuilder =
          ParagraphBuilder(ParagraphStyle(fontSize: 8, height: 10))
            ..addText("");
      final Paragraph paragraph = paragraphBuilder.build()
        ..layout(ParagraphConstraints(width: 12));

      canvas.drawParagraph(paragraph, end);
    } else {
      var leftEdg = true;
      var rightEdge = true;

      if (start.dx == 0)
        leftEdg = true;
      else
        leftEdg = false;

      if (end.dx == size.width)
        rightEdge = true;
      else
        rightEdge = false;

      var hp1 = Offset(
          start.dx + z2 - (leftEdg ? 0 : z1 / 2), (start.dy - (z2 - (z1 / 2))));
      var hp2 = Offset(
          end.dx - (z2) + (rightEdge ? 0 : z1 / 2), (end.dy - (z2 - (z1 / 2))));
      var hp3 = Offset(end.dx - (rightEdge ? z1 : z1 / 2), (end.dy - z1 / 2));
      var hp4 = Offset(end.dx - (rightEdge ? z1 : z1 / 2), (end.dy + z1 / 2));
      var hp5 = Offset(
          end.dx - (z2) + (rightEdge ? 0 : z1 / 2), (end.dy + (z2 - (z1 / 2))));
      var hp6 = Offset(
          start.dx + z2 - (leftEdg ? 0 : z1 / 2), (start.dy + (z2 - (z1 / 2))));
      var hp7 = Offset(start.dx + (leftEdg ? z1 : z1 / 2), (start.dy + z1 / 2));
      var hp8 = Offset(start.dx + (leftEdg ? z1 : z1 / 2), (start.dy - z1 / 2));

      path.moveTo(hp1.dx, hp1.dy);
      path.lineTo(hp2.dx, hp2.dy);
      path.lineTo(hp3.dx, hp3.dy);
      path.lineTo(hp4.dx, hp4.dy);
      path.lineTo(hp5.dx, hp5.dy);
      path.lineTo(hp6.dx, hp6.dy);
      path.lineTo(hp7.dx, hp7.dy);
      path.lineTo(hp8.dx, hp8.dy);
      path.close();

      paint2.color = Colors.white;
      canvas.drawPath(path, paint2);

      canvas.drawLine(hp8, hp3, paint);
      canvas.drawLine(hp7, hp4, paint);
      canvas.drawLine(hp7, hp8, paint);

      canvas.drawLine(hp1, hp2, paint);
      canvas.drawLine(hp6, hp5, paint);
      canvas.drawLine(hp3, hp4, paint);

      canvas.drawLine(hp8, hp1, paint);
      canvas.drawLine(hp2, hp3, paint);
      canvas.drawLine(hp5, hp4, paint);
      canvas.drawLine(hp6, hp7, paint);
    }
  }
}

class Edge {
  double top;
  double bottom;
  double left;
  double right;

  Edge(
      {required this.top,
      required this.bottom,
      required this.left,
      required this.right});
}

class Line {
  Offset? start;
  Offset? end;

  Line({required this.start, required this.end});
}
