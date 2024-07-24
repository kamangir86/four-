import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourplus/main.dart';
import 'package:fourplus/profile_drawing_widget.dart';

GlobalKey keyPrev = GlobalKey();

class ProfilePreviewWidget extends StatefulWidget {
  ProfilePreviewWidget(
      {required this.sizeOfPanel, this.initialProfileList, this.width, this.height, super.key});

    final Size sizeOfPanel;
    final double? width;
    final double? height;
  List<MyDragTargetDetails<Profile>>? initialProfileList;

  @override
  State<ProfilePreviewWidget> createState() => _ProfilePreviewWidgetState();
}

class _ProfilePreviewWidgetState extends State<ProfilePreviewWidget> {
  List<MyDragTargetDetails<Profile>> data = [];

  var sizeOfSizeWidget = 300.0;

  int? indexOfSameEdge;


  @override
  Widget build(BuildContext context) {
    var availableWidth = widget.width ?? 114.0;
    var availableHeight = widget.height ?? 114.0;

    data = widget.initialProfileList ?? [];

    return Container(
      color: Colors.transparent,
      height: availableHeight,
      width: availableWidth,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Stack(
          children: [
            CustomPaint(
              key: keyPrev,
              painter: MyPainter(data: data),
              size: Size(widget.sizeOfPanel.width, widget.sizeOfPanel.height),
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

    setState(() {});
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
