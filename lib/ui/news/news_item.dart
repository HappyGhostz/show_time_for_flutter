import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/news_info.dart';
import 'dart:math';
import 'package:show_time_for_flutter/widgets/label_view.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/news/normal/news_detail.dart';
import 'package:show_time_for_flutter/ui/news/special/special_detail.dart';
import 'package:show_time_for_flutter/ui/news/photos/photo_sets.dart';

String NEWS_ITEM_SPECIAL = "special";
String NEWS_ITEM_PHOTO_SET = "photoset";

class NewsItemWidget extends StatefulWidget {
  NewsItemWidget({Key key, @required this.newsType}) : super();
  final NewsType newsType;

  @override
  State<StatefulWidget> createState() => NewsItemWidgetState();
}

class NewsItemWidgetState extends State<NewsItemWidget> {
  @override
  Widget build(BuildContext context) {
    if (isNewsPhotoSet(widget.newsType.skipType)) {
      return GestureDetector(
        child: LabelViewDecoration(
            size: Size(80.0, 80.0),
            labelColor: Colors.blue,
            labelAlignment: LabelAlignment.leftTop,
            useAngle: true,
            labelText: "图集",
            labelTextColor: Colors.white,
            child: _builderPhotosItem()),
        onTap: () {
          _handlePhotosNews();
        },
      );
    } else {
      if (isNewsSpecial(widget.newsType.skipType)) {
        return GestureDetector(
          child: LabelViewDecoration(
              size: Size(80.0, 80.0),
              labelColor: Colors.red,
              labelAlignment: LabelAlignment.leftTop,
              useAngle: true,
              labelText: "专题",
              labelTextColor: Colors.white,
              child: _builderItem()),
          onTap: () {
            _handleSpecialNews();
          },
        );
      } else {
        return GestureDetector(
          child: _builderItem(),
          onTap: () {
            _handleNormalNews();
          },
        );
      }
    }
  }

  _handleNormalNews() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NormalNewsDetailPage(
        postId: widget.newsType.postid,
      );
    }));
  }

  _handleSpecialNews() {
    var specialID = widget.newsType.specialID;
    if (specialID == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SpecialNewsDetailPage(
        specialID: specialID,
      );
    }));
  }

  _handlePhotosNews() {
    var photosetID = widget.newsType.photosetID;
    if (photosetID == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PhotoSetsPage(
        photosetID: photosetID,
      );
    }));
  }

  Widget _builderPhotosItem() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            widget.newsType.title,
            softWrap: true,
            maxLines: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildOtherImage(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                widget.newsType.source,
                softWrap: true,
              )),
              Text(
                widget.newsType.ptime,
                softWrap: false,
              ),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildOtherImage() {
    List<Widget> widgets = [];
    Expanded expanded = Expanded(
      child: Container(
          padding: EdgeInsets.only(right: 2.0),
          child: ImageUtils.showFadeImageForHeight(
              widget.newsType.imgsrc, 75.0, BoxFit.cover)),
    );
    widgets.add(expanded);
    List<Imgextra> imgextras = widget.newsType.imgextra;
    if (imgextras != null && imgextras.length > 0) {
      for (int i = 0; i < (min(2, imgextras.length)); i++) {
        var expanded2 = Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 2.0, right: 2.0),
              child: ImageUtils.showFadeImageForHeight(
                  imgextras[i].imgsrc, 75.0, BoxFit.cover)),
        );
        widgets.add(expanded2);
      }
    }
    return widgets;
  }

  Widget _builderItem() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(
            child: ImageUtils.showFadeImageForSize(
                widget.newsType.imgsrc, 75.0, 100, BoxFit.cover),
          ),

          ///Expanded加上这个小部件放置 内容溢出
          Expanded(
            child: Container(
              height: 75.0,
              padding: EdgeInsets.only(left: 4.0, right: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: Text(
                      widget.newsType.title == null
                          ? ""
                          : widget.newsType.title,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                  new Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          widget.newsType.source == null
                              ? ""
                              : widget.newsType.source,
                          softWrap: true,
                        )),
                        Text(
                          widget.newsType.ptime == null
                              ? ""
                              : widget.newsType.ptime,
                          softWrap: false,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /**
   * 判断新闻类型
   *
   * @param skipType
   * @return
   */
  bool isNewsSpecial(String skipType) {
    if (skipType == null) {
      return false;
    }
    return NEWS_ITEM_SPECIAL == skipType;
  }

  bool isNewsPhotoSet(String skipType) {
    if (skipType == null) {
      return false;
    }
    return NEWS_ITEM_PHOTO_SET == skipType;
  }
}
