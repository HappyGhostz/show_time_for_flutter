import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/help/help_detail.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'package:show_time_for_flutter/widgets/html_widget.dart';
import 'package:show_time_for_flutter/modul/book/help/comments.dart';
import 'package:show_time_for_flutter/ui/book/search/book_search.dart';

/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */

class BookHelpDetailPage extends StatefulWidget {
  BookHelpDetailPage({
    Key key,
    @required this.helpId,
  }) : super(key: key);
  String helpId;

  @override
  State<StatefulWidget> createState() => BookHelpDetailPageState();
}

class BookHelpDetailPageState extends State<BookHelpDetailPage> {
  BookService _bookService = BookService();
  BookHelpDetail bookHelpDetail;
  Help helpDetail;
  List<Comments> comments = [];
  List<Comments> commentsReview = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    bookHelpDetail = await _bookService.getBookHelpDetail(widget.helpId);
    helpDetail = bookHelpDetail.help;
    CommentList commentList = await _bookService.getBestComments(widget.helpId);
    CommentList commentReview =
        await _bookService.getBookReviewComments(widget.helpId);
    comments = commentList.comments;
    commentsReview = commentReview.comments;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书荒互助区详情"),
      ),
      body: bookHelpDetail == null
          ? LoadingAndErrorView(
              layoutStatus: LayoutStatus.loading,
              noDataTab: () {
                loadData();
              },
              retryTab: () {
                loadData();
              },
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _buildBookHelpDetail(),
                ),
                comments.length == 0
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverToBoxAdapter(
                        child: buildTitleInfo(context, "仰望神评论"),
                      ),
                comments.length == 0
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        if ((index + 1) == comments.length * 2) {
                          return Container();
                        } else if ((index + 1) % 2 == 0) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                            child: new Divider(
                              height: 1.0,
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          final i = index ~/ 2;
                          var comment = comments[i];
                          return _buildCommentItem(comment);
                        }
                      }, childCount: comments.length * 2)),
                commentsReview.length == 0
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverToBoxAdapter(
                        child: buildTitleInfo(
                            context, "共${helpDetail.commentCount}条评论"),
                      ),
                commentsReview.length == 0
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        if ((index + 1) == commentsReview.length * 2) {
                          return Container();
                        } else if ((index + 1) % 2 == 0) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                            child: new Divider(
                              height: 1.0,
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          final i = index ~/ 2;
                          var comment = commentsReview[i];
                          return _buildReviewCommentItem(comment);
                        }
                      }, childCount: commentsReview.length * 2))
              ],
            ),
    );
  }

  Widget buildTitleInfo(BuildContext context, String info) {
    return Container(
      color: Color(0xffEEEEEE),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.0),
      child: Text(
        info,
        style: TextStyle(color: Color(0xffB2B2B2)),
      ),
    );
  }

  Widget _buildBookHelpDetail() {
    RegExp reg = new RegExp("《(.*?)》");
    Iterable<Match> matches = reg.allMatches(helpDetail.content);
    String replace = helpDetail.content;
    for (Match m in matches) {
      replace = replace.replaceAll(m.group(0),
          '<a href="${m.group(0)}" style="color:#FF0000;">${m.group(0)}</a>');
    }
    RegExp regimg = new RegExp("{{(.*?)}}");
    Iterable<Match> matchesImg = regimg.allMatches(replace);
    for (Match m in matchesImg) {
      var group = m.group(0);
      RegExp regimgSrc = new RegExp("http(.*?),");
      Iterable<Match> matchesImg = regimgSrc.allMatches(m.group(0));
      for (Match m in matchesImg) {
        var replaceAll = m.group(0).replaceAll(",", "");
        var encodeUrl = _bookService.decode(replaceAll);
        replace = replace.replaceAll(group,
          '<img src="$encodeUrl"  alt="" />');
      }


    }
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: ImageUtils.showFadeImageForSize(
                    IMG_BASE_URL + helpDetail.author.avatar,
                    50.0,
                    50.0,
                    BoxFit.cover),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        helpDetail.author.nickname,
                        style:
                            TextStyle(color: Color(0xffA58D5E), fontSize: 13.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      StringUtils.getDescriptionTimeFromDateString(
                          helpDetail?.created),
                      style:
                          TextStyle(color: Color(0xffB2B2B2), fontSize: 13.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(
              helpDetail.title,
              style: TextStyle(color: Color(0xff212121), fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child:
//            Html(data: content)
                HtmlView(
                    content: replace,
                    onTapLink: (String href) {
                      print("href:$href");
                      var replaceAll = href.replaceAll("《", "");
                      var key = replaceAll.replaceAll("》", "");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return BookSearchPage(searchKey:key,);
                      }));
                    }),
          ),
          Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Chip(
                    label: new Text(
                      "同感",
                      style: TextStyle(color: Color(0xffFF4081)),
                    ),
                    backgroundColor: Colors.white,
                    shape: new StadiumBorder(
                        side: BorderSide(color: Color(0xffFF4081))),
                  ),
                  onTap: () {},
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey)),
                      child: Icon(
                        Icons.share,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey)),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comments comment) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: ImageUtils.showFadeImageForSize(
                IMG_BASE_URL + comment.author.avatar, 35.0, 35.0, BoxFit.cover),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${comment.floor}楼 ",
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xffB2B2B2)),
                        ),
                        Text(
                          "${comment.author.nickname}",
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xffA58D5E)),
                        ),
                        Text(
                          "lv.${comment.author.lv}",
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xffA58D5E)),
                        ),
                      ],
                    ),
                    Container(
                      child: Text("💗${comment.likeCount}次同感",style: TextStyle(color:  Color(0xffB2B2B2),fontSize: 13.0),),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "${comment.content}楼 ",
                    style: TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
  Widget _buildReviewCommentItem(Comments comment) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: ImageUtils.showFadeImageForSize(
                IMG_BASE_URL + comment.author.avatar, 35.0, 35.0, BoxFit.cover),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${comment.floor}楼 ",
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xffB2B2B2)),
                        ),
                        Text(
                          "${comment.author.nickname}",
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xffA58D5E)),
                        ),
                        Text(
                          "lv.${comment.author.lv}",
                          style: TextStyle(
                              fontSize: 13.0, color: Color(0xffA58D5E)),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(StringUtils.getDescriptionTimeFromDateString(comment?.created),style: TextStyle(color:  Color(0xffB2B2B2),fontSize: 13.0),),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "${comment.content}",
                    style: TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                  ),
                ),
                comment.replyTo==null?Container():Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "回复${comment.replyTo.author.nickname} ${comment.replyTo.floor}楼 ",
                    style: TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
