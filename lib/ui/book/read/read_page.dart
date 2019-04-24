import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/read/chapters.dart';
import 'package:show_time_for_flutter/modul/book/read/chapter_body.dart';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/ui/book/read/chapter_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:screen/screen.dart';
import 'package:show_time_for_flutter/modul/book/read/book_mark.dart';
import 'package:show_time_for_flutter/ui/book/read/chapter_list.dart';
import 'package:show_time_for_flutter/utils/animation_router.dart';
//import 'package:event_bus/event_bus.dart';
import 'package:show_time_for_flutter/event/event_bus.dart';
import 'package:show_time_for_flutter/event/book_download_event.dart';

/**
 * @author zcp
 * @date 2019/3/31
 * @Description
 */
List<String> readBgs = [
  "assets/images/background/bg1.png",
  "assets/images/background/bg2.png",
  "assets/images/background/bg3.png",
  "assets/images/background/bg4.png",
  "assets/images/background/bg5.png",
  "assets/images/background/bg6.png",
  "assets/images/background/bg7.jpg",
  "assets/images/background/bg8.png",
  "assets/images/background/bg9.png",
  "assets/images/background/bg10.png",
  "assets/images/background/bg11.png",
  "assets/images/background/bg12.jpg",
  "assets/images/background/bg13.jpg",
];

class ReadPage extends StatefulWidget {
  ReadPage({
    Key key,
    @required this.book,
  }) : super(key: key);
  Books book;

  @override
  State<StatefulWidget> createState() => ReadPageState();
}

class ReadPageState extends State<ReadPage> with TickerProviderStateMixin {
  static const EventChannel batterEventChannel = EventChannel('local/battery');
  static const EventChannel timerEventChannel = EventChannel('local/time');
//  EventBus eventBus = new EventBus();
  StreamSubscription _timerSubscription = null;
  StreamSubscription _batterySubscription = null;
  BookService _bookService = BookService();
  ChapterBook book;
  int currentChapter = 0;
  int currentIndex = 1;
  int currentThemeIndex = 0;
  List<Chapters> chapters;
  List<String> bookMarkJsons = [];
  List<BookMark> bookMarks = [];
  String body;

  String title;
  List<String> bodys = [];
  double maxWidth = 0;
  double maxHeight = 0;
  GlobalKey key = GlobalKey();

