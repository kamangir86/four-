import 'package:flutter/material.dart';
import 'package:fourplus/sade.dart';
import 'package:multi_split_view/multi_split_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var size = Size(300, 201);


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: ListView(
          children: [
            Container(
              height: 60,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Draggable<Profile>(
                      data: Profile(name: "1", isVertical: true ),
                      feedback: Image.asset('assets/1.png', height: 30,),
                      child: Image.asset('assets/1.png', height: 30, width: 30,),),
                  const SizedBox(
                    width: 20,
                  ),
                  Draggable<Profile>(
                    data: Profile(name: "1", isVertical: false ),
                    feedback: RotatedBox(
                        quarterTurns: 1,child: Image.asset('assets/1.png', height: 30,)),
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Image.asset('assets/1.png', height: 30, width: 30,)),),
                ],
              ),
            ),
            const SizedBox(height: 200,),
            TargetWidget(type: 1, size: size,),

          ],
        ),
      ),
    );
  }
}


class TargetWidget extends StatefulWidget {
  const TargetWidget({required this.type, required this.size, super.key});

  final Size size;
  final int type;

  @override
  State<TargetWidget> createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {

  // List<MyDragTargetDetails<Profile>> myList = [];

  @override
  Widget build(BuildContext context) {
    // var myList = [
    //   Profile(name: "1", dx: 0, dy: 0, isVertical: true,),
    //   Profile(name: "1", dx: widget.size.width /2, dy: 50, isVertical: false,),
    // ];

    return Sade(width: widget.size.width, height: widget.size.height);
  }
}

class HorizontalSize extends StatelessWidget {
  const HorizontalSize({required this.width, this.splits, super.key});
  final double width;
  final List<double>? splits;

  @override
  Widget build(BuildContext context) {

    var sum = 0.0;
    if(splits != null)
    splits!.forEach((element) {
      sum+=element;
    });

    return SizedBox(height: 60, width: width, child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(splits != null) Expanded(
          child: Row(
            children: List.generate(splits!.length, (index) {

              return Expanded(flex: ((splits![index]/sum) * 100).toInt(), child: SingleSize(width: splits![index]));
            }),
          ),
        ),
        const SizedBox(height: 4,),
        SingleSize(width: width)
      ],
    ),);
  }
}
class VerticalSize extends StatelessWidget {
  const VerticalSize({required this.height, this.splits, super.key});
  final double height;
  final List<double>? splits;

  @override
  Widget build(BuildContext context) {
    var sum = 0.0;
    if(splits != null)
      splits!.forEach((element) {
        sum+=element;
      });
    return SizedBox(width: 60, height: height, child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleSize(height: height),
        const SizedBox(width: 4,),
        if(splits != null) Expanded(
          child: Column(
            children: List.generate(splits!.length, (index) {
              return Expanded(flex: ((splits![index]/sum) * 100).toInt(), child: SingleSize(height: splits![index]));
            }),
          ),
        ),
      ],
    ),);
  }
}

class SingleSize extends StatelessWidget {
  const SingleSize({this.width, this.height, super.key});
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    var size = 0.0;

    switch (width) {
      case _?:
        size = width!;
      default:
       size = height!;
    }

    return RotatedBox(
      quarterTurns: width != null ? 0 : 3,
      child: Row(
        children: [
          Container(color: Colors.black, height: 22, width: 1,),
          Expanded(child: Container(color: Colors.black, height: 1,)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(size.toInt().toString()),
          ),
          Expanded(child: Container(color: Colors.black, height: 1,)),
          Container(color: Colors.black, height: 22, width: 1,),
        ],
      ),
    );
  }
}


class MyDragTaget<T extends Object> extends StatelessWidget {
  const MyDragTaget({required this.size, this.onAcceptWithDetails, super.key});

  final void Function(MyDragTargetDetails<T> details)? onAcceptWithDetails;
  final Size size;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;

    return DragTarget<Profile>(
        onAcceptWithDetails: (data) {
          RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero);

          onAcceptWithDetails?.call(MyDragTargetDetails<T>(data: data.data as T, offset: Offset(data.offset.dx - (position.dx), data.offset.dy - (position.dy)), fixed: false));
        },
        builder: (c, _, __) {
          return Container(width: size.width, height: size.height, color: Colors.transparent,);
        });
  }
}

class MyDragTargetDetails<T> {
  /// Creates details for a [DragTarget] callback.
  MyDragTargetDetails({required this.data, required this.offset, required this.fixed, this.edge, this.start, this.end});

  /// The data that was dropped onto this [DragTarget].
  final T data;

  /// The global position when the specific pointer event occurred on
  /// the draggable.
  Offset offset;

  Offset? start;
  Offset? end;

  Edge? edge;

  bool fixed;
}

class Profile{
  String name;
  bool isVertical;

    Profile({required this.name, required this.isVertical});
}

