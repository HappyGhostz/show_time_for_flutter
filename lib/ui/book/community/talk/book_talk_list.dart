import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'package:show_time_for_flutter/modul/book/help/discussion_list.dart';
import 'package:show_time_for_flutter/ui/book/community/book_help.dart';

/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */

class BookTalkDetailPage extends StatefulWidget{
  BookTalkDetailPage({
    Key key,
    @required this.bookId,
  }) : super(key: key);
  String bookId;
  @override
  State<StatefulWidget> createState() =>BookTalkDetailPageState();
}

class BookTalkDetailPageState extends State<BookTalkDetailPage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController = new ScrollController();
  BookService _bookService = BookService();
  Discussions _discussions;
  List<Posts> posts=[];
  bool isPerformingRequest = false;
  int start =0;
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
  Future<void>  loadData() async {
    start =0;
    _discussions = await _bookService.getBookDetailDisscussionList(widget.bookId,start,);
    posts = _discussions.posts;
    start+=posts.length;
    setState(() {
    });
  }
  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      Discussions discussions = await _bookService.getBookDetailDisscussionList(
          widget.bookId, start);
      List<Posts> postsMore = discussions.posts;
      start += postsMore.length;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (postsMore.isEmpty) {
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
          posts.addAll(postsMore);
          isPerformingRequest = false;
        });
      });
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (posts.length == 0) {
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
          itemCount: posts.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == posts.length) {
              return _buildLoadMore();
            } else {
              Posts post = posts[index];
              return _BuildListItem(post);
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
  Widget _buildLoadMore() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }
  Widget _BuildListItem(Posts post) {
    var latelyUpdate = "";
    int visibilty = 0;
    if (StringUtils.getDescriptionTimeFromDateString(post?.created)
        .isNotEmpty) {
      latelyUpdate =
          StringUtils.getDescriptionTimeFromDateString(post?.created) ;
    }
    if (post?.state == "distillate") {
      visibilty = 1;
    } else if (post?.state == "hot" || post?.state == "focus") {
      visibilty = 2;
    } else if (post?.state == "normal") {
      visibilty = 3;
    }
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookHelpDetailPage(helpId: post.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: ClipOval(
                child: ImageUtils.showFadeImageForSize(
                    IMG_BASE_URL + post.author.avatar, 55.0, 55.0, BoxFit.cover),
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
                          "${post?.author?.nickname}lv.${post?.author?.lv} ",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Color.fromARGB(225, 165, 141, 61)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          post?.title,
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
                                  "${post?.commentCount}",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color.fromARGB(225, 178, 178, 178)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Icon(Icons.favorite_border,size: 16.0,color: Colors.grey,),
                              ),
                              Container(
                                child: Text(
                                  "${post?.commentCount}",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xffB2B2B2)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
            Expanded(
              flex: 2,
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
                  ),
                ))
          ],
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}