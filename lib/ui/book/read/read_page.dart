import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/read/chapters.dart';
import 'package:show_time_for_flutter/modul/book/read/chapter_body.dart';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/ui/book/read/chapter_info.dart';

/**
 * @author zcp
 * @date 2019/3/31
 * @Description
 */
class ReadPage extends StatefulWidget {
  ReadPage({
    Key key,
    @required this.book,
  }) : super(key: key);
  Books book;

  @override
  State<StatefulWidget> createState() => ReadPageState();
}

class ReadPageState extends State<ReadPage> {
  BookService _bookService = BookService();
  int currentChapter = 1;
  List<Chapters> chapters;
  String body;

  String title;
  List<String> bodys = [];
  double maxWidth = 0;
  double maxHeight = 0;
  GlobalKey key = GlobalKey();

  bool isNext=false;
  bool isPrevious =false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    super.dispose();
  }

  loadData() async {
    if (widget.book != null) {
      ChapterBook book = await _bookService.getBook(widget.book.id);
      chapters = book.mixToc.chapters;
      loadChapterBody();
    } else {
      print("readpage null");
    }
  }

  loadChapterBody() async {
    ChapterBody chapterBody =
        await _bookService.getChapterBody(chapters[currentChapter - 1].link);
    body = chapterBody.chapter.body;
    title = chapters[currentChapter - 1].title;
    body = "      " + body.replaceAll("\n", "\n     ");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width - 8.0;
    maxHeight = MediaQuery.of(context).size.height - 80.0;
    return Scaffold(
        body: body == null
            ? Container()
            : Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    constraints: BoxConstraints.expand(),
                    child: Image.asset(
                      "assets/images/background/bg11.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 16.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        padding: EdgeInsets.only(top: 4.0,left: 16.0),
                      ),
                      Expanded(
                          flex: 1,
                          child: BookPaginationPage(
                            key: key,
                            chapterInfo: body,
                            currentChapter: currentChapter,
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            isNext: isNext,
                            isPrevious: isPrevious,
                            nextChaperListener: (){
                              _buildNextChapter();
                            },
                            previousChapterListener: (){
                              _buildPreviousChapter();
                            },
                          )),
                      Container(
                          child: SizedBox(
                        height: 25,
                        child: Text(title),
                      ))
                    ],
                  ))
                ],
              ));
  }
  _buildNextChapter(){
    currentChapter++;
    isNext=true;
    isPrevious=false;
    loadData();
  }
  _buildPreviousChapter(){
    currentChapter--;
    isPrevious=true;
    isNext=false;
    loadData();
  }
}
