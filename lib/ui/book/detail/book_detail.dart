import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/detail/book_detail.dart';
import 'package:show_time_for_flutter/modul/book/detail/hot_review.dart';
import 'package:show_time_for_flutter/modul/book/detail/recommend_list.dart';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:show_time_for_flutter/ui/book/read/read_page.dart';
import 'package:show_time_for_flutter/ui/book/detail/book_recommends_detail.dart';
import 'package:show_time_for_flutter/ui/book/community/book_help.dart';
import 'package:show_time_for_flutter/ui/book/community/book_talk.dart';

/**
 * @author zcp
 * @date 2019/4/18
 * @Description
 */
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

class BookDetailPage extends StatefulWidget {
  BookDetailPage({
    Key key,
    @required this.bookId,
  }) : super(key: key);
  String bookId;

  @override
  State<StatefulWidget> createState() => BookDetailPageState();
}

class BookDetailPageState extends State<BookDetailPage> {
  BookService _bookService = BookService();
  BookModel _bookModel = BookModel();
  BookDetail bookDetail;
  BookHotReview bookHotReview;
  BookRecommends bookRecommends;
  List<Reviews> reviews;
  List<Booklists> booklists;
  bool isExpand = false;

  bool isSaveBook = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    bookDetail = await _bookService.getBookDetail(widget.bookId);
    bookHotReview = await _bookService.getBookHotReview(widget.bookId);
    bookRecommends = await _bookService.getBookRecommendList(widget.bookId);
    Books bookByCondition = await _bookModel.getBookByCondition(widget.bookId);
    if (bookByCondition != null && bookByCondition.bookId == widget.bookId) {
      isSaveBook = true;
    }
    reviews = bookHotReview.reviews;
    booklists = bookRecommends.booklists;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "书籍详情",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: bookDetail == null
          ? _buildLoadError()
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _buildBookDetail(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Color(0xffeeeeee),
                    height: 10.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _builderTopComments(),
                ),
                (bookHotReview == null || reviews == null)
                    ? SliverToBoxAdapter(
                        child: Container(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        if ((index + 1) == reviews.length * 2) {
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
                          var review = reviews[i];
                          return _buildHotReviewItem(review);
                        }
                      }, childCount: reviews.length * 2)),
                SliverToBoxAdapter(
                  child: Container(
                    color: Color(0xffeeeeee),
                    height: 10.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildJumpCommunity(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Color(0xffeeeeee),
                    height: 10.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                booklists == null
                    ? SliverToBoxAdapter(
                        child: Center(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        if ((index + 1) == booklists.length * 2) {
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
                          var booklist = booklists[i];
                          return _buildRecommendBookItem(booklist);
                        }
                      }, childCount: booklists.length * 2))
              ],
            ),
    );
  }

  Widget _buildLoadError() {
    return LoadingAndErrorView(
      layoutStatus: LayoutStatus.loading,
      noDataTab: () {
        loadData();
      },
      retryTab: () {
        loadData();
      },
    );
  }

  Widget _buildBookDetail() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _builderHead(),
          _builderAddOrRead(),
          builderDivider(EdgeInsets.all(10.0), 2.0, Color(0xffE3E3E3)),
          _builderBookHeat(),
          builderDivider(EdgeInsets.all(10.0), 2.0, Color(0xffE3E3E3)),
          (bookDetail.tags == null && bookDetail.tags.length == 0)
              ? Container()
              : builerTags(),
          builderDivider(EdgeInsets.all(10.0), 2.0, Color(0xffE3E3E3)),
          _builderBookIntroduction(),
        ],
      ),
    );
  }

  Widget builderDivider(EdgeInsetsGeometry margin, double height, Color color) {
    return margin == null
        ? Container(
            child: Divider(
              height: height,
              color: color,
            ),
          )
        : Container(
            margin: margin,
            child: Divider(
              height: height,
              color: color,
            ),
          );
  }

  Widget _builderHead() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ImageUtils.showFadeImageForSize(
            IMG_BASE_URL + bookDetail.cover, 75.0, 55.0, BoxFit.cover),
        Expanded(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 4.0, bottom: 10.0),
                child: Text(
                  bookDetail.title,
                  style: TextStyle(fontSize: 16.0, color: Color(0xff212121)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "${bookDetail.author} | ",
                      style:
                          TextStyle(fontSize: 13.0, color: Color(0xffDE6014)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "${bookDetail.cat} | ",
                      style:
                          TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "${StringUtils.formatWordCount(bookDetail.wordCount)}",
                      style:
                          TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4.0, bottom: 10.0),
                child: Text(
                  "${StringUtils.getDescriptionTimeFromDateString(bookDetail.updated)}",
                  style: TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }

  Widget _builderAddOrRead() {
    return new Builder(builder: (BuildContext context) {
      return Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    _saveBook(context);
                  },
                  child: isSaveBook
                      ? Container(
                          margin: EdgeInsets.only(right: 5.0),
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                              color: Color(0xff959595),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              Text(
                                "不追了",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(right: 5.0),
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                "追更新",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )),
            ),
            Expanded(
                child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    Text(
                      "开始阅读",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  SystemChrome.setEnabledSystemUIOverlays(
                      [SystemUiOverlay.bottom]);
                  Books book = Books(
                      bookDetail.bookId,
                      bookDetail.cover,
                      bookDetail.author,
                      bookDetail.majorCate,
                      bookDetail.title,
                      "",
                      bookDetail.contentType,
                      bookDetail.allowMonthly,
                      bookDetail.hasCp,
                      bookDetail.latelyFollower,
                      0.0,
                      bookDetail.updated,
                      bookDetail.chaptersCount,
                      bookDetail.lastChapter);
                  return ReadPage(book: book);
                }));
              },
            )),
          ],
        ),
      );
    });
  }

  Widget _builderBookHeat() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBookHeeatItem("追书人数", bookDetail.latelyFollower.toString()),
          _buildBookHeeatItem(
              "读者留存率",
              bookDetail.retentionRatio == null
                  ? "-"
                  : bookDetail.retentionRatio),
          _buildBookHeeatItem(
              "日更新字数",
              bookDetail.serializeWordCount < 0
                  ? "-"
                  : bookDetail.serializeWordCount.toString()),
        ],
      ),
    );
  }

  Widget _buildBookHeeatItem(String title, String content) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 13.0, color: Color(0xff727272)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          content,
          style: TextStyle(color: Color(0xff212121), fontSize: 15.0),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }

  Color getColor() {
    var color = colors[Random().nextInt(colors.length - 1)];
    return color;
  }

  Widget builerTags() {
    return Wrap(
      spacing: 4.0,
      alignment: WrapAlignment.start,
      children: _builderTagView(),
    );
  }

  List<Widget> _builderTagView() {
    List<Widget> widgets = [];

    for (int i = 0; i < bookDetail.tags.length; i++) {
      var tag = bookDetail.tags[i];
      var color = getColor();
      GestureDetector gestureDetector = new GestureDetector(
        child: Chip(
          label: new Text(
            tag,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: color,
          shape: RoundedRectangleBorder(side: BorderSide(color: color)),
        ),
        onTap: () {
//          _tagClick(i);
        },
      );
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget _builderBookIntroduction() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpand = !isExpand;
        });
      },
      child: !isExpand
          ? Text(
              bookDetail.longIntro,
              style: TextStyle(fontSize: 15.0, color: Color(0xff212121)),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            )
          : Text(
              bookDetail.longIntro,
              style: TextStyle(fontSize: 15.0, color: Color(0xff212121)),
            ),
    );
  }

  Widget _builderTopComments() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookTalkTabPage(bookId: bookDetail.bookId,bookTitle: bookDetail.title,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "热门书评",
              style: TextStyle(color: Color(0xff212121), fontSize: 15.0),
            ),
            Text(
              "更多",
              style: TextStyle(color: Color(0xff727272), fontSize: 15.0),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHotReviewItem(Reviews review) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookHelpDetailPage(helpId: review.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              child: ClipOval(
                child: ImageUtils.showFadeImageForSize(
                    IMG_BASE_URL + review.author.avatar,
                    55.0,
                    55.0,
                    BoxFit.cover),
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
                          "${review?.author?.nickname}lv.${review?.author?.lv} ",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Color.fromARGB(225, 165, 141, 61)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          review?.title,
                          style: TextStyle(color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: _buildStarCount(review),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "${review?.content}",
                          style:
                          TextStyle(fontSize: 13.0, color: Color(0xff727272)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 5.0),
                                child: Image.asset(
                                  "assets/images/post_item_like.png",
                                  height: 13,
                                  width: 13,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${review?.helpful?.yes}",
                                  style: TextStyle(
                                      fontSize: 13.0, color: Color(0xffB2B2B2)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStarCount(Reviews review) {
    List<Widget> widgets = [];
    for (int i = 0; i < 5; i++) {
      Icon icon;
      if (i <= review.rating - 1) {
        icon = Icon(
          Icons.star,
          color: Color(0xffF19149),
          size: 13.0,
        );
      } else {
        icon = Icon(
          Icons.star_border,
          color: Color(0xffF19149),
          size: 13.0,
        );
      }
      widgets.add(icon);
    }
    return widgets;
  }

  Widget _buildJumpCommunity() {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookTalkTabPage(bookId: bookDetail.bookId,bookTitle: bookDetail.title,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${bookDetail.title}的社区",
                          style: TextStyle(color: Color(0xff212121), fontSize: 15.0),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "共有${bookDetail.postCount}个帖子",
                          style: TextStyle(color: Color(0xff727272), fontSize: 13.0),
                        ),
                      ),
                    ],
                  ),
                )),
            Center(
              child: Icon(
                Icons.navigate_next,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendBookItem(Booklists booklist) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BookRecommendDetail(
            bookId: booklist.id,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Center(
              child: ImageUtils.showFadeImageForSize(
                  IMG_BASE_URL + booklist?.cover, 60.0, 45.0, BoxFit.cover),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      booklist.title,
                      style:
                          TextStyle(color: Color(0xff212121), fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      booklist.author,
                      style:
                          TextStyle(color: Color(0xff727272), fontSize: 13.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      booklist.desc,
                      style:
                          TextStyle(color: Color(0xff727272), fontSize: 13.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "共${booklist.bookCount}本书",
                          style: TextStyle(
                              color: Color(0xffB2B2B2), fontSize: 13.0),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          " | ${booklist.collectorCount}人收藏",
                          style: TextStyle(
                              color: Color(0xffB2B2B2), fontSize: 13.0),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _saveBook(BuildContext context) async {
    Books book = Books(
        bookDetail.bookId,
        bookDetail.cover,
        bookDetail.author,
        bookDetail.majorCate,
        bookDetail.title,
        "",
        bookDetail.contentType,
        bookDetail.allowMonthly,
        bookDetail.hasCp,
        bookDetail.latelyFollower,
        0.0,
        bookDetail.updated,
        bookDetail.chaptersCount,
        bookDetail.lastChapter);
    if (isSaveBook) {
      var count = await _bookModel.deleteSelectChannel(book);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("已从书架移除！"),
        duration: Duration(milliseconds: 300),
      ));
      if (count != 0) {
        isSaveBook = false;
        setState(() {});
      }
    } else {
      var books = await _bookModel.insertSelectChannel(book);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("已加入书架！"),
        duration: Duration(milliseconds: 300),
      ));
      if (books.bookId == bookDetail.bookId) {
        isSaveBook = true;
        setState(() {});
      }
    }
  }
}
