import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/category/category_bean.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/book/detail/book_detail.dart';
/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */

class BookCategoryDetail extends StatefulWidget {
  BookCategoryDetail({
    Key key,
    @required this.categoryName,
    @required this.categoryType,
    @required this.type,
  }) : super(key: key);
  String categoryName;
  String categoryType;
  String type;

  @override
  State<StatefulWidget> createState() => BookCategoryDetailState();
}

class BookCategoryDetailState extends State<BookCategoryDetail>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  BookService _bookService = BookService();
  BookCategorys _bookCategorys;
  List<Book> books = [];
  int start = 0;
  bool isPerformingRequest = false;
  String type = "";

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
    if (widget.type == "新书") {
      type = "new";
    } else if (widget.type == "热门") {
      type = "hot";
    } else if (widget.type == "口碑") {
      type = "reputation";
    } else if (widget.type == "完结") {
      type = "over";
    }
    start = 0;
    _bookCategorys = await _bookService.getBooksByCats(
        widget.categoryType, type, widget.categoryName, start);
    books = _bookCategorys.books;
    start = start + books.length;
    setState(() {});
  }

  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      BookCategorys bookCategorys = await _bookService.getBooksByCats(
          widget.categoryType, type, widget.categoryName, start);
      List<Book> booksMore = bookCategorys.books;
      start += booksMore.length;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (booksMore.isEmpty) {
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
          books.addAll(booksMore);
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
    if (books.length == 0) {
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
          itemCount: books.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == books.length) {
              return _buildLoadMore();
            } else {
              Book book = books[index];
              return _BuildListItem(book);
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

  @override
  bool get wantKeepAlive => true;

  Widget _BuildListItem(Book book) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return BookDetailPage(bookId: book.id,);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            ImageUtils.showFadeImageForSize(
                IMG_BASE_URL + book?.cover, 60.0, 45.0, BoxFit.cover),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(book.title,style: TextStyle(color: Color(0xff212121),fontSize: 16.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text("${book?.author == null? "未知" : book.author} | ${book?.majorCate == null?"未知": book.majorCate}",
                          style: TextStyle(color: Color(0xff727272),fontSize: 14.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text(book?.shortIntro ,
                          style: TextStyle(color: Color(0xff727272),fontSize: 14.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      ),
                      Text("${book?.latelyFollower}人在追 | ${book?.retentionRatio == null?"0": book.retentionRatio}读者留存",
                        style: TextStyle(color: Color(0xff727272),fontSize: 14.0),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
