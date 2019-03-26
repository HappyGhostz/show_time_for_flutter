import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'dart:ui';
/**
 * @author zcp
 * @date 2019/3/25
 * @Description
 */

class MusicListHeadPage extends StatelessWidget{
  MusicListHeadPage({
    this.imageSrc,
    this.countNum,
    this.title,
    this.tag,
});
  String imageSrc;
  String countNum;
  String title;
  String tag;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Image.network(imageSrc,fit: BoxFit.fill,),
          constraints: BoxConstraints.expand(),
        ),
        BackdropFilter(
          filter:ImageFilter.blur(sigmaX: 10,sigmaY: 10),
          child: Container(
            constraints: BoxConstraints.expand(),
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        Positioned(
            left: 0.0,
            right: 0.0,
            top: 90.0,
            bottom: 10.0,
            child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 123.0,
                            height: 123.0,
                            child: ImageUtils.showFadeImageForSize(
                                imageSrc, 123, 123,BoxFit.cover),
                          )
                          ,
                          Container(
                            width: 123.0,
                            constraints: BoxConstraints(
                              maxWidth: double.infinity,
                            ),
                            color: Colors.black54,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.asset("assets/images/index_icn_earphone.png",
                                  width: 12.0,),
                                Container(
                                  margin: EdgeInsets.only(left: 4.0,right: 2.0,top:2.0,bottom: 2.0),
                                  child: Text(
                                    countNum,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                      child: Container(
                        height: 123.0,
                    margin: EdgeInsets.only(left: 15.0,right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0
                        ),),
                        Text(tag,style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0
                        ),)
                      ],
                    ),
                  ))
                ],
              ),
              margin: EdgeInsets.only(left: 25.0),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _builadItem(Icons.create_new_folder,"收藏"),
                  _builadItem(Icons.chat,"评论"),
                  _builadItem(Icons.share,"分享"),
                  _builadItem(Icons.file_download,"下载"),
                ],
              ),
            )
          ],
        ))
      ],
    );
  }
  Widget _builadItem(IconData icon,String tital){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Icon(icon,color: Colors.white,),
          ),
          Container(
            child: Text(tital,style: TextStyle(
              fontSize: 12.0,
              color: Colors.white
            ),),
          )
        ],
      ),
    );
  }
}