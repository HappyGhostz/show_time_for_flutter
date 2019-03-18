import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/news_service.dart';
import 'package:show_time_for_flutter/modul/photos_detail.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/banner.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';

class PhotoSetsPage extends StatefulWidget {
  PhotoSetsPage({Key key, @required this.photosetID}) : super(key: key);
  final String photosetID;

  @override
  State<StatefulWidget> createState() => PhotoSetsPageState();
}

class PhotoSetsPageState extends State<PhotoSetsPage> with TickerProviderStateMixin{
  NewsServiceApi newsServiceApi = new NewsServiceApi();
  PhotoSetInfo photoSetInfo;
  List<PhotosEntity> photos;
  int currentIndex = 1;
  AnimationController animationController;
  Animation<double> animation;
  GlobalKey _myKey = new GlobalKey();
  double infoHeight =0.0;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  /**
   * 裁剪图集ID
   *
   * @param photoId
   * @return
   */
  String clipPhotoSetId(String photoId) {
    if (photoId == null || photoId.isEmpty) {
      return "";
    }
    var i = photoId.indexOf("|");
    if (i >= 4) {
      var result = photoId.replaceAll('|', '/');
      return result.substring(i - 4);
    }
    return null;
  }

  loadData() async {
    photoSetInfo =
        await newsServiceApi.getPhotosNews(clipPhotoSetId(widget.photosetID));
    photos = photoSetInfo.photos;
    setState(() {});
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: photoSetInfo == null
          ? LoadingAndErrorView(
              layoutStatus: LayoutStatus.loading,
              noDataTab: () {
                loadData();
              },
              retryTab: () {
                loadData();
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
                                photoSetInfo.setname +
                                    " $currentIndex/${photos.length}",
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
                          Expanded(child: Text(photos[currentIndex-1].note,
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
                          Expanded(child: Text(photos[currentIndex-1].note,
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
    for (int i = 0; i < photos.length; i++) {
      var photo = photos[i];
      var imageForSize = ImageUtils.showFadeImageForSize(
          photo.imgurl,
          MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width,
          BoxFit.cover);
      widget.add(imageForSize);
    }
    return widget;
  }
}
