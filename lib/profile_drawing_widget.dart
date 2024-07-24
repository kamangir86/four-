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

class ProfileDrawingWidget extends StatelessWidget {
    ProfileDrawingWidget(
      {required this.size, this.initialProfileList, required this.onAddNewProfile, super.key});

    final Size size;
  List<MyDragTargetDetails<Profile>>? initialProfileList;
    final Function(List<MyDragTargetDetails<Profile>> newList) onAddNewProfile;


  List<MyDragTargetDetails<Profile>> data = [];

  var sizeOfSizeWidget = 300.0;

  int? indexOfSameEdge;

  @override
  Widget build(BuildContext context) {
    var availableWidth = MediaQuery.sizeOf(context).width;
    var availableHeight = MediaQuery.sizeOf(context).height / 2 - 244;

    data = initialProfileList ?? [];
    List<MyDragTargetDetails<Profile>> dataCopy = List.from(data);


      dataCopy.insertAll(0, [
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: false),
        offset: Offset(size.width / 2, 0),
        fixed: true,
        changedOffset: false,
        start: const Offset(0, 0),
        end: Offset(size.width, 0),
      ),
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: false),
        offset: Offset(size.width / 2, size.height),
        fixed: true,
        changedOffset: false,
        start: Offset(0, size.height),
        end: Offset(size.width, size.height),
      ),
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: true),
        offset: Offset(size.width / 2, 0),
        fixed: true,
        changedOffset: false,
        start: const Offset(0, 0),
        end: Offset(0, size.height),
      ),
      MyDragTargetDetails<Profile>(
        data: Profile(name: ProfileName.edge, isVertical: true),
        offset: Offset(size.width / 2, 0),
        fixed: true,
        changedOffset: false,
        start: Offset(size.width, 0),
        end: Offset(size.width, size.height),
      ),
    ]);


    for (var i = 0; i < data.length; i++) {
      Edge edge;
      if (!data[i].fixed || data[i].changedOffset) {
        edge = findDrawableEdges(dataCopy, data[i], i);
      } else {
        edge = data[i].edge ?? Edge(top: 0, bottom: 0, right: 0, left: 0);
      }

      if (data[i].data.name == ProfileName.vertical) {
        var point = (edge.left + (edge.right - edge.left) / 2).ceil();
        if (!data[i].fixed && !data[i].changedOffset) {
          data[i].offset = Offset(point.toDouble(), edge.top + (edge.bottom - edge.top) / 2);
          data[i].fixed = true;
          data[i].start = Offset(point.toDouble(), edge.top);
          data[i].end = Offset(point.toDouble(), edge.bottom);
          data[i].edge = edge;
          data[i].parentIndex = findIndexOfMyParent(edge);
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else if (data[i].data.name == ProfileName.horizontal) {
        var point = (edge.top + (edge.bottom - edge.top) / 2).ceil();
        if (!data[i].fixed && !data[i].changedOffset) {
          data[i].offset = Offset(
              edge.left + (edge.right - edge.left) / 2, point.toDouble());
          data[i].fixed = true;
          data[i].start = Offset(edge.left, point.toDouble());
          data[i].end = Offset(edge.right, point.toDouble());
          data[i].edge = edge;
          data[i].parentIndex = findIndexOfMyParent(edge);
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      }
      if (data[i].data.name == ProfileName.double) {

        var point = (edge.left + ((edge.right - edge.left) / 3).round());
        var point2 = edge.right -  ((edge.right - edge.left) / 3).round();
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].start = Offset(point.toDouble(), edge.top);
          data[i].end = Offset(point.toDouble(), edge.bottom);
          data[i].offset = Offset(data[i].start!.dx, (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].start2 = Offset(point2.toDouble(), edge.top);
          data[i].end2 = Offset(point2.toDouble(), edge.bottom);
          data[i].offset2 = Offset(data[i].start2!.dx, (data[i].end2!.dy - data[i].start2!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          data[i].parentIndex = findIndexOfMyParent(edge);
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }

      } else
      if (data[i].data.name == ProfileName.fillH) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + ((data[i].end!.dy - data[i].start!.dy) / 2));
          data[i].fixed = true;
          data[i].edge = edge;
          data[i].parentIndex = findIndexOfMyParent(edge);
        }
      } else
      if (data[i].data.name == ProfileName.fillV) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + ((data[i].end!.dy - data[i].start!.dy) / 2));
          data[i].fixed = true;
          data[i].edge = edge;
          data[i].parentIndex = findIndexOfMyParent(edge);
        }
      } else
      if (data[i].data.name == ProfileName.left) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else
      if (data[i].data.name == ProfileName.right) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else
      if (data[i].data.name == ProfileName.top) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else
      if (data[i].data.name == ProfileName.topRight) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else
      if (data[i].data.name == ProfileName.topLeft) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else
      if (data[i].data.name == ProfileName.dLeft) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      } else
      if (data[i].data.name == ProfileName.dRight) {
        if (!data[i].fixed && !data[i].changedOffset){
          data[i].parentIndex = findIndexOfMyParent(edge);
          if(data[i].parentIndex != null){
            edge = data[data[i].parentIndex!].edge!;
          }
          data[i].start = Offset(edge.left, edge.top);
          data[i].end = Offset(edge.right, edge.bottom);
          data[i].offset = Offset(data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2), data[i].start!.dy + (data[i].end!.dy - data[i].start!.dy) / 2);
          data[i].fixed = true;
          data[i].edge = edge;
          indexOfSameEdge = findIndexOfSameEdge(edge);
        }
      }
    }

    removeSameEdgeProfileIfNeeded();
    computeSizeOfSheets(data, Size(size.width, size.height));

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
                  print(value);
                  return VerticalSize(
                    height: size.height,
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
                      painter: MyPainter(data: data),
                      size: Size(size.width, size.height),
                    ),
                    MyDragTaget<Profile>(
                      size: Size(size.width, size.height),
                      onAcceptWithDetails: (d) {
                        data.add(d);
                        onAddNewProfile(data);
                        // setState(() {});
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
                      print(value);

                      return HorizontalSize(
                        width: size.width,
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
    // lines.removeRange(index + 4, lines.length);
    lines.removeLast();
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

      if(line.offset2 != null){

        double startX = line.start2!.dx;
        double startY = line.start2!.dy;
        double endX = line.end2!.dx;
        double endY = line.end2!.dy;

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
      if(element.data.name == ProfileName.horizontal || element.data.name == ProfileName.vertical || element.data.name == ProfileName.double){
        if (element.data.isVertical) {
          vElement.add(element);
        } else {
          hElement.add(element);
        }
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
        if(element.offset2 != null) {
          hSheetsSize.add(element.start2!.dx);
        }
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
        if (!data[i].data.isVertical && data[i].data.splitter) {
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
        if (data[i].data.isVertical || !data[i].data.splitter) {
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

      for (int i = 0; i < data.length; i++) {
        if (data[i].data.isVertical && data[i].data.splitter) {
          if (data[i].start!.dx == sum ) {
            data[i].start =
                Offset(remainingValue.toDouble(), data[i].start!.dy);
            data[i].end = Offset(remainingValue.toDouble(), data[i].end!.dy);

            data[i].offset = Offset(
                data[i].start!.dx + ((data[i].end!.dx - data[i].start!.dx) / 2),
                data[i].offset.dy);
            data[i].changedOffset = true;
          }

          if (data[i].offset2 != null && data[i].start2!.dx == sum && data[i].data.splitter) {
            data[i].start2 =
                Offset(remainingValue.toDouble(), data[i].start2!.dy);
            data[i].end2 = Offset(remainingValue.toDouble(), data[i].end2!.dy);

            data[i].offset2 = Offset(
                data[i].start2!.dx + ((data[i].end2!.dx - data[i].start2!.dx) / 2),
                data[i].offset2!.dy);
            data[i].changedOffset = true;
          }
        }
        if (!data[i].data.isVertical || !data[i].data.splitter) {
          if (data[i].start!.dx == sum) {

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
  }

  int? findIndexOfMyParent(Edge edge) {
    int? index;
    for (var i = 0; i < data.length - 1; i++) {
      if(data[i].data.hasChild && data[i].edge!.right >= edge.right && data[i].edge!.left <= edge.left && data[i].edge!.top <= edge.top && data[i].edge!.bottom >= edge.bottom) {
        index = i;
      }
    }
    return index;
  }

  int? findIndexOfSameEdge(Edge edge) {
    int? index;
    for (var i = 0; i < data.length - 1; i++) {
      if((data[i].data.hasChild || data[i].data.fillEleman) && data[i].edge!.right >= edge.right && data[i].edge!.left <= edge.left && data[i].edge!.top <= edge.top && data[i].edge!.bottom >= edge.bottom) {
        index = i;
      }
    }
    return index;
  }

  void removeSameEdgeProfileIfNeeded() {

    if(indexOfSameEdge != null && ((data.last.data.name == ProfileName.horizontal ||data.last.data.name == ProfileName.vertical ||data.last.data.name == ProfileName.double) && data[indexOfSameEdge!].data.fillEleman)){
      data.last.parentIndex = data[indexOfSameEdge!].parentIndex;

      data.removeWhere((e)=> e.parentIndex == indexOfSameEdge);
      data.removeAt(indexOfSameEdge!);

      indexOfSameEdge = null;
    }

    if(indexOfSameEdge != null && ((data.last.data.name != ProfileName.horizontal && data.last.data.name != ProfileName.vertical && data.last.data.name != ProfileName.double) && !data.last.data.fillEleman)){
      data.last.parentIndex = null;

      data.removeWhere((e)=> e.parentIndex == indexOfSameEdge);
      data.removeAt(indexOfSameEdge!);

      indexOfSameEdge = null;
    }
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.data});

  double ratio = 1;
  int sizeScale = 65;
  List<MyDragTargetDetails<Profile>> data;
  var z1 = 0.0;
  var z2 = 0.0;
  var gap = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width > size.height) {
      ratio = size.width / size.height;
    } else {
      ratio = size.height / size.width;
    }

    z1 = sizeScale.toDouble();
    z2 = z1 + (z1 / 3);
    gap = z2/2;

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    drawAroud(canvas, size, paint);

    for (var i = 0; i < data.length; i++) {

      if (data[i].data.name == ProfileName.vertical || data[i].data.name == ProfileName.horizontal) {
        drawSplitter(canvas, paint, data[i].data.isVertical, size,
            start: data[i].start!,
            end: data[i].end!, parentEdge: data[i].parentIndex != null ? data[data[i].parentIndex!].edge! : null);
      } else
      if (data[i].data.name == ProfileName.double) {
          drawSplitter(canvas, paint, data[i].data.isVertical, size,
              start: data[i].start!, end: data[i].end!, parentEdge: data[i].parentIndex != null ? data[data[i].parentIndex!].edge! : null);

        drawSplitter(canvas, paint, data[i].data.isVertical, size,
            start: data[i].start2!, end: data[i].end2!, parentEdge: data[i].parentIndex != null ? data[data[i].parentIndex!].edge! : null);
      } else
      if (data[i].data.name == ProfileName.fillH) {
        drawFill(canvas, size,  data[i].data.isVertical, start: data[i].start!, end: data[i].end!, parentEdge: data[i].parentIndex != null ? data[data[i].parentIndex!].edge! : null);
      } else
      if (data[i].data.name == ProfileName.fillV) {
        drawFill(canvas, size,  data[i].data.isVertical, start: data[i].start!, end: data[i].end!, parentEdge: data[i].parentIndex != null ? data[data[i].parentIndex!].edge! : null);
      } else
      if (data[i].data.name == ProfileName.left) {
        drawOpenTo(canvas, size, data[i].data.isVertical, left: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.right) {
        drawOpenTo(canvas, size, data[i].data.isVertical, right: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.top) {
        drawOpenTo(canvas, size, data[i].data.isVertical, top: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.topRight) {
        drawOpenTo(canvas, size, data[i].data.isVertical, top: true, right: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.topLeft) {
        drawOpenTo(canvas, size, data[i].data.isVertical, top: true, left: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.dLeft) {
        drawOpenTo(canvas, size, data[i].data.isVertical, isDoor: true, left: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.dRight) {
        drawOpenTo(canvas, size, data[i].data.isVertical, isDoor: true, right: true, start: data[i].start!, end: data[i].end!);
      }
    }

    for (var i = 0; i < data.length; i++){
      if (data[i].data.name == ProfileName.left) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, left: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.right) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, right: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.top) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, top: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.topRight) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, top: true, right: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.topLeft) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, top: true, left: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.dLeft) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, isDoor: true, left: true, start: data[i].start!, end: data[i].end!);
      } else
      if (data[i].data.name == ProfileName.dRight) {
        drawHandleAndLolas(canvas, size, data[i].data.isVertical, isDoor: true, right: true, start: data[i].start!, end: data[i].end!);
      }
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
    paint2.color = Colors.blue[200]!;
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
      {required Offset start, required Offset end, Edge? parentEdge}) {
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black;

    var path = Path();
    var paint2 = Paint();
    paint2.style = PaintingStyle.stroke;
    paint2.color = Colors.white;
    paint2.style = PaintingStyle.fill;

    if (isVertical) {
      var topMainEdg = true;
      var bottomMainEdge = true;
      var topParentEdge = false;
      var bottomParentEdge = false;

      if (start.dy == 0) {
        topMainEdg = true;
      } else {
        topMainEdg = false;
      }

      if (end.dy == size.height) {
        bottomMainEdge = true;
      } else {
        bottomMainEdge = false;
      }

      if(parentEdge != null){
        if(parentEdge.top == start.dy){
          topParentEdge = true;
        }
        if(parentEdge.bottom == end.dy){
          bottomParentEdge = true;
        }
      }


      var vp1 = Offset((start.dx - z1 / 2), start.dy + (topMainEdg ? z1 : z1 / 2) + (topParentEdge ? gap : 0));
      var vp2 = Offset((start.dx + z1 / 2), start.dy + (topMainEdg ? z1 : z1 / 2) + (topParentEdge ? gap : 0));
      var vp3 = Offset((start.dx + (z2 - (z1 / 2))),
          start.dy + (z2 - (topMainEdg ? 0 : z1 / 2)) + (topParentEdge ? gap : 0));
      var vp4 = Offset((end.dx + (z2 - (z1 / 2))),
          end.dy - (z2 - (bottomMainEdge ? 0 : z1 / 2)) - (bottomParentEdge ? gap : 0));
      var vp5 = Offset((end.dx + z1 / 2), end.dy - (bottomMainEdge ? z1 : z1 / 2) - (bottomParentEdge ? gap : 0));
      var vp6 = Offset((end.dx - z1 / 2), end.dy - (bottomMainEdge ? z1 : z1 / 2) - (bottomParentEdge ? gap : 0));
      var vp7 = Offset((end.dx - (z2 - (z1 / 2))),
          end.dy - (z2 - (bottomMainEdge ? 0 : z1 / 2)) - (bottomParentEdge ? gap : 0));
      var vp8 = Offset((start.dx - (z2 - (z1 / 2))),
          start.dy + (z2 - (topMainEdg ? 0 : z1 / 2)) + (topParentEdge ? gap : 0));

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
      var leftMainEdg = true;
      var rightMainEdge = true;
      var leftParentEdge = false;
      var rightParentEdge = false;

      if (start.dx == 0) {
        leftMainEdg = true;
      } else {
        leftMainEdg = false;
      }

      if (end.dx == size.width) {
        rightMainEdge = true;
      } else {
        rightMainEdge = false;
      }

      if(parentEdge != null){
        if(parentEdge.left == start.dx){
          leftParentEdge = true;
        }
        if(parentEdge.right == end.dx){
          rightParentEdge = true;
        }
      }

      var hp1 = Offset(
          start.dx + z2 - (leftMainEdg ? 0 : z1 / 2) + (leftParentEdge ? gap : 0), (start.dy - (z2 - (z1 / 2))));
      var hp2 = Offset(
          end.dx - (z2) + (rightMainEdge ? 0 : z1 / 2) - (rightParentEdge ? gap : 0), (end.dy - (z2 - (z1 / 2))));
      var hp3 = Offset(end.dx - (rightMainEdge ? z1 : z1 / 2) - (rightParentEdge ? gap : 0), (end.dy - z1 / 2));
      var hp4 = Offset(end.dx - (rightMainEdge ? z1 : z1 / 2) - (rightParentEdge ? gap : 0), (end.dy + z1 / 2));
      var hp5 = Offset(
          end.dx - (z2) + (rightMainEdge ? 0 : z1 / 2) - (rightParentEdge ? gap : 0), (end.dy + (z2 - (z1 / 2))));
      var hp6 = Offset(
          start.dx + z2 - (leftMainEdg ? 0 : z1 / 2) + (leftParentEdge ? gap : 0), (start.dy + (z2 - (z1 / 2))));
      var hp7 = Offset(start.dx + (leftMainEdg ? z1 : z1 / 2) + (leftParentEdge ? gap : 0), (start.dy + z1 / 2));
      var hp8 = Offset(start.dx + (leftMainEdg ? z1 : z1 / 2) + (leftParentEdge ? gap : 0), (start.dy - z1 / 2));

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

  void drawFill(Canvas canvas, Size size, bool isVertical,
      {required Offset start, required Offset end, Edge? parentEdge}) {

    var fillSheetWidth = 70;

    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var topEdg = true;
    var bottomEdge = true;
    var leftEdg = true;
    var rightEdge = true;

    var topParentEdge = false;
    var bottomParentEdge = false;
    var leftParentEdge = false;
    var rightParentEdge = false;

    if (start.dy == 0) {
      topEdg = true;
    } else {
      topEdg = false;
    }

    if (end.dy == size.height) {
      bottomEdge = true;
    } else {
      bottomEdge = false;
    }

    if (start.dx == 0) {
      leftEdg = true;
    } else {
      leftEdg = false;
    }

    if (end.dx == size.width) {
      rightEdge = true;
    } else {
      rightEdge = false;
    }

    if(parentEdge != null){
      if(parentEdge.left == start.dx){
        leftParentEdge = true;
      }
      if(parentEdge.right == end.dx){
        rightParentEdge = true;
      }
    }

    if(parentEdge != null){
      if(parentEdge.top == start.dy){
        topParentEdge = true;
      }
      if(parentEdge.bottom == end.dy){
        bottomParentEdge = true;
      }
    }

    var tlx = start.dx + (leftEdg ? z2 : (z2 - z1/2)) + (leftParentEdge ? gap : 0);
    var tly = start.dy + (topEdg ? z2 : (z2 - z1/2)) + (topParentEdge ? gap : 0);
    var brx = end.dx -  (rightEdge ? z2 : (z2 - z1/2)) - (rightParentEdge ? gap : 0);
    var bry = end.dy - (bottomEdge ? z2 : (z2 - z1/2)) - (bottomParentEdge ? gap : 0);

    var width = brx - tlx;
    var height = bry - tly;

    var startP = Offset(tlx, tly);
    var endP = Offset(brx, bry);

    canvas.drawRect(Rect.fromLTWH(tlx, tly, width, height), paint);

    paint.color = Colors.black;
    paint.strokeWidth = 2;

    if(isVertical){
      var i = 0;
      while ((i * fillSheetWidth) < width - fillSheetWidth){
        i++;
        canvas.drawLine(Offset(startP.dx + (i * fillSheetWidth), startP.dy) , Offset(startP.dx + (i * fillSheetWidth), endP.dy), paint);
      }
    } else {
      var i = 0;
      while ((i * fillSheetWidth) < height - fillSheetWidth){
        i++;
        canvas.drawLine(Offset(startP.dx, startP.dy + (i * fillSheetWidth)) , Offset(endP.dx, startP.dy + (i * fillSheetWidth)), paint);
      }
    }
  }
  void drawOpenTo(Canvas canvas, Size size, bool isVertical, {bool left = false, bool right = false, bool top = false, bool isDoor = false,
      required Offset start, required Offset end}) {

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    var topEdg = true;
    var bottomEdge = true;
    var leftEdg = true;
    var rightEdge = true;


    if (start.dy == 0) {
      topEdg = true;
    } else {
      topEdg = false;
    }

    if (end.dy == size.height) {
      bottomEdge = true;
    } else {
      bottomEdge = false;
    }

    if (start.dx == 0) {
      leftEdg = true;
    } else {
      leftEdg = false;
    }

    if (end.dx == size.width) {
      rightEdge = true;
    } else {
      rightEdge = false;
    }

    var tlx = start.dx + (leftEdg ? z2 : (z2 - z1/2)) - z2/2;
    var tly = start.dy + (topEdg ? z2 : (z2 - z1/2)) - z2/2;
    var brx = end.dx - (rightEdge ? z2 : (z2 - z1/2)) + z2/2;
    var bry = end.dy - (bottomEdge ? z2 : (z2 - z1/2)) + z2/2;

    var width = brx - tlx;
    var height = bry - tly;

    var startP = Offset(tlx, tly);
    var endP = Offset(brx, bry);

    drawAroundWith(canvas, Size(width, height), tlx, tly);

    // paint.color = Colors.blue[900]!;
    // paint.strokeWidth = 4;
    //
    // if(left){
    //     canvas.drawLine(Offset(startP.dx + 30, startP.dy + height / 2 + (isDoor ? (height / 8) : 0)) , Offset(endP.dx, endP.dy - height / 4), paint);
    //     canvas.drawLine(Offset(startP.dx + 30, startP.dy + height / 2 - (isDoor ? (height / 8) : 0)) , Offset(endP.dx, endP.dy -  3 * height / 4), paint);
    //     if(isDoor) {
    //       canvas.drawLine(Offset(startP.dx + 30, startP.dy + height / 2 + (height / 8)) , Offset(startP.dx + 30, startP.dy + height / 2 - (height / 8)), paint);
    //     }
    //     drawHandle(canvas, startP.dx + 30, startP.dy + height / 2, isDoor, false);
    //     drawLola(canvas, size, endP.dx, endP.dy - height / 4, endP.dy -  3 * height / 4, isDoor);
    // }
    //
    // if(right){
    //   canvas.drawLine(Offset(startP.dx, startP.dy + height / 4) , Offset(endP.dx- 30, endP.dy - height / 2 - (isDoor ? (height / 8) : 0)), paint);
    //   canvas.drawLine(Offset(startP.dx, startP.dy + 3 * height / 4) , Offset(endP.dx - 30, endP.dy - height / 2 + (isDoor ? (height / 8) : 0)), paint);
    //   if(isDoor) {
    //     canvas.drawLine(Offset(endP.dx- 30, endP.dy - height / 2 - (height / 8)) , Offset(endP.dx - 30, endP.dy - height / 2 + (height / 8)), paint);
    //   }
    //   drawHandle(canvas, endP.dx - 30, endP.dy - height / 2, isDoor, true);
    //   drawLola(canvas, size, startP.dx, startP.dy + height / 4, startP.dy + 3 * height / 4, isDoor);
    // }
    //
    // if(top){
    //   canvas.drawLine(Offset(endP.dx - width / 2, startP.dy + 30) , Offset(endP.dx - width / 4, endP.dy), paint);
    //   canvas.drawLine(Offset(endP.dx - width / 2, startP.dy + 30) , Offset(endP.dx - 3 * width / 4, endP.dy), paint);
    // }
  }

   void drawHandleAndLolas(Canvas canvas, Size size, bool isVertical, {bool left = false, bool right = false, bool top = false, bool isDoor = false,
      required Offset start, required Offset end}) {

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    var topEdg = true;
    var bottomEdge = true;
    var leftEdg = true;
    var rightEdge = true;

    if (start.dy == 0) {
      topEdg = true;
    } else {
      topEdg = false;
    }

    if (end.dy == size.height) {
      bottomEdge = true;
    } else {
      bottomEdge = false;
    }

    if (start.dx == 0) {
      leftEdg = true;
    } else {
      leftEdg = false;
    }

    if (end.dx == size.width) {
      rightEdge = true;
    } else {
      rightEdge = false;
    }

    var tlx = start.dx + (leftEdg ? z2 : (z2 - z1/2)) - z2/2;
    var tly = start.dy + (topEdg ? z2 : (z2 - z1/2)) - z2/2;
    var brx = end.dx - (rightEdge ? z2 : (z2 - z1/2)) + z2/2;
    var bry = end.dy - (bottomEdge ? z2 : (z2 - z1/2)) + z2/2;

    var width = brx - tlx;
    var height = bry - tly;

    var startP = Offset(tlx, tly);
    var endP = Offset(brx, bry);

    paint.color = Colors.blue[900]!;
    paint.strokeWidth = 4;

    if(left){
        canvas.drawLine(Offset(startP.dx + 30, startP.dy + height / 2 + (isDoor ? (height / 8) : 0)) , Offset(endP.dx, endP.dy - height / 4), paint);
        canvas.drawLine(Offset(startP.dx + 30, startP.dy + height / 2 - (isDoor ? (height / 8) : 0)) , Offset(endP.dx, endP.dy -  3 * height / 4), paint);
        if(isDoor) {
          canvas.drawLine(Offset(startP.dx + 30, startP.dy + height / 2 + (height / 8)) , Offset(startP.dx + 30, startP.dy + height / 2 - (height / 8)), paint);
        }
        drawHandle(canvas, startP.dx + 30, startP.dy + height / 2, isDoor, false);
        drawLola(canvas, size, endP.dx, endP.dy - height / 4, endP.dy -  3 * height / 4, isDoor);
    }

    if(right){
      canvas.drawLine(Offset(startP.dx, startP.dy + height / 4) , Offset(endP.dx- 30, endP.dy - height / 2 - (isDoor ? (height / 8) : 0)), paint);
      canvas.drawLine(Offset(startP.dx, startP.dy + 3 * height / 4) , Offset(endP.dx - 30, endP.dy - height / 2 + (isDoor ? (height / 8) : 0)), paint);
      if(isDoor) {
        canvas.drawLine(Offset(endP.dx- 30, endP.dy - height / 2 - (height / 8)) , Offset(endP.dx - 30, endP.dy - height / 2 + (height / 8)), paint);
      }
      drawHandle(canvas, endP.dx - 30, endP.dy - height / 2, isDoor, true);
      drawLola(canvas, size, startP.dx, startP.dy + height / 4, startP.dy + 3 * height / 4, isDoor);
    }

    if(top){
      canvas.drawLine(Offset(endP.dx - width / 2, startP.dy + 30) , Offset(endP.dx - width / 4, endP.dy), paint);
      canvas.drawLine(Offset(endP.dx - width / 2, startP.dy + 30) , Offset(endP.dx - 3 * width / 4, endP.dy), paint);
    }
  }

  void drawAroundWith(Canvas canvas, Size size, double x, double y) {

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    var paint2 = Paint();
    paint2.color = Colors.blue[200]!;
    paint2.style = PaintingStyle.fill;

    var paint3 = Paint();
    paint3.color = Colors.white;
    paint3.style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(x,y, size.width, size.height), paint3);
    canvas.drawRect(Rect.fromLTWH(x,y, size.width, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(x+z1, y+z1, size.width - (2 * z1), size.height - (2 * z1)), paint);
    canvas.drawRect(Rect.fromLTWH(x+z2, y+z2, size.width - (2 * z2), size.height - (2 * z2)), paint2);
    canvas.drawRect(Rect.fromLTWH(x+z2, y+z2, size.width - (2 * z2), size.height - (2 * z2)), paint);

    canvas.drawLine(Offset(x,y), Offset(x+z2, y+z2), paint);
    canvas.drawLine(Offset(x+size.width, y), Offset(x+size.width - z2, y+z2), paint);
    canvas.drawLine(Offset(x, y+size.height), Offset(x+z2, y+size.height - z2), paint);
    canvas.drawLine(Offset(x+size.width, y+size.height), Offset(x+size.width - z2, y+size.height - z2), paint);
    canvas.drawLine(Offset(x+size.width, y+size.height), Offset(x+size.width - z2, y+size.height - z2), paint);
  }
  void drawHandle(Canvas canvas, double x, double y, bool isDoor, bool isRight) {

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.blueGrey;
    paint.style = PaintingStyle.fill;

    if(isDoor){
      canvas.drawRect(Rect.fromLTWH(x-17,y-80, 34, 160), paint);
      if(isRight) {
        canvas.drawRect(Rect.fromLTWH(x-110, y - 15, 110, 20), paint);
      } else {
        canvas.drawRect(Rect.fromLTWH(x, y-15, 110, 20), paint);
      }
    } else {
      canvas.drawRect(Rect.fromLTWH(x-15,y-45, 30, 90), paint);
      canvas.drawRect(Rect.fromLTWH(x-8,y+45, 16, 35), paint);
    }
  }
  void drawLola(Canvas canvas, Size size, double x, double y1 , double y2, bool isDoor) {

    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = Colors.blueGrey;
    paint.style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(x-10, y1-45, 20, 40), paint);
    canvas.drawRect(Rect.fromLTWH(x-10, y1+5, 20, 40), paint);

    canvas.drawRect(Rect.fromLTWH(x-10, y2-45, 20, 40), paint);
    canvas.drawRect(Rect.fromLTWH(x-10, y2+5, 20, 40), paint);

    if(isDoor){
      canvas.drawRect(Rect.fromLTWH(x-10, ( y1 + (y2 - y1) / 2)-45, 20, 40), paint);
      canvas.drawRect(Rect.fromLTWH(x-10, (y1 + (y2 - y1) / 2)+5, 20, 40), paint);
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
      required this.right,
      });
}

class Line {
  Offset? start;
  Offset? end;

  Line({required this.start, required this.end});
}
