import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
/**
 * @author zcp
 * @date 2019/4/3
 * @Description 暂时没找到 测量一行text高度的API，时间紧急，先这样处理
 */

typedef PointerDownEventListener = void Function();
typedef NextChapterListener = void Function();
typedef PreviousChapterListener = void Function();

class BookPaginationPage extends StatelessWidget with WidgetsBindingObserver {
  BookPaginationPage({
    Key key,
    @required this.chapterInfo,
    @required this.currentChapter,
    @required this.maxWidth,
    @required this.maxHeight,
    @required this.bookId,
    @required this.currentIndex,
    @required this.isInit,
    @required this.textStyle,
    this.downListener,
    this.nextChaperListener,
    this.previousChapterListener,
    this.isNext = false,
    this.isPrevious = false,
  }) : super(key: key);
  String chapterInfo;
  int currentChapter;
  double maxWidth = 0;
  double maxHeight = 0;
  TextStyle textStyle;
  PointerDownEventListener downListener;
  NextChapterListener nextChaperListener;
  PreviousChapterListener previousChapterListener;
  bool isNext;
  bool isPrevious;

  String chapterBody;
  String bookId;
  String body = "加载中...";
  String title;
  List<String> bodys = [];
  List<String> realBodys = [];
  double layoutEnouthHeight = 0;
  PageController _pageController;
  double downX = 0;

  int currentIndex = 1;

  bool isInit;
  SharedPreferences prefs;

  void initState() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (isPrevious) {
          _pageController.jumpToPage(realBodys.length - 2);
          isPrevious=false;
        } else if (isNext) {
          _pageController.jumpToPage(1);
          isNext=false;
        } else if (isInit) {
          _pageController.jumpToPage(currentIndex);
          isInit=false;
        }
      });
    }
    if (currentChapter - 1 == 0) {
      _pageController = PageController(initialPage: 0);
    } else {
      _pageController = PageController(initialPage: 1);
    }
    chapterBody = chapterInfo;
    getPaginations();
  }

  getPaginations() {
    measureChapter(chapterBody);
  }

  measureChapter(String chapterInfo) {
    int end = chapterInfo.length;
    int mid = end ~/ 2;
    var chapterInfoStart = chapterInfo.substring(0, mid);
//    int index = 0;
    while (layoutEnouth(chapterInfoStart)) {
      mid = mid ~/ 2;
      chapterInfoStart = chapterInfoStart.substring(0, mid);
    }
    var d = layoutEnouthHeight / maxHeight;
    var endMid = (mid + mid * d).toInt();
    var chapterInfoEndMid = chapterInfo.substring(0, endMid);
    while (layoutEnouth(chapterInfoEndMid)) {
      endMid = (endMid - mid * d * 0.1).toInt();
      chapterInfoEndMid = chapterInfoEndMid.substring(0, endMid);
    }
    var index = end / endMid;
    String endInfo = "";
    String allBody = chapterInfo;
    for (int i = 0; i <= index; i++) {
      if (allBody.length > endMid) {
        endInfo = allBody.substring(0, endMid);
        bodys.add(endInfo);
        allBody = allBody.substring(endMid);
      } else {
        bodys.add(allBody);
      }
    }
    if (currentChapter - 1 == 0) {
      realBodys.addAll(bodys);
      realBodys.add("加载中...");
    } else {
      realBodys.add("加载中...");
      realBodys.addAll(bodys);
      realBodys.add("加载中...");
    }
  }

  bool layoutEnouth(String chapterInfo) {
    TextSpan textSpan = new TextSpan(
      text: chapterInfo,
      style: textStyle,
    );
    TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    textPainter.layout(maxWidth: maxWidth);
    layoutEnouthHeight = textPainter.size.height;
    return layoutEnouthHeight > maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    initPrfs();
    initState();
    FocusNode focusNode = new FocusNode();
    FocusScope.of(context).requestFocus(focusNode);
    return realBodys.length == 0
        ? Container()
        : Listener(
            child: RawKeyboardListener(
                focusNode: focusNode,
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent &&
                      event.data is RawKeyEventDataAndroid) {
                    RawKeyDownEvent rawKeyDownEvent = event;
                    RawKeyEventDataAndroid rawKeyEventDataAndroid =
                        rawKeyDownEvent.data;
                    var volumeFlip =prefs.getBool("book-volumeFlip");
                    if(volumeFlip!=null&&volumeFlip){
                      switch (rawKeyEventDataAndroid.keyCode) {
                        case 25:
                          _pageController.jumpToPage(currentIndex + 1);
                          break;
                        case 24:
                          _pageController.jumpToPage(currentIndex - 1);
                          break;
                      }
                    }
                  }
                },
                child: PageView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
//            color: Colors.amber,
                      child: Text(
                        realBodys[index],
                        style: textStyle,
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    currentIndex = index;
                    if (index == realBodys.length - 1) {
                      nextChaperListener();
                    } else if (index == 0) {
                      if (currentChapter == 0) {
                        return;
                      }
                      previousChapterListener();
                    }
                    save(currentIndex);
                  },
                  itemCount: realBodys.length,
                  controller: _pageController,
                )),
            onPointerDown: (PointerDownEvent event) {
              downX = event.position.dx;
            },
            onPointerUp: (PointerUpEvent event) {
              var dx = event.position.dx;
              var distance = dx - downX;
              if (distance.abs() >= 0 && distance.abs() < 10) {
                downListener();
              }
              if (currentChapter == 0 && distance >= 100 && currentIndex == 0) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("没有上一页了！")));
              }
            },
          );
  }

  save(int currentIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("$bookId-chapter", currentChapter);
    prefs.setInt("$bookId-index", currentIndex);
  }
  initPrfs() async {
    if(prefs==null){
      prefs = await SharedPreferences.getInstance();
    }
  }
}
