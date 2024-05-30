import 'package:flutter/material.dart';
import 'package:fourplus/profile_main_widget.dart';
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
  var size = Size(1500, 1200);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Column(
          children: [
            Container(
              height: 80,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              // myList.removeLast();
                              setState(() {});
                            },
                            icon: const Icon(Icons.undo)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.redo))
                      ],
                    ),
                  ),
                  Text("1"),
                ],
              ),
            ),
            Container(
              height: 60,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Draggable<Profile>(
                    data: Profile(name: "1", isVertical: true),
                    feedback: Image.asset(
                      'assets/1.png',
                      height: 30,
                    ),
                    child: Image.asset(
                      'assets/1.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Draggable<Profile>(
                    data: Profile(name: "1", isVertical: false),
                    feedback: RotatedBox(
                        quarterTurns: 1,
                        child: Image.asset(
                          'assets/1.png',
                          height: 30,
                        )),
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Image.asset(
                          'assets/1.png',
                          height: 30,
                          width: 30,
                        )),
                  ),
                ],
              ),
            ),
            TargetWidget(
              type: 1,
              size: size,
            ),
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

    return ProfileMainWidget(
        width: widget.size.width, height: widget.size.height);
  }
}

class HorizontalSize extends StatelessWidget {
  const HorizontalSize(
      {required this.width,
      required this.splits,
      required this.onChangeSize,
      super.key});

  final double width;
  final List<double>? splits;
  final Function(int, int) onChangeSize;

  @override
  Widget build(BuildContext context) {
    var sum = 0.0;
    if (splits != null)
      splits!.forEach((element) {
        sum += element;
      });

    return SizedBox(
      height: 300,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (splits != null)
            Expanded(
              child: Row(
                children: List.generate(splits!.length, (index) {
                  return Expanded(
                      flex: ((splits![index] / sum) * 100).toInt(),
                      child: SingleSize(
                          width: splits![index],
                          onchangeSize: (int? newValue) {
                            print(newValue);
                            if (newValue != null) {
                              onChangeSize(newValue, index);
                            }
                          }));
                }),
              ),
            ),
          const SizedBox(
            height: 40,
          ),
          SingleSize(
              width: width,
              onchangeSize: (int? newValue) {
                print("notValid");
              })
        ],
      ),
    );
  }
}

class VerticalSize extends StatelessWidget {
  const VerticalSize(
      {required this.height,
      required this.splits,
      required this.onChangeSize,
      super.key});

  final double height;
  final List<double>? splits;
  final Function(int, int) onChangeSize;

