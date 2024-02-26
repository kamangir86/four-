import 'package:flutter/material.dart';
import 'package:fourplus/main.dart';

class Sade extends StatefulWidget {
  const Sade(
      {required this.height,
      required this.width,
      required this.data,
      super.key});

  final double height;
  final double width;
  final List<MyDragTargetDetails<Profile>> data;

  @override
  State<Sade> createState() => _SadeState();
}

class _SadeState extends State<Sade> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(data: widget.data),
      size: Size(widget.width, widget.height),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.data});

  double ratio = 1;
  int sizeScale = 8;
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

    z1 = ratio * sizeScale;
    z2 = z1 + (z1 / 3);

    var paint = Paint();
    paint.strokeWidth = 1;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    drawAroud(canvas, size, paint);

    for (var i = 0; i < data.length; i++) {

        var offsets = <Offset>[Offset(size.width, size.height)];
        offsets.addAll(data.map((e) => e.offset).toList());
        offsets.removeLast();
        var edge;
        if(!data[i].fixed) {
          edge = findEdges(offsets, data[i].offset);
        } else {
          edge = data[i].edge!;
        }

        if (data[i].data.isVertical) {
          drawSplitter(canvas, paint, data[i].data.isVertical, size, start: Offset(edge.left + (edge.right - edge.left) / 2, edge.top ), end: Offset(edge.left + (edge.right - edge.left) / 2, edge.bottom));
          // if(data[i].offset.dy < (size.height - edge.right!)) {
          //   drawSplitter(canvas, paint, data[i].data.isVertical, size, start: Offset(size.width - edge.right!, 0 ), end: Offset(size.width - edge.right!, size.height - edge.right!));
          // } else {
          //   drawSplitter(canvas, paint, data[i].data.isVertical, size, start: Offset(size.width - edge.right!,  size.height - edge.right! ), end: Offset(size.width - edge.right!, size.height));
          // }
          if(!data[i].fixed) {
          data[i].offset = Offset(edge.left + (edge.right - edge.left) / 2, edge.bottom);
          data[i].edge = edge;
          data[i].fixed = true;
        }
      }else {
          drawSplitter(canvas, paint, data[i].data.isVertical, size, start: Offset(edge.left, edge.top + edge.bottom / 2), end: Offset(edge.right, edge.top + edge.bottom / 2));

          // if(data[i].offset.dx < (size.width - edge.right!)) {
          //   drawSplitter(canvas, paint, data[i].data.isVertical, size, start: Offset(0 ,size.height - edge.right!,), end: Offset(size.width - edge.right!, size.height - edge.right!));
          // } else {
          //   drawSplitter(canvas, paint, data[i].data.isVertical, size, start: Offset(size.width - edge.right! , size.height - edge.right!), end: Offset(size.width , size.height - edge.right!));
          // }
          data[i].offset = Offset(edge.right, edge.top + (edge.bottom - edge.top) / 2);
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
  }

  void drawSplitter(Canvas canvas, Paint paint, bool isVertical, Size size, {required Offset start, required Offset end}) {

    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black;

    var path = Path();
    var paint2 = Paint();
    paint2.style = PaintingStyle.stroke;
    paint2.color = Colors.red;
    paint2.style = PaintingStyle.fill;


    if(isVertical) {
      var topEdg = true;
      var bottomEdge = true;

      if(start.dy == 0)
        topEdg = true;
      else topEdg = false;

      if(end.dy == size.height)
        bottomEdge = true;
      else bottomEdge = false;


    var vp1 = Offset((start.dx - z1 / 2), start.dy + (topEdg ? z1 : z1/2));
    var vp2 = Offset((start.dx + z1 / 2), start.dy + (topEdg ? z1 : z1/2));
    var vp3 = Offset((start.dx + (z2 - (z1 / 2))), start.dy + (z2 - (topEdg ? 0 : z1/2)));
    var vp4 = Offset((end.dx + (z2 - (z1 / 2))), end.dy - (z2 - (bottomEdge ? 0 : z1/2)));
    var vp5 = Offset((end.dx + z1 / 2), end.dy - (bottomEdge ? z1 : z1/2));
    var vp6 = Offset((end.dx - z1 / 2), end.dy - (bottomEdge ? z1 : z1/2));
    var vp7 = Offset((end.dx - (z2 - (z1 / 2))), end.dy - (z2 - (bottomEdge ? 0 : z1/2)));
    var vp8 = Offset((start.dx - (z2 - (z1 / 2))), start.dy +(z2 - (topEdg ? 0 : z1/2)));


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

      canvas.drawLine(vp8, vp7, paint);  // خطوط خارجی
      canvas.drawLine(vp3, vp4, paint);  // خطوط خارجی
      canvas.drawLine(vp6, vp5, paint);  // خط پایین

      canvas.drawLine(vp8, vp1, paint);  // خطوط مورب
      canvas.drawLine(vp3, vp2, paint);  // خطوط مورب
      canvas.drawLine(vp7, vp6, paint);  // خطوط مورب
      canvas.drawLine(vp4, vp5, paint);  // خطوط مورب

    } else{

      var leftEdg = true;
      var rightEdge = true;

      if(start.dx == 0)
        leftEdg = true;
      else leftEdg = false;

      if(end.dx == size.width)
        rightEdge = true;
      else rightEdge = false;


      var hp1 = Offset(start.dx + z2 - (leftEdg ? 0 : z1/2), (start.dy - (z2 - (z1 / 2))));
      var hp2 = Offset(end.dx - (z2) + (rightEdge ? 0 : z1/2), (end.dy - (z2 - (z1 / 2))));
      var hp3 = Offset(end.dx - (rightEdge ? z1 : z1 / 2), (end.dy - z1 / 2));
      var hp4 = Offset(end.dx - (rightEdge ? z1 : z1 / 2), (end.dy + z1 / 2));
      var hp5 = Offset(end.dx - (z2) + (rightEdge ? 0 : z1/2), (end.dy + (z2 - (z1 / 2))));
      var hp6 = Offset(start.dx + z2 - (leftEdg ? 0 : z1/2), (start.dy + (z2 - (z1 / 2))));
      var hp7 = Offset(start.dx+(leftEdg ? z1: z1/2), (start.dy + z1 / 2));
      var hp8 = Offset(start.dx+(leftEdg ? z1 : z1/2), (start.dy - z1 / 2));


      path.moveTo(hp1.dx, hp1.dy);
      path.lineTo(hp2.dx, hp2.dy);
      path.lineTo(hp3.dx, hp3.dy);
      path.lineTo(hp4.dx, hp4.dy);
      path.lineTo(hp5.dx, hp5.dy);
      path.lineTo(hp6.dx, hp6.dy);
      path.lineTo(hp7.dx, hp7.dy);
      path.lineTo(hp8.dx, hp8.dy);
      path.close();

      paint2.color = Colors.green;
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

  Edges findEdges(List<Offset> offsets, Offset targetOffset) {
    double minDistanceTop = double.infinity;
    double minDistanceBottom = double.infinity;
    double minDistanceLeft = double.infinity;
    double minDistanceRight = double.infinity;
    double? topEdgeX;
    double? topEdgeY;
    double? bottomEdgeX;
    double? bottomEdgeY;
    double? leftEdgeX;
    double? leftEdgeY;
    double? rightEdgeX;
    double? rightEdgeY;

    for (Offset offset in offsets) {
      double distanceX = offset.dx - targetOffset.dx;
      double distanceY = offset.dy - targetOffset.dy;

      if (distanceY > 0 && distanceY <= minDistanceTop) {
        minDistanceTop = distanceY;
        topEdgeX = offset.dx;
        topEdgeY = offset.dy;
      } else if (distanceY < 0 && -distanceY <= minDistanceBottom) {
        minDistanceBottom = -distanceY;
        bottomEdgeX = offset.dx;
        bottomEdgeY = offset.dy;
      }

      if (distanceX > 0 && distanceX <= minDistanceRight) {
        minDistanceRight = distanceX;
        rightEdgeX = offset.dx;
        rightEdgeY = offset.dy;
      } else if (distanceX < 0 && -distanceX <= minDistanceLeft) {
        minDistanceLeft = -distanceX;
        leftEdgeX = offset.dx;
        leftEdgeY = offset.dy;
      }
    }

    return Edges(
      top: bottomEdgeY ?? 0,
      bottom: topEdgeY ?? 0,
      left: leftEdgeX ?? 0,
      right: rightEdgeX ?? 0,
    );
  }
}

class Edges {
  double top;
  double bottom;
  double left;
  double right;

  Edges({required this.top, required this.bottom, required this.left, required this.right});
}
