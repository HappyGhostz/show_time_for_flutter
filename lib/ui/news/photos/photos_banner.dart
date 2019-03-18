import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/photos.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/banner.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
class PhotosBannerPage extends StatefulWidget{
  PhotosBannerPage({Key key,this.photoset}):super(key:key);
  final PhotoSet photoset;
  @override
  State<StatefulWidget> createState() => PhotosBannerPageState();
}

class PhotosBannerPageState extends State<PhotosBannerPage> with TickerProviderStateMixin{
  int currentIndex = 1;
  AnimationController animationController;
  Animation<double> animation;
  GlobalKey _myKey = new GlobalKey();
  double infoHeight =0.0;
  PhotoSet photoset;
  @override
  void initState() {
    super.initState();
    photoset=widget.photoset;
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (photoset.list== null|| photoset.list.length==0)
          ? LoadingAndErrorView(
        layoutStatus: LayoutStatus.loading,
        noDataTab: () {

        },
        retryTab: () {

        },
      )
          : Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: <Widget>[
            BannerView(
              autoRolling: false,
              cycleRolling: false,
              isShowCycleWidget: false,
              isShowTextInfoWidget: false,
              banners: _buildBannerView(),
              intervalDuration: new Duration(seconds: 5),
              onPageChanged: (index){
                currentIndex=index+1;
                setState(() {
                });
              },
              height: MediaQuery.of(context).size.height,
              onTap: (){
                var height = _myKey.currentContext.size.height;
                if(height==0){
                  animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
                  CurvedAnimation curvedAnimation =new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
                  animation = Tween(begin: 0.0,end: infoHeight).animate(curvedAnimation);
                  animation.addListener((){
                    setState(() {

                    });
                  });
                  animationController.forward();
                  return;
                }
                infoHeight =height;
                animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
                CurvedAnimation curvedAnimation =new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
                animation = Tween(begin: infoHeight,end: 0.0).animate(curvedAnimation);
                animation.addListener((){
                  setState(() {

                  });
                });
                animationController.forward();
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(left: 8.0,top: 16.0,right: 8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Expanded(child:
                        Text(
                          photoset.info.setname +
                              " $currentIndex/${photoset.list.length}",
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white,fontSize: 20.0),
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Opacity(opacity: 1.0,
                child: infoHeight==0?Container(
                  key: _myKey,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(photoset.list[currentIndex-1].note,
                        style: TextStyle(color: Colors.white),
                      ))
                    ],
                  ),
                ):Container(
                  key: _myKey,
                  height: animation.value,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(photoset.list[currentIndex-1].note,
                        style: TextStyle(color: Colors.white),
                      ))
                    ],
                  ),
                ),)
              ,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBannerView() {
    List<Widget> widget = [];
    for (int i = 0; i < photoset.list.length; i++) {
      var photo = photoset.list[i];
      var imageForSize = ImageUtils.showFadeImageForSize(
          photo.img,
          MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width,
          BoxFit.cover);
      widget.add(imageForSize);
    }
    return widget;
  }
}