  @override
  Widget build(BuildContext context) {
    var sum = 0.0;
    if (splits != null)
      splits!.forEach((element) {
        sum += element;
      });
    return SizedBox(
      width: 300,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleSize(
              height: height,
              onchangeSize: (int? newValue) {
                print("not valid");
              }),
          const SizedBox(
            width: 40,
          ),
          if (splits != null)
            Expanded(
              child: Column(
                children: List.generate(splits!.length, (index) {
                  return Expanded(
                      flex: ((splits![index] / sum) * 100).toInt(),
                      child: SingleSize(
                          height: splits![index],
                          onchangeSize: (int? newValue) {
                            print(newValue);
                            if (newValue != null) {
                              onChangeSize(newValue, index);
                            }
                          }));
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class SingleSize extends StatelessWidget {
  const SingleSize(
      {this.width, this.height, super.key, required this.onchangeSize});

  final double? width;
  final double? height;
  final Function(int?) onchangeSize;

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
      child: GestureDetector(
        onTap: () {
          showSizeDialog(size.toInt(), context, onchangeSize: (int? newValue) {
            onchangeSize(newValue);
          });
        },
        child: Row(
          children: [
            Container(
              color: Colors.black,
              height: 100,
              width: 5,
            ),
            Expanded(
                child: Container(
              color: Colors.black,
              height: 3,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                size.toInt().toString(),
                style: const TextStyle(fontSize: 80),
              ),
            ),
            Expanded(
                child: Container(
              color: Colors.black,
              height: 3,
            )),
            Container(
              color: Colors.black,
              height: 100,
              width: 5,
            ),
          ],
        ),
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
    return DragTarget<Profile>(onAcceptWithDetails: (data) {
      RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);
      onAcceptWithDetails?.call(MyDragTargetDetails<T>(
          data: data.data as T,
          offset: Offset(
              data.offset.dx - (position.dx), data.offset.dy - (position.dy)),
          fixed: false,
          changedOffset: false));
    }, builder: (c, _, __) {
      return Container(
        width: size.width,
        height: size.height,
        color: Colors.transparent,
      );
    });
  }
}

class MyDragTargetDetails<T> {
  /// Creates details for a [DragTarget] callback.
  MyDragTargetDetails(
      {required this.data,
      required this.offset,
      required this.fixed,
      this.edge,
      this.start,
      this.end,
      required this.changedOffset,
      this.percent});

  /// The data that was dropped onto this [DragTarget].
  final T data;

  /// The global position when the specific pointer event occurred on
  /// the draggable.
  Offset offset;

  Offset? start;
  Offset? end;

  double? percent;

  Edge? edge;

  bool fixed;
  bool changedOffset;
}

class Profile {
  String name;
  bool isVertical;

  Profile({required this.name, required this.isVertical});
}

showSizeDialog(int value, BuildContext context,
    {required Function(int?) onchangeSize}) {
  showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          alignment: Alignment.bottomCenter,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: SizedBox(
            height: 400,
            width: MediaQuery.sizeOf(context).width * 0.95,
            child: numPad(value, onchangeSize: onchangeSize),
          ),
        );
      });
}

class numPad extends StatefulWidget {
  const numPad(this.value, {super.key, required this.onchangeSize});

  final int value;
  final Function(int?) onchangeSize;

  @override
  State<numPad> createState() => _numPadState();
}

class _numPadState extends State<numPad> {
  int? initValue;
  int? newValue;

  @override
  void initState() {
    initValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
              child: Text(
                newValue == null
                    ? (initValue == null ? "" : initValue.toString())
                    : newValue.toString(),
                style: TextStyle(
                    fontSize: 30,
                    color: initValue == null ? Colors.black : Colors.grey),
              ),
            )),
            IconButton(
                onPressed: () {
                  removeLast();
                },
                icon: const Icon(Icons.backspace_sharp))
          ],
        ),
        SizedBox(
            height: 270,
            child: GridView.count(
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.5,
                childAspectRatio: 5 / 3,
                crossAxisCount: 3,
                children: [
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(1);
                          },
                          child: const Text("1"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(2);
                          },
                          child: const Text("2"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(3);
                          },
                          child: const Text("3"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(4);
                          },
                          child: const Text("4"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(5);
                          },
                          child: const Text("5"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(6);
                          },
                          child: const Text("6"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(7);
                          },
                          child: const Text("7"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(8);
                          },
                          child: const Text("8"))),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(9);
                          },
                          child: const Text("9"))),
                  TextButton(onPressed: () {}, child: const SizedBox()),
                  Container(
                      color: Colors.white,
                      child: TextButton(
                          onPressed: () {
                            addToValue(0);
                          },
                          child: const Text("0"))),
                  TextButton(onPressed: () {}, child: const SizedBox()),
                ])),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("cancel")),
            TextButton(
                onPressed: () {
                  widget.onchangeSize(newValue!);
                  Navigator.of(context).pop();
                },
                child: Text("ok"))
          ],
        )
      ],
    );
  }

  void addToValue(int i) {
    initValue = null;
    if (newValue != null) {
      newValue = int.parse(newValue.toString() + i.toString());
    } else {
      newValue = i;
    }
    setState(() {});
  }

  void removeLast() {
    newValue ??= initValue;

    var all = newValue.toString().split('');
    if (all.length == 1) {
      newValue = null;
      initValue = null;
    } else {
      all.removeLast();
      newValue = int.parse(all.join());
    }

    setState(() {});
  }
}
