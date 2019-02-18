import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/downtime.dart';
import 'package:show_time_for_flutter/home.dart';

void main() => runApp(ShowTimeApp());


class ShowTimeApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LunchState();
}
class LunchState extends State<ShowTimeApp>{
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LuncherImage(),
    );
  }
}
class LuncherImage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>LuncherImageState();
}
class LuncherImageState extends State<LuncherImage>{
  showNextPage(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context){
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      return HomeWidget();
    }), (route) => route == null);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("images/splash.gif",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,),
        Positioned(
          child: new GestureDetector(
            onTap: (){
              showNextPage();
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: DownTimeWidget(clors: Colors.red,time: 5000,width: 50,strokeWidth: 5.0,
                textStyle: TextStyle(color: Colors.black,fontSize: 8.0
                    ,decoration:TextDecoration.none ),
                endListener: (){
                  showNextPage();
                },),
            ),
          ),
          top: 2.0,
          right: 2.0,
        ),
      ],
    );
  }
}