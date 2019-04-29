import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';

/**
 * @author zcp
 * @date 2019/4/29
 * @Description
 */
class PictureDetailPage extends StatefulWidget {
  PictureDetailPage({
    Key key,
    @required this.imgUrl,
    this.imgTitle,
  }) : super(key: key);
  String imgUrl;
  String imgTitle;

  @override
  State<StatefulWidget> createState() => PictureDetailPageState();
}

class PictureDetailPageState extends State<PictureDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child: ImageUtils.showFadeImageForSize(
              widget.imgUrl,
              MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width,
              BoxFit.cover),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, top: 40.0),
          child: Row(
            children: <Widget>[
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                margin: EdgeInsets.only(right: 10.0),
              ),
              Expanded(child: Text(
                widget.imgTitle == null ? "图片" : widget.imgTitle,
                style: TextStyle(color: Colors.white),
              ))
            ],
          ),
        ),
      ]),
    );
  }
}