  bool isNext = false;
  bool isPrevious = false;
  double batteryValue = 0;
  String timerValue = "";
  String downloadInfo = "";
  AnimationController controller;
  Animation<double> animate;
  Animation<double> animateOPacity;
  bool isForward = true;
  bool initValue = true;
  bool _checkboxSelectedVolumPage = false;
  bool _checkboxSelectedAutoBrightness = false;
  bool isShowAaSetting = false;
  bool isShowReadMark = false;
  bool isShowDownloadInfo = false;
  bool isNight = false;
  double currentTextSize = 16.0;
  double currentBrightness = 0.5;
  SharedPreferences prefs;
  TextStyle textStyle = new TextStyle(
    color: Color(0xFF000000),
    fontSize: 16.0,
//    fontWeight: FontWeight.w500,
    height: 1,
  );

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    CurvedAnimation curvedAnimation =
    CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animate = Tween(begin: 0.0, end: 60.0).animate(curvedAnimation);
    animateOPacity = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);
    animate.addListener(() {
      initFalse();
      setState(() {});
    });
    animateOPacity.addListener(() {
      initFalse();
      setState(() {});
    });
    super.initState();
    var date = new DateTime.now();

    timerValue =
    "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(
        2, '0')}";
    loadData();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    controller.dispose();
    _disableTimer();
    _disableBattery();
    super.dispose();
  }

  loadData() async {
    if (_batterySubscription == null) {
      _batterySubscription =
          batterEventChannel.receiveBroadcastStream().listen(_onBatteryEvent);
    }
    if (_timerSubscription == null) {
      _timerSubscription =
          timerEventChannel.receiveBroadcastStream().listen(_onTimerEvent);
    }
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    initSetting();
    if (currentChapter == null) {
      currentChapter = 0;
    }
    if (currentIndex == null) {
      currentIndex = 1;
    }
    if (widget.book != null) {
      book = await _bookService.getBook(widget.book.bookId);
      chapters = book.mixToc.chapters;
      loadChapterBody();
    } else {
      print("readpage null");
    }
    eventBus.on<ChapterEvent>().listen((event){
      print(event.title);
      initFalse();
      setState(() {
        downloadInfo=event.title;
        if(downloadInfo=="缓存完成!"){
          isShowDownloadInfo=false;
        }
      });
    });
  }

  void initSetting() {
    if (!isNext && !isPrevious) {
      currentChapter = prefs.getInt("${widget.book.bookId}-chapter");
      currentIndex = prefs.getInt("${widget.book.bookId}-index");
    }
    currentThemeIndex = prefs.getInt("book-theme");
    if (currentThemeIndex == null ||
        currentThemeIndex > readBgs.length - 1 ||
        currentThemeIndex < 0) {
      currentThemeIndex = 1;
    }
    _checkboxSelectedVolumPage = prefs.getBool("book-volumeFlip");
    if (_checkboxSelectedVolumPage == null) {
      _checkboxSelectedVolumPage = false;
    }
    _checkboxSelectedAutoBrightness = prefs.getBool("book-autobrightness");
    if (_checkboxSelectedAutoBrightness == null) {
      _checkboxSelectedAutoBrightness = true;
    }
    var markJsons = prefs.getStringList("book—marks");
    if (bookMarks.isEmpty && markJsons != null) {
      for (int i = 0; i < markJsons.length; i++) {
        var markJson = markJsons[i];
        var bookMark = BookMark.fromJson(jsonDecode(markJson));
        bookMarks.add(bookMark);
      }
    }
    currentTextSize = prefs.getDouble("book-textsize");
    if (currentTextSize == null) {
      currentTextSize = 16.0;
    }
    isNight = prefs.getBool("book-night");
    if (isNight == null) {
      isNight = false;
    }
    textStyle = isNight
        ? TextStyle(
      color: Colors.white30,
      fontSize: currentTextSize,
//      fontWeight: FontWeight.w500,
      height: 1,
    )
        : TextStyle(
      color: Color(0xFF000000),
      fontSize: currentTextSize,
//      fontWeight: FontWeight.w500,
      height: 1,
    );
  }

  _onBatteryEvent(Object event) {
    var battery = event.toString();
    setState(() {
      initFalse();
      batteryValue = double.parse(battery);
    });
  }

  _onTimerEvent(Object event) {
    var timer = event.toString();
    setState(() {
      initFalse();
      timerValue = timer;
    });
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _disableBattery() {
    if (_batterySubscription != null) {
      _batterySubscription.cancel();
      _batterySubscription = null;
    }
  }

  loadChapterBody() async {
    var chapter = await _bookService.loadChapterFile(widget.book.bookId, currentChapter);
    if (chapter!="") {
      print("local");
      if(chapter.contains("|")){
        var list = chapter.split("|");
        title = list[0];
        body = "      " +list[1].replaceAll("\n", "\n     ");
      }else{
        title="";
        body = "      " +chapter.replaceAll("\n", "\n     ");
      }

    }else{
      ChapterBody chapterBody =
      await _bookService.getChapterBody(chapters[currentChapter].link);
      body = chapterBody.chapter.body;
      title = chapters[currentChapter].title;
      body = "      " + body.replaceAll("\n", "\n     ");
      print("online");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery
        .of(context)
        .size
        .width - 8.0;
    maxHeight = MediaQuery
        .of(context)
        .size
        .height - 80.0;
    return Scaffold(
        body: body == null
            ? Container()
            : Stack(
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              constraints: BoxConstraints.expand(),
              child: isNight
                  ? Image.asset(
                "assets/images/background/bg12.jpg",
                fit: BoxFit.cover,
              )
                  : Image.asset(
                readBgs[currentThemeIndex],
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
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                              isNight ? Colors.white30 : Colors.black87),
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
                          isInit: initValue,
                          isPrevious: isPrevious,
                          bookId: widget.book.bookId,
                          textStyle: textStyle,
                          nextChaperListener: () {
                            _buildNextChapter();
                          },
                          previousChapterListener: () {
                            _buildPreviousChapter();
                          },
                          downListener: () {
                            _downListener();
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
                              child: Theme(
                                  data: ThemeData(
                                      primarySwatch: isNight
                                          ? Colors.blue
                                          : Colors.grey),
                                  child: LinearProgressIndicator(
                                    value: batteryValue / 100,
                                  )),
                            ),
                            margin: EdgeInsets.only(
                                left: 10.0, bottom: 2.0, top: 2.0),
                            padding: EdgeInsets.only(
                                top: 5.0, right: 5.0, bottom: 4.0, left: 3.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/new_battery_bg.9.png"),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            child: Text(
                              "${(((currentChapter + 1) / chapters.length) *
                                  100).toStringAsFixed(2)}%",
                              style: TextStyle(
                                  color: isNight
                                      ? Colors.white30
                                      : Colors.black87),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: Text(
                              "$timerValue",
                              style: TextStyle(
                                  color: isNight
                                      ? Colors.white30
                                      : Colors.black87),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: animate.value,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  color: Color(0xFF2A2A2A),
                  child: Opacity(
                    opacity: animateOPacity.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: IconButton(
//                                iconSize: animate.value/2,
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                        topItem("朗读"),
                        topItem("社区"),
                        topItem("简介"),
                        topItem("换源"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: animate.value,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Color(0xFF2A2A2A),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    isNight
                        ? bottomItem(
                        "assets/images/ic_menu_mode_night_manual.png",
                        "夜间")
                        : bottomItem(
                        "assets/images/ic_menu_mode_day_manual.png",
                        "日间"),
                    bottomItem(
                        "assets/images/ic_menu_settings_normal.png",
                        "设置"),
                    bottomItem(
                        "assets/images/ic_reader_ab_download.png", "缓存"),
                    bottomItem(
                        "assets/images/ic_menu_bookmark.png", "书签"),
                    bottomItem(
                        "assets/images/ic_menu_toc_normal.png", "目录"),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 60.0,
                right: 0.0,
                left: 0.0,
                child: isShowAaSetting ? _buildReadAaSet() : Container()),
            Positioned(
                bottom: 60.0,
                right: 0.0,
                left: 0.0,
                child: isShowReadMark ? _buildReadMark() : Container()),
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child:
                isShowDownloadInfo ? _buildDownloadInfo() : Container()
 )
    ,
          ],
        ));
  }

  Widget _buildDownloadInfo(){
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      color: Color(0x89232323),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(downloadInfo,style: TextStyle(
              color: Colors.white
          ),)
        ],
      ),
    );
  }

  Widget topItem(String info) {
    return Container(
      child: Text(
        info,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget bottomItem(String imgUrl, String info) {
    return GestureDetector(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                imgUrl,
                height: 20.0,
                width: 20.0,
              ),
            ),
            Expanded(
                child: Text(
                  info,
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                )),
          ],
        ),
      ),
      onTap: () {
        if (info == "设置") {
          setState(() {
            initFalse();
            if (isShowReadMark) {
              isShowReadMark = false;
            }
            isShowAaSetting = !isShowAaSetting;
          });
        } else if (info == "日间") {
          prefs.setBool("book-night", true);
          textStyle = TextStyle(
            color: Colors.white30,
            fontSize: currentTextSize,
//            fontWeight: FontWeight.w500,
            height: 1,
          );
          setState(() {
            initFalse();
            isNight = true;
          });
        } else if (info == "夜间") {
          prefs.setBool("book-night", false);
          textStyle = TextStyle(
            color: Color(0xFF000000),
            fontSize: currentTextSize,
//            fontWeight: FontWeight.w500,
            height: 1,
          );
          setState(() {
            initFalse();
            isNight = false;
          });
        } else if (info == "缓存") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _buildDownloadDialog(context);
              });
        } else if (info == "书签") {
          setState(() {
            initFalse();
            if (isShowAaSetting = true) {
              isShowAaSetting = false;
            }
            isShowReadMark = !isShowReadMark;
          });
        } else if (info == "目录") {
          Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return BookChapterListPage(chapters: chapters,
                  title: widget.book.title,
                  currentChapter: currentChapter,);
              }, transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,) {
                // 添加一个平移动画
                return RouterAnimationUtils.createTransition(animation, child);
              })).then((value) {
            if (value != null && value != -1) {
              currentChapter = value;
              loadChapterBody();
            } else {
              print("value:error");
            }
          });
        }
      },
    );
  }

  Widget _buildDownloadDialog(BuildContext context) {
    var simpleDialog = SimpleDialog(
      title: Text("缓存多少章？"),
      children: <Widget>[
        Container(
          child: FlatButton(onPressed: () {
            _bookService.downloadChapter(eventBus,
                widget.book.bookId, chapters, currentChapter, 50);
            _downListener();
            setState(() {
              initFalse();
              isShowDownloadInfo = !isShowDownloadInfo;
            });
            Navigator.pop(context, "后面50章");
          }, child: Text("后面50章")),
        ),
        Container(
          child: FlatButton(onPressed: () {
            _bookService.downloadChapter(eventBus,
                widget.book.bookId, chapters, currentChapter, chapters.length-currentChapter-1);
            _downListener();
            setState(() {
              initFalse();
              isShowDownloadInfo = !isShowDownloadInfo;
            });
            Navigator.of(context).pop();
          }, child: Text("后面全部")),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              _bookService.downloadChapter(eventBus,
                  widget.book.bookId, chapters, currentChapter, chapters.length-1);
              _downListener();
              setState(() {
                initFalse();
                isShowDownloadInfo = !isShowDownloadInfo;
              });
              Navigator.of(context).pop();
            },
            child: Text("全部"),
          ),
        ),
      ],
    );
    return simpleDialog;
  }

  Widget _buildReadAaSet() {
    return Container(
      height: 190.0,
      color: Color(0xFF2A2A2A),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  "assets/images/ic_menu_mode_day_manual.png",
                  height: 20.0,
                  width: 20.0,
                ),
                Slider(
                    value: currentBrightness,
                    min: 0.0,
                    max: 1.0,
                    onChanged: _checkboxSelectedAutoBrightness
                        ? (s) {}
                        : (s) {
                      currentBrightness = s;
                      Screen.setBrightness(currentBrightness);
                      setState(() {});
                    }),
                Image.asset(
                  "assets/images/ic_menu_mode_day_manual.png",
                  height: 20.0,
                  width: 20.0,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Aa-",
                  style: TextStyle(
                      color: Color.fromARGB(225, 114, 114, 114),
                      fontSize: 14.0),
                ),
                Slider(
                    value: currentTextSize,
                    min: 10,
                    max: 50,
                    onChanged: (s) {
                      currentTextSize = s;
                      textStyle = isNight
                          ? TextStyle(
                        color: Colors.white30,
                        fontSize: currentTextSize,
//                    fontWeight: FontWeight.w500,
                        height: 1,
                      )
                          : TextStyle(
                        color: Color(0xFF000000),
                        fontSize: currentTextSize,
//                    fontWeight: FontWeight.w500,
                        height: 1,
                      );
                      prefs.setDouble("book-textsize", currentTextSize);
                      setState(() {
                        initFalse();
                      });
                    }),
                Text(
                  "Aa+",
                  style: TextStyle(
                      color: Color.fromARGB(225, 114, 114, 114),
                      fontSize: 14.0),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    value: _checkboxSelectedVolumPage,
                    activeColor: Colors.red, //选中时的颜色
                    onChanged: (value) {
                      prefs.setBool("book-volumeFlip", value);
                      setState(() {
                        initFalse();
                        _checkboxSelectedVolumPage = value;
                      });
                    },
                  ),
                ),
                Text(
                  "音量键翻页",
                  style: TextStyle(
                      color: Color.fromARGB(225, 178, 178, 178),
                      fontSize: 14.0),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    value: _checkboxSelectedAutoBrightness,
                    activeColor: Colors.red, //选中时的颜色
                    onChanged: (value) {
                      prefs.setBool("book-autobrightness", value);
                      setState(() {
                        initFalse();
                        _checkboxSelectedAutoBrightness = value;
                      });
                    },
                  ),
                ),
                Text(
                  "自动调整亮度",
                  style: TextStyle(
                      color: Color.fromARGB(225, 178, 178, 178),
                      fontSize: 14.0),
                ),
              ],
            ),
          ),
          new Expanded(
            // margin: new EdgeInsets.symmetric(vertical: 15.0),
            child: new ListView.builder(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              scrollDirection: Axis.horizontal,
              itemCount: readBgs.length,
              itemBuilder: (BuildContext context, int index) {
                var readBg = readBgs[index];
                return _buildBgItem(index, readBg);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReadMark() {
    return Container(
        height: 190.0,
        color: Color(0xFF2A2A2A),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      bookMarks.clear();
                      bookMarkJsons.clear();
                      prefs.setStringList("book—marks", bookMarkJsons);
                      setState(() {
                        initFalse();
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Text(
                            "清除",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      var index = prefs.getInt("${widget.book.bookId}-index");
                      BookMark bookMark =
                      BookMark(title, currentChapter, index);
                      bookMarks.add(bookMark);
                      var json = jsonEncode(bookMark.toJson());
                      bookMarkJsons.add(json);
                      prefs.setStringList("book—marks", bookMarkJsons);
                      setState(() {
                        initFalse();
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Text(
                            "新增书签",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemBuilder: (BuildContext context, int index) {
                    var bookMark = bookMarks[index];
                    return Container(
                      padding: EdgeInsets.only(
                          left: 12.0, top: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        "${bookMark.title}--${bookMark.index}",
                        style: TextStyle(
                            color: Color(0xffA58D5E), fontSize: 16.0),
                      ),
                    );
                  },
                  itemCount: bookMarks.length,
                )),
          ],
        ));
  }

  Widget _buildBgItem(int index, String imgSrc) {
    var boxDecoration;
    if (currentThemeIndex == index) {
      boxDecoration = BoxDecoration(
          border: new Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(20.0));
    } else {
      boxDecoration = BoxDecoration();
    }
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.all(4.0),
        child: ClipOval(
          child: Image.asset(
            imgSrc,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
        decoration: boxDecoration,
      ),
      onTap: () {
        currentThemeIndex = index;
        save(index);
        initFalse();
        setState(() {});
      },
    );
  }

  _buildNextChapter() {
    currentChapter++;
    isNext = true;
    isPrevious = false;
    initValue = false;
//    loadData();
    loadChapterBody();
  }

  _buildPreviousChapter() {
    currentChapter--;
    isPrevious = true;
    isNext = false;
    initValue = false;
//    loadData();
    loadChapterBody();
  }

  void _downListener() {
    initFalse();
    if (controller.isCompleted ||
        controller.isDismissed ||
        !controller.isAnimating) {
      if (isForward) {
        controller.forward();
      } else {
        controller.reverse();
      }
      isForward = !isForward;
    }
  }

  initFalse() {
    initValue = false;
    isNext = false;
    initValue = false;
  }

  save(int themeIndex) async {
    prefs.setInt("book-theme", themeIndex);
  }
}
