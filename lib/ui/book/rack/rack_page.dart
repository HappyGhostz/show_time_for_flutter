import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'package:show_time_for_flutter/ui/book/read/read_page.dart';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/event/event_bus.dart';
import 'package:show_time_for_flutter/ui/book/detail/book_detail.dart';

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
  BookModel _bookModel=  BookModel();
  List<Books> books = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    books = await _bookModel.getSaveBooks();
    if(books.length==0){
      BookRecommend bookRecommend = await _bookService.getRecomendBooks();
      books = bookRecommend.books;
      await _bookModel.insertSomeChannel(books);
    }
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
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
          return ReadPage(book: book);
        }));
      },
      onLongPress: (){
        showDialog(context: context,
        builder: (BuildContext context){
          return _showDialogItem(context,book,index);
        });
      },
      child: Container(
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
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _showDialogItem(BuildContext context,Books book,int index) {
    return SimpleDialog(
      title: Text("${book.title}"),
      children: <Widget>[
        Container(
          child: FlatButton(onPressed: () {
            setOne(book);

            setState(() {
            });
            Navigator.pop(context, "后面50章");
          }, child: Text("置顶")),
        ),
        Container(
          child: FlatButton(onPressed: () {
            Navigator.of(context).pop();
            _toBookDetail(book);
          }, child: Text("书籍详情")),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              download(book);
              Navigator.of(context).pop();
            },
            child: Text("缓存全部"),
          ),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              deleteOne(book);
              Navigator.of(context).pop();
            },
            child: Text("删除"),
          ),
        ),
      ],
    );
  }

  void deleteOne(Books book)async {
    books.remove(book);
    var count = await _bookModel.deleteAllBooks();
    if(count!=0){
      await _bookModel.insertSomeChannel(books);
      setState(() {
      });
    }
  }

  void setOne(Books book) async{
    books.remove(book);
    books.insert(0, book);
    var count = await _bookModel.deleteAllBooks();
    if(count!=0){
      await _bookModel.insertSomeChannel(books);
    }
  }

  void download(Books book) async{
    var chapterBook = await _bookService.getBook(book.bookId);
    var chapters = chapterBook.mixToc.chapters;
     _bookService.downloadChapter(eventBus,
        book.bookId, chapters, 0, chapters.length-1);
  }

  void _toBookDetail(Books book) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return BookDetailPage(bookId: book.bookId,);
    }));
  }
}
