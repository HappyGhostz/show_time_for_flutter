import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/news_service.dart';
import 'package:show_time_for_flutter/modul/special_info.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/modul/news_info.dart';
import 'package:show_time_for_flutter/ui/news/news_item.dart';
import 'dart:math';

List<Color> colors = [
  Colors.red,
  Colors.yellow[600],
  Colors.purpleAccent,
  Colors.blue,
  Colors.pink[300],
  Colors.cyan[400],
  Colors.green[400],
  Colors.lime[400],
  Colors.orange,
];

class SpecialNewsDetailPage extends StatefulWidget {
  SpecialNewsDetailPage({Key key, @required this.specialID}) : super(key: key);
  final String specialID;

  @override
  State<StatefulWidget> createState() => SpecialNewsDetailPageState();
}

class SpecialNewsDetailPageState extends State<SpecialNewsDetailPage> {
  NewsServiceApi newsServiceApi = new NewsServiceApi();
  SpecialNews specialNews;
  NewsSpecialInfo newsSpecialInfo;
  ScrollController scrollController;
  bool isShowFloatButton=false;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0.0);
    scrollController.addListener((){
      if (scrollController.offset < 1000 && isShowFloatButton) {
        setState(() {
          isShowFloatButton = false;
        });
      } else if (scrollController.offset >= 1000 && isShowFloatButton == false) {
        setState(() {
          isShowFloatButton = true;
        });
      }
    });
    super.initState();
    loadData();
  }

  loadData() async {
    specialNews = await newsServiceApi.getSpecialNews(widget.specialID);
    newsSpecialInfo = specialNews.newsSpecialInfo;
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
//          title: Text(newsSpecialInfo == null ? "" : newsSpecialInfo.sname),
            pinned: true,
            //是否固定导航栏，
            snap: false,
            //往上滚动隐藏AppBar，往下滑动的时候会马上显示AppBar,true需pinned: false floating: true
            floating: false,
            //滑动到最上面，再滑动是否隐藏导航栏的文字和标题等的具体内容，为true是隐藏，为false是不隐藏
            elevation: 4,
            //阴影的高度
            forceElevated: false,
            //是否显示阴影
            expandedHeight: 200.0,
            //是初始化展开的高度。
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                newsSpecialInfo == null ? "" : newsSpecialInfo.sname,
                style: TextStyle(fontSize: 16),
              ),
              background: ImageUtils.showFadeImage(
                  newsSpecialInfo == null ? "" : newsSpecialInfo.bigBanner,
                  BoxFit.cover),
              //背景，一般是一个图片，在title后面，[Image.fit] set to [BoxFit.cover].
              centerTitle: false,
              collapseMode: CollapseMode
                  .parallax, // 背景 固定到位，直到达到最小范围。 默认是CollapseMode.parallax(将以视差方式滚动。)，还有一个是none，滚动没有效果
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "导语",
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(newsSpecialInfo == null
                            ? ""
                            : newsSpecialInfo.digest)),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 5.0,
                children: _builderTagView(),
              ),
            ),
          ),
          specialNews == null
              ? SliverToBoxAdapter(
                  child: LoadingAndErrorView(
                  layoutStatus: LayoutStatus.loading,
                  noDataTab: () {
                    loadData();
                  },
                  retryTab: () {
                    loadData();
                  },
                ))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Container(
                        margin: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromARGB(1, 221, 221, 221),
                        child: Text(
                            "${index + 1}/${newsSpecialInfo.topics.length} " +
                                newsSpecialInfo.topics[index].tname),
                      ),
                      children:
                          _builderExpansion(newsSpecialInfo.topics[index]),
                    );
                  },
                  childCount: newsSpecialInfo.topics.length,
                ))
        ],
      ),
      floatingActionButton: !isShowFloatButton
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
            ),
    );
  }

  Color getColor() {
    var color = colors[Random().nextInt(colors.length - 1)];
    return color;
  }

  List<Widget> _builderTagView() {
    List<Widget> widgets = [];
    if (newsSpecialInfo == null ||
        newsSpecialInfo.topics == null ||
        newsSpecialInfo.topics.length < 0) {
      widgets.add(Container());
      return widgets;
    }
    for (int i = 0; i < newsSpecialInfo.topics.length; i++) {
      var topic = newsSpecialInfo.topics[i];
      var color = getColor();
      GestureDetector gestureDetector = new GestureDetector(
        child: Chip(
          label: new Text(
            "${i + 1}/${newsSpecialInfo.topics.length} " + topic.tname,
            style: TextStyle(color: color),
          ),
          backgroundColor: Colors.white,
          shape: new StadiumBorder(side: BorderSide(color: color)),
        ),
        onTap: () {
//          _tagClick(i);
        },
      );
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  _tagClick(int index) {
    print("$index");
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  List<Widget> _builderExpansion(Topics topic) {
    List<Widget> widgets = [];
    List<NewsType> newsTypes = topic.docs;
    if (newsTypes == null || newsTypes.length < 0) {
      widgets.add(Container());
      return widgets;
    }
    for (int i = 0; i < newsTypes.length; i++) {
      var newsType = newsTypes[i];
      NewsItemWidget newsItemWidget = NewsItemWidget(
        newsType: newsType,
      );
      widgets.add(newsItemWidget);
    }
    return widgets;
  }
}
