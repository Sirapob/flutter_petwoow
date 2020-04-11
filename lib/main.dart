import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  GlobalKey globalKey = GlobalKey();
  List<double> limts = [];

  Offset _offset = Offset(0, 0);
  bool isMenuOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    limts = [0,0,0,0,0,0,0,0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration){
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double constLimit = position.dy + renderBox.size.height - 20;
    double step = (constLimit - start)/6;
    limts=[];
    for(double x = start; x <= constLimit; x = x + step){
      limts.add(x);

    }

    setState(() {
      limts = limts;
    });
  }
  double getSize(int x){

    double size = (_offset.dy > limts[x] && _offset.dy < limts[x + 1]) ? 25 :20;
    return size;
  }


  @override
  Widget build(BuildContext context) {

    Size mediaQuery = MediaQuery.of(context).size;
    double sizebarSize = mediaQuery.width * 0.65;
    double menuContainerHeight = mediaQuery.height/2;


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(255,65,108,1.0),
                Color.fromRGBO(255,75,73,1.0)
              ])
          ),
          width: mediaQuery.width,
          child: Stack(
            children: <Widget>[
              Center(
                child: MaterialButton(
                    color: Colors.white,
                    child: Text(
                      "Hello World1",
                      style: TextStyle(
                          color: Colors.black
                      ),

                    ),
                    onPressed:(){}
                ),

              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 1500),
                left: isMenuOpen?0:-sizebarSize+20,
                top:0,
                curve: Curves.elasticOut,
                child: SizedBox(
                  width: sizebarSize,
                  child: GestureDetector(
                    onPanUpdate: (details){
                      if(details.localPosition.dx <= sizebarSize) {
                        setState(() {
                          _offset = details.localPosition;
                        });
                      }
                      if(details.localPosition.dx>sizebarSize-20&&details.delta.distanceSquared>2){
                        setState(() {
                          isMenuOpen = true;
                        });
                      }
                    },
                    onPanEnd: (DragEndDetails details){
                      setState(() {
                        _offset = Offset(0, 0);
                      });
                    },
                    child: Stack(

                      children: <Widget>[
                        CustomPaint(
                          size: Size(sizebarSize,mediaQuery.height),
                          painter: DrawerPaint(_offset),
                        ),
                        Container(
                          height: mediaQuery.height,
                          width: sizebarSize,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                height: mediaQuery.height*0.25,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset('assets/images/user.png',width: sizebarSize/2),
                                      Text("RetroPortal Studio",style: TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(thickness: 1,),
                              Container(
                                key:globalKey,
                                width: double.infinity,
                                height: menuContainerHeight,
                                child: Column(
                                  children: <Widget>[
                                    MyButton(
                                      text: "profile",
                                      iconData:Icons.person,
                                      textSize: getSize(0),
                                      height: (menuContainerHeight)/5,
                                    ),
                                    MyButton(
                                      text: "Payments",
                                      iconData:Icons.payment,
                                      textSize: getSize(1),
                                      height: (menuContainerHeight)/5,
                                    ),
                                    MyButton(
                                      text: "Notications",
                                      iconData:Icons.notifications,
                                      textSize: getSize(2),
                                      height: (menuContainerHeight)/5,
                                    ),
                                    MyButton(
                                      text: "Settings",
                                      iconData:Icons.settings,
                                      textSize: getSize(3),
                                      height: (menuContainerHeight)/5,
                                    ),
                                    MyButton(
                                      text: "My Files",
                                      iconData:Icons.attach_file,
                                      textSize: getSize(4),
                                      height: (menuContainerHeight)/5,
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),

                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 400),
                          right: isMenuOpen?10:sizebarSize,
                          top:10,
                          child: IconButton(
                            enableFeedback: true,
                            icon:Icon(Icons.keyboard_backspace,color: Colors.black45,size: 30,),
                            onPressed: (){
                              this.setState(() {
                                isMenuOpen = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerPaint extends CustomPainter{
  Offset _offset;
  DrawerPaint(this._offset);

  double getControlPointX(double width){
    if(_offset.dx == 0){
      return width;
    }else{
      return _offset.dx>width?_offset.dy:width+75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(getControlPointX(size.width), _offset.dy, size.width,size.height);
    path.lineTo(-size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class MyButton extends StatelessWidget{
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;

  MyButton({this.text, this.iconData, this.textSize, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style:TextStyle(color: Colors.black45,fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
