import 'package:flutter/material.dart';
import 'package:fourplus/sade.dart';

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

  var size = Size(300, 200);


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
                      data: Profile(name: "1", dx: 0, dy: 0, isVertical: true ),
                      feedback: Image.asset('assets/1.png', height: 30,),
                      child: Image.asset('assets/1.png', height: 30, width: 30,),),
                  const SizedBox(
                    width: 20,
                  ),
                  Draggable<Profile>(
                    data: Profile(name: "1", dx: 0, dy: 0, isVertical: false ),
                    feedback: RotatedBox(
                        quarterTurns: 1,child: Image.asset('assets/1.png', height: 30,)),
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Image.asset('assets/1.png', height: 30, width: 30,)),),

                    // Draggable<Profile>(
                  //     data: Profile(name: 2, fit: BoxFit.fill),
                  //     feedback: Image.asset('assets/2.png', height: 30,),
                  //     child: Image.asset('assets/2.png', height: 30,),),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  // Draggable<Profile>(
                  //     data: Profile(name: 3, fit: BoxFit.fill),
                  //     feedback: Image.asset('assets/3.png', height: 30,),
                  //     child: Image.asset('assets/3.png', height: 30,))
                ],
              ),
            ),
            const SizedBox(height: 200,),
            TargetWidget(type: 1, size: size,)
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

  List<DragTargetDetails<Profile>> myList = [];

  @override
  Widget build(BuildContext context) {
    // var myList = [
    //   Profile(name: "1", dx: 0, dy: 0, isVertical: true,),
    //   Profile(name: "1", dx: widget.size.width /2, dy: 50, isVertical: false,),
    // ];

    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                myList.removeLast();
              }, icon: const Icon(Icons.undo)),
              IconButton(onPressed: (){
              }, icon: const Icon(Icons.redo))
            ],
          ),
        ),
        Text("${myList.length}"),
        Stack(
          children: [

            Sade(width: widget.size.width, height: widget.size.height, data: myList),
            DragTarget<Profile>(
                onAcceptWithDetails: (data) {
                  myList.add(data);
                  setState(() {

                  });
                },
                builder: (c, _, __) {
                  return Container(width: widget.size.width, height: widget.size.height, color: Colors.transparent,);
                }),
          ],
        ),
      ],
    );
  }
}



class Profile{
  String name;
  double dx;
  double dy;
  bool isVertical;

  Profile({required this.name, required this.dx, required this.dy, required this.isVertical});
}

