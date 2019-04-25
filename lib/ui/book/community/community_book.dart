import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/book_community.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'package:show_time_for_flutter/ui/book/community/book_help.dart';

/**
 * @author zcp
 * @date 2019/3/30
 * @Description
 */
class BookCommunityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookCommunityPageState();
}

class BookCommunityPageState extends State<BookCommunityPage> with AutomaticKeepAliveClientMixin{
  BookService _bookService = BookService();
  ScrollController _scrollController = new ScrollController();
  int start = 0;
  List<Helps> helps = [];
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    loadData();
  }

  Future<void> loadData() async {
    start = 0;
    BookCommunity bookCommunity =
        await _bookService.getBookHelpList(start.toString());
    helps = bookCommunity.helps;
    start = start + helps.length;
    setState(() {});
  }

  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      BookCommunity bookCommunity =
          await _bookService.getBookHelpList(start.toString());
      var helpsMore = bookCommunity.helps;
      start = start + helpsMore.length;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (helpsMore.isEmpty) {
          double edge = 72;
          double offsetFromBottom = _scrollController.position.maxScrollExtent -
              _scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            _scrollController.animateTo(
                _scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
        }
        setState(() {
          helps.addAll(helpsMore);
          isPerformingRequest = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (helps.length == 0) {
      return LoadingAndErrorView(
        layoutStatus: LayoutStatus.loading,
        noDataTab: () {
          loadData();
        },
        retryTab: () {
          loadData();
        },
      );
    } else {
      return new RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: loadData,
        child: ListView.separated(
          itemCount: helps.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == helps.length) {
              return _buildLoadMore();
            } else {
              return _BuildListItem(index);
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Divider(
              height: 1.0,
              color: Colors.grey,
            );
          },
        ),
      );
    }
  }

  Widget _BuildListItem(int index) {
    var help = helps[index];
    var latelyUpdate = "";
    int visibilty = 0;
    if (StringUtils.getDescriptionTimeFromDateString(help?.updated)
        .isNotEmpty) {
      latelyUpdate =
          StringUtils.getDescriptionTimeFromDateString(help?.updated) + ":";
    }
    if (help?.state == "distillate") {
      visibilty = 1;
    } else if (help?.state == "hot" || help?.state == "focus") {
      visibilty = 2;
    } else if (help?.state == "normal") {
      visibilty = 3;
    }
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookHelpDetailPage(helpId: help.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: ClipOval(
                child: ImageUtils.showFadeImageForSize(
                    IMG_BASE_URL + help.author.avatar, 55.0, 55.0, BoxFit.cover),
              ),
            ),
            Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${help?.author?.nickname}lv.${help?.author?.lv} ",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Color.fromARGB(225, 165, 141, 61)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          help?.title,
                          style: TextStyle(color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              Container(

                                child: Image.asset(
                                  "assets/images/ic_notif_post.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${help?.commentCount}",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color.fromARGB(225, 178, 178, 178)),
                                ),
                              ),
                              visibilty == 3
                                  ? Container(
                                margin: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  latelyUpdate,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color.fromARGB(
                                          225, 178, 178, 178)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                                  : Container()
                            ],
                          )),
                    ],
                  ),
                )),
            Expanded(
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      visibilty == 2
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          color: Colors.red,
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/ic_topic_hot.png",
                              height: 16.0,
                              width: 16.0,
                            ),
                            Text(
                              "热门",
                              style:
                              TextStyle(color: Colors.white, fontSize: 8.0),
                            )
                          ],
                        ),
                      )
                          : Container(),
                      visibilty == 1
                          ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          color: Colors.red,
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/ic_topic_distillate.png",
                              height: 16.0,
                              width: 16.0,
                            ),
                            Text(
                              "精品",
                              style:
                              TextStyle(color: Colors.white, fontSize: 8.0),
                            )
                          ],
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMore() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
