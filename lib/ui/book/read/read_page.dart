import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/read/chapters.dart';
import 'package:show_time_for_flutter/modul/book/read/chapter_body.dart';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/ui/book/read/chapter_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const EventChannel batterEventChannel = EventChannel('local/battery');
  static const EventChannel timerEventChannel = EventChannel('local/time');
  BookService _bookService = BookService();
  int currentChapter = 0;
  int currentIndex = 1;
  List<Chapters> chapters;
  String body;

  String title;
  List<String> bodys = [];
  double maxWidth = 0;
  double maxHeight = 0;
  GlobalKey key = GlobalKey();

  bool isNext = false;
  bool isPrevious = false;
  double batteryValue = 0;
  String timerValue="";

  @override
  void initState() {

    super.initState();
    var date = new DateTime.now();
    timerValue = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
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
    batterEventChannel.receiveBroadcastStream().listen(_onBatteryEvent);
    timerEventChannel.receiveBroadcastStream().listen(_onTimerEvent);
    if(!isNext&&!isPrevious){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      currentChapter = prefs.getInt("${widget.book.id}-chapter");
      currentIndex = prefs.getInt("${widget.book.id}-index");
    }
    if(currentChapter==null){
      currentChapter=0;
    }
    if(currentIndex==null){
      currentIndex=1;
    }
    if (widget.book != null) {
      ChapterBook book = await _bookService.getBook(widget.book.id);
      chapters = book.mixToc.chapters;
      loadChapterBody();
    } else {
      print("readpage null");
    }
  }

  _onBatteryEvent(Object event) {
    var battery = event.toString();
    setState(() {
      batteryValue = double.parse(battery);
    });
  }

  _onTimerEvent(Object event) {
    var timer = event.toString();
    setState(() {
      timerValue = timer;
    });
  }

  loadChapterBody() async {
    ChapterBody chapterBody =
        await _bookService.getChapterBody(chapters[currentChapter].link);
    body = chapterBody.chapter.body;
    title = chapters[currentChapter].title;
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
                        padding: EdgeInsets.only(top: 4.0, left: 16.0),
                      ),
                      Expanded(
                          flex: 1,
                          child: BookPaginationPage(
                            key: key,
                            chapterInfo: body,
                            currentChapter: currentChapter,
                            currentIndex: currentIndex,
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            isNext: isNext,
                            isPrevious: isPrevious,
                            bookId: widget.book.id,
                            nextChaperListener: () {
                              _buildNextChapter();
                            },
                            previousChapterListener: () {
                              _buildPreviousChapter();
                            },
                          )),
                      Container(
                        height: 25.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 20.0,
                              width: 30.0,
                              child: SizedBox(
                                height: 20.0,
                                width: 30.0,
                                child:Theme(data: ThemeData(
                                 primarySwatch: Colors.grey
                                ), child: LinearProgressIndicator(
                                  value: batteryValue / 100,
                                )) ,
                              ),
                              margin: EdgeInsets.only(left: 10.0,bottom: 2.0,top: 2.0),
                              padding: EdgeInsets.only(top: 5.0,right: 5.0,bottom: 4.0,left: 3.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/new_battery_bg.9.png"),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              child: Text("${(((currentChapter+1)/chapters.length)*100).toStringAsFixed(2)}%"),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text("$timerValue"),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ));
  }

  _buildNextChapter() {
    currentChapter++;
    isNext = true;
    isPrevious = false;
    loadData();
  }

  _buildPreviousChapter() {
    currentChapter--;
    isPrevious = true;
    isNext = false;
    loadData();
  }
}
