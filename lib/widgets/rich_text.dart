import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/news_detail.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:flutter_html/flutter_html.dart';

// 新闻ID前缀，eg：BV9KHEMS0001124J
String NEWS_ID_PREFIX = "BV";
// 新闻ID后缀，eg：http://news.163.com/17/0116/16/CATR1P580001875N.html
String NEWS_ID_SUFFIX = ".html";
// 新闻ID长度
int NEWS_ID_LENGTH = 16;

class RichNewsText extends StatefulWidget {
  final NewsDetail newsDetail;

  RichNewsText({Key key, this.newsDetail}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RichNewsTextState();
}

class RichNewsTextState extends State<RichNewsText> {
  List<String> newsBodys;

  @override
  void initState() {
    super.initState();
    String body = widget.newsDetail.newsDetailInfo.body;
    newsBodys = body.split(new RegExp("<!--IMG#[0-9]-->"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: _buildTexts(),
      ),
    );
  }

  List<Widget> _buildTexts() {
    List<Widget> widgets = [];
    var imgs = widget.newsDetail.newsDetailInfo.img;
    for (int i = 0; i < newsBodys.length; i++) {
      if (!newsBodys[i].isEmpty) {
        var html = Html(data: newsBodys[i]);
        widgets.add(html);
      }
      if (imgs != null && i < imgs.length) {
        var img = imgs[i];
        var imageForSize = ImageUtils.showFadeImageForWidth(
            img.src, MediaQuery.of(context).size.width, BoxFit.fitWidth);
        widgets.add(imageForSize);
      }
    }
    var spinfo = widget.newsDetail.newsDetailInfo.spinfo;
    if (spinfo != null && spinfo.length > 0) {
      Column spinfoWidget = Column(
        children: <Widget>[
          Container(
            child: new Row(
              children: <Widget>[
                Text(
                  spinfo[0].sptype,
                  style: TextStyle(color: Colors.red),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Divider(
                    color: Colors.grey[500],
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Html(
              data: spinfo[0].spcontent,
              onLinkTap: (url) {
                String fromUrl = clipNewsIdFromUrl(url);
                print("fromUrl:$fromUrl");
              },
            ),
          )
        ],
      );
      widgets.add(spinfoWidget);
    }
    return widgets;
  }

  /**
   * 从超链接中取出新闻ID
   *
   * @param url url
   * @return 新闻ID
   */
  String clipNewsIdFromUrl(String url) {
    String typeId = null;
    var indexOf = url.indexOf(NEWS_ID_PREFIX);
    if (indexOf != -1) {
      typeId = url.substring(indexOf, indexOf + NEWS_ID_LENGTH);
    } else if (url.endsWith(NEWS_ID_SUFFIX)) {
      indexOf = url.length - NEWS_ID_LENGTH - NEWS_ID_SUFFIX.length;
      typeId = url.substring(indexOf, indexOf + NEWS_ID_LENGTH);
    }
    return typeId;
  }
}
