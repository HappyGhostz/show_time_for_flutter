import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';

/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */
class BookRackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookRackPageState();
}

class BookRackPageState extends State<BookRackPage> with AutomaticKeepAliveClientMixin{
  BookService _bookService = BookService();
  List<Books> books = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    BookRecommend bookRecommend = await _bookService.getRecomendBooks();
    books = bookRecommend.books;
    setState(() {});
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
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildRecommendBookItem(index);
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

  Widget _buildRecommendBookItem(int index) {
    var book = books[index];
    var lastUpdata = "";
    if (StringUtils.getDescriptionTimeFromDateString(book.updated).isNotEmpty) {
      lastUpdata =
          StringUtils.getDescriptionTimeFromDateString(book.updated) + ":";
    }
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
            child: ImageUtils.showFadeImageForSize(
                IMG_BASE_URL + book.cover, 60.0, 45.0, BoxFit.cover),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    book.title,
                    style: TextStyle(
                        color: Color.fromARGB(255, 33, 33, 33), fontSize: 16.0),
                  ),
                ),
                Container(
                  child: Text(
                    lastUpdata + book.lastChapter,
                    style: TextStyle(
                        color: Color.fromARGB(
                          255,
                          114,
                          114,
                          114,
                        ),
                        fontSize: 12.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
