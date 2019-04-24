import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/detail/recommends_detail.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/book/detail/book_detail.dart';

/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */
class BookRecommendDetail extends StatefulWidget {
  BookRecommendDetail({
    Key key,
    @required this.bookId,
  }) : super(key: key);
  String bookId;

  @override
  State<StatefulWidget> createState() => BookRecommendsDetailState();
}

class BookRecommendsDetailState extends State<BookRecommendDetail> {
  BookService _bookService = BookService();
  BookRecommendsDetail _bookRecommendsDetail;
  List<Books> books;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _bookRecommendsDetail =
        await _bookService.getRecommendBookListDetail(widget.bookId);
    books = _bookRecommendsDetail.bookList.books;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "书单详情",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _bookRecommendsDetail == null
          ? _buildLoadError()
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _buildBookDetail(),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  var bookItem = books[index];
                  return _buildBookItem(bookItem);
                }, childCount: books.length)),
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
      color: Colors.white,
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: Text(
              "${_bookRecommendsDetail.bookList.title}",
              style: TextStyle(color: Color(0xff212121), fontSize: 18.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: Text(
              "${_bookRecommendsDetail.bookList.desc}",
              style: TextStyle(color: Color(0xff727272), fontSize: 13.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: ClipOval(
                      child: ImageUtils.showFadeImageForSize(
                          IMG_BASE_URL +
                              _bookRecommendsDetail.bookList.author.avatar,
                          55.0,
                          55.0,
                          BoxFit.cover),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5.0, left: 10.0),
                    child: Text(
                      "创建自 ",
                      style:
                          TextStyle(color: Color(0xff727272), fontSize: 15.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5.0, left: 10.0),
                    child: Text(
                      _bookRecommendsDetail.bookList.author.nickname,
                      style:
                          TextStyle(color: Color(0xffA58D5E), fontSize: 15.0),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                child: Chip(
                  label: new Text(
                    "分享",
                    style: TextStyle(color: Color(0xffFF4081)),
                  ),
                  backgroundColor: Colors.white,
                  shape: new StadiumBorder(
                      side: BorderSide(color: Color(0xffFF4081))),
                ),
                onTap: () {},
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBookItem(Books bookItem) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return BookDetailPage(bookId: bookItem.book.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: ImageUtils.showFadeImageForSize(
                          IMG_BASE_URL + bookItem.book.cover,
                          60.0,
                          45.0,
                          BoxFit.cover),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Text(
                            bookItem.book.title,
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xff212121)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Text(
                            "${bookItem.book.author}",
                            style: TextStyle(
                                fontSize: 13.0, color: Color(0xffDE6014)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "${bookItem.book.latelyFollower}人在追",
                                style: TextStyle(
                                    fontSize: 13.0, color: Color(0xffB2B2B2)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                " | ${bookItem.book.wordCount / 10000}万字",
                                style: TextStyle(
                                    fontSize: 13.0, color: Color(0xffB2B2B2)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Divider(
                  height: 2.0,
                  color: Color(0xffeeeeee),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  bookItem.book.longIntro,
                  style: TextStyle(
                    color: Color(0xff727272),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
