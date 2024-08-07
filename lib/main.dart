import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourplus/profile_drawing_widget.dart';
import 'package:fourplus/profile_drawing_widget2.dart';
import 'package:fourplus/profile_preview_widget.dart';
import 'package:multi_split_view/multi_split_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home:MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class GetSizeWidget extends StatelessWidget {
  var heightController = TextEditingController();
  var widthController = TextEditingController();

  GetSizeWidget(this.onChangeSize, {super.key});
  Function(Size) onChangeSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'عرض',
              ),
              controller: widthController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ارتفاع'
              ),
              controller: heightController,
            ),
          ),
          FilledButton(onPressed: (){
            onChangeSize(Size(int.parse(widthController.text).toDouble(), int.parse(heightController.text).toDouble()));
          }, child: Text("تایید"))
        ],
      ),
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

  bool haveSize = false;
  Size size = Size(0,0);

  List<MyDragTargetDetails<Profile>>? list;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: !haveSize ? GetSizeWidget((size) {
          setState(() {
            haveSize = true;
            this.size = size;
          });
        },) : Column(
          children: [
            Container(
              height: 60,
              color: Colors.blue,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BackButton(onPressed: (){
                      setState(() {
                        haveSize = false;
                      });
                    },),
                    const Spacer(),
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
            ),
            ProfileDrawingWidget2(size: size,
                initialProfileList: list,
                onAddNewProfile: (List<MyDragTargetDetails<Profile>> newList){

                }
            ),
            WindowWidget(size: size,
                initialProfileList: list,
                onAddNewProfile: (List<MyDragTargetDetails<Profile>> newList){
                  list = newList;
                  setState(() {

                  });
                }
            ),
          ],
        ),
      ),
    );
  }
}

class WindowWidget extends StatelessWidget {
  WindowWidget({required this.size, this.initialProfileList, required this.onAddNewProfile, super.key});
  final Size size;
  final List<MyDragTargetDetails<Profile>>? initialProfileList;
  final Function(List<MyDragTargetDetails<Profile>> newList) onAddNewProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Draggable<Profile>(
                data: Profile(name: ProfileName.double, isVertical: true, splitter: true),
                feedback: Image.asset(
                  'assets/double.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/double.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.top, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/top.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/top.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.right, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/right.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/right.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.topRight, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/topRight.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/topRight.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.dRight, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/dRight.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/dRight.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.fillV, isVertical: true, hasChild: false, fillEleman: true),
                feedback: Image.asset(
                  'assets/fillV.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/fillV.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Draggable<Profile>(
                data: Profile(name: ProfileName.vertical, isVertical: true, splitter: true),
                feedback: Image.asset(
                  'assets/vertical.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/vertical.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.horizontal, isVertical: false, splitter: true),
                feedback: Image.asset(
                  'assets/horizontal.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/horizontal.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.left, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/left.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/left.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.topLeft, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/topLeft.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/topLeft.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.dLeft, isVertical: false, hasChild: true),
                feedback: Image.asset(
                  'assets/dLeft.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/dLeft.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Draggable<Profile>(
                data: Profile(name: ProfileName.fillH, isVertical: false, hasChild: false, fillEleman: true),
                feedback: Image.asset(
                  'assets/fillH.png',
                  height: 30,
                ),
                child: ElemanWidget(
                  child: Image.asset(
                    'assets/fillH.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),

            ],
          ),
        ),
        ProfileDrawingWidget(
          size: size,
          initialProfileList: initialProfileList,
          onAddNewProfile: (List<MyDragTargetDetails<Profile>> newList){
            onAddNewProfile(newList);
          }
        ),
      ],
    );
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

    if (splits != null) {
      splits!.forEach((element) {
        sum += element;
      });
    }

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
    if (splits != null) {
      splits!.forEach((element) {
        sum += element;
      });
    }
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
                key: GlobalKey(),
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

    var availableWidth = MediaQuery.sizeOf(context).width - 20;
    var availableHeight = MediaQuery.sizeOf(context).height - 264;

    var scale;

    if(size.width > size.height){
      if((300 + size.width) < availableWidth){
        scale = (availableWidth / (300 + size.width));
      }else{
        scale = ((300 + size.width)/ availableWidth);
      }
    } else {
      if((300 + size.height) < availableHeight){
        scale = (availableHeight / (300 + size.height));
      }else{
        scale = ((300 + size.height)/ availableHeight);
      }
    }


    return DragTarget<Profile>(onAcceptWithDetails: (data) {
      RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);

      var dx = (data.offset.dx - (position.dx));
      var dy = (data.offset.dy - (position.dy));

      onAcceptWithDetails?.call(MyDragTargetDetails<T>(
          data: data.data as T,
          offset: Offset(dx * scale, dy * scale),
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
        this.offset2,
        this.start2,
      this.end2,
      required this.changedOffset,});

  /// The data that was dropped onto this [DragTarget].
  final T data;

  /// The global position when the specific pointer event occurred on
  /// the draggable.
  Offset offset;

  Offset? start;
  Offset? end;

  Offset? offset2;

  Offset? start2;
  Offset? end2;

  Edge? edge;

  bool fixed;
  bool changedOffset;

  int? parentIndex;
}

class Profile {
  ProfileName name;
  bool isVertical;
  bool hasChild;
  bool fillEleman;
  bool splitter;

  Profile({required this.name, required this.isVertical, this.hasChild = false, this.fillEleman = false, this.splitter = false});
}

enum ProfileName{
  horizontal, vertical, left, right, top, fillH, fillV, topRight, topLeft, double, dLeft, dRight, edge
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


class ElemanWidget extends StatelessWidget {
  const ElemanWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: child,
    );
  }
}
