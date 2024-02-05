import 'package:flutter/material.dart';

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

  Profile profile = Profile(name: 2, fit: BoxFit.fill);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Column(
          children: [
            Container(
              height: 60,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Draggable<Profile>(
                      data: Profile(name: 1, fit: BoxFit.none),
                      feedback: Image.asset('assets/1.png', height: 30,),
                      child: Image.asset('assets/1.png', height: 30,),),
                  const SizedBox(
                    width: 20,
                  ),Draggable<Profile>(
                      data: Profile(name: 2, fit: BoxFit.fill),
                      feedback: Image.asset('assets/2.png', height: 30,),
                      child: Image.asset('assets/2.png', height: 30,),),
                  const SizedBox(
                    width: 20,
                  ),
                  Draggable<Profile>(
                      data: Profile(name: 3, fit: BoxFit.fill),
                      feedback: Image.asset('assets/3.png', height: 30,),
                      child: Image.asset('assets/3.png', height: 30,))
                ],
              ),
            ),
            const SizedBox(height: 200,),
            const TargetWidget(type: 1)
          ],
        ),
      ),
    );
  }
}

class TargetWidget extends StatefulWidget {
  const TargetWidget({required this.type, super.key});

  final int type;

  @override
  State<TargetWidget> createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {

  Profile profile  = Profile(name: 2, fit: BoxFit.fill);

  double height= 500;
  double width= 200;
  double ratio = 1;
  int sizeScale = 8;

  @override
  Widget build(BuildContext context) {

    if(width > height){
      ratio = width / height;
    }else{
      ratio = height / width;
    }

    return DragTarget<Profile>(
        onAccept: (data) => setState(() {

          profile = data;
        }),
        builder: (c, _, __) {
          return Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/glass.png"), fit: BoxFit.fill)
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset('assets/left.png', fit: BoxFit.fill, width: ratio * sizeScale, height: height)),
                Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset('assets/right.png', fit: BoxFit.fill, width: ratio * sizeScale, height: height,)),
                Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/top.png', fit: BoxFit.fill, height: ratio * sizeScale, width: width)),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('assets/bottom.png', fit: BoxFit.fill, height: ratio * sizeScale, width: width)),
                Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/topLeft.png', fit: BoxFit.contain, height: ratio * sizeScale, width: ratio * sizeScale)),
                 Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('assets/topRight.png', fit: BoxFit.contain, height: ratio * sizeScale, width: ratio * sizeScale)),
                 Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset('assets/bottomLeft.png', fit: BoxFit.contain, height: ratio * sizeScale, width: ratio * sizeScale)),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset('assets/bottomRight.png', fit: BoxFit.contain, height: ratio * sizeScale, width: ratio * sizeScale)),
                if(profile.name == 1) Align(
                    alignment: Alignment.center, child: Image.asset('assets/1.png', fit: BoxFit.fitHeight, ))
              ],
            ),
          );
        });
  }
}



class Profile{
  int name;
  BoxFit fit;

  Profile({required this.name, required this.fit});
}

