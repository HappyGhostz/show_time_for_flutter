import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/news_service.dart';
import 'package:show_time_for_flutter/modul/news_detail.dart';
import 'package:show_time_for_flutter/widgets/rich_text.dart';

class NormalNewsDetailPage extends StatefulWidget {
  NormalNewsDetailPage({Key key, @required this.postId}) : super(key: key);
  final String postId;

  @override
  State<StatefulWidget> createState() => NormalNewsDetailPageState();
}

class NormalNewsDetailPageState extends State<NormalNewsDetailPage>
    with TickerProviderStateMixin {
  NewsServiceApi newsServiceApi = new NewsServiceApi();
  NewsDetail newsDetail;
  ScrollController _scrollController;
  bool _showNext = false;
  double _currentPixels = 0.0;
  double _currentMaxScrollExtent = 0.0;
  double nextHeight = 0.0;
  double fristMaxScrollExtent;
  String mNextNewsId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      _currentPixels = _scrollController.position.pixels;
      _currentMaxScrollExtent = _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fristMaxScrollExtent = _scrollController.position.maxScrollExtent;
        setState(() {
          _showNext = true;
        });
      }
      if (_scrollController.position.pixels <
          _scrollController.position.maxScrollExtent - 100) {
        setState(() {
          _showNext = false;
        });
      }
    });
    loadData();
  }

  loadData() async {
    newsDetail = await newsServiceApi.getNewsDetail(widget.postId);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  _builderNextNews() {
    if (mNextNewsId == null && _showNext) {
      setState(() {
        _showNext = false;
      });
    } else if (mNextNewsId != null && _showNext) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return NormalNewsDetailPage(
          postId: mNextNewsId,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    var relative_sys = newsDetail?.newsDetailInfo?.relative_sys;
    if (relative_sys != null && relative_sys.length > 0) {
      mNextNewsId = relative_sys[0].id;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
              child: Listener(
            onPointerUp: (detail) {
              _builderNextNews();
            },
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            newsDetail == null
                                ? ""
                                : newsDetail.newsDetailInfo.title,
                            style: TextStyle(fontSize: 16.0),
                            maxLines: 2,
                          )),
                          Text(
                            newsDetail == null
                                ? ""
                                : newsDetail.newsDetailInfo.ptime,
                            style: TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    pinned: false,
                    floating: true,
                    forceElevated: true,
                  )
                ];
              },
              body: new Container(
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: ScrollPhysics(
                      parent: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics())),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: newsDetail == null
                          ? new Container()
                          : RichNewsText(
                              newsDetail: newsDetail,
                            ),
                    ),
                    _showNext
                        ? SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 18.0, left: 8.0, right: 8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "-------- 继续拖动，查看下一篇 --------",
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  (relative_sys != null &&
                                          relative_sys.length > 0)
                                      ? Text(relative_sys[0].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0),
                                    textAlign: TextAlign.center,
                                  )
                                      : Text(
                                          "没有相关文章了",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0),
                                        )
                                ],
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Container(),
                          ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
