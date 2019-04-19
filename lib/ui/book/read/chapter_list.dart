import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/modul/book/read/chapters.dart';
import 'dart:math';

/**
 * @author zcp
 * @date 2019/4/11
 * @Description
 */
class BookChapterListPage extends StatefulWidget {
  BookChapterListPage({
    Key key,
    @required this.chapters,
    @required this.title,
    @required this.currentChapter,
  }) : super(key: key);

  final List<Chapters> chapters;
  final String title;
  final int currentChapter;

  @override
  State<StatefulWidget> createState() => BookChapterListPageState();
}

class BookChapterListPageState extends State<BookChapterListPage>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  AnimationController _animationController;
  Animation<double> animation;
  bool isShowFloatButton = false;
  bool isRotate = false;
  bool isInit = true;
  List<Chapters> chapters;
  List<Chapters> chaptersRe = [];

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0.0);
    scrollController.addListener(() {
      if (scrollController.offset < 1000 && isShowFloatButton) {
        setState(() {
          isShowFloatButton = false;
        });
      } else if (scrollController.offset >= 1000 &&
          isShowFloatButton == false) {
        setState(() {
          isShowFloatButton = true;
        });
      }
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    animation = Tween(begin: 0.0, end: pi).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    if (isInit) {
      isInit = false;
      chapters = widget.chapters;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            constraints: BoxConstraints.expand(),
            child: Image.asset(
              "assets/images/background/readb.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "目录",
                        style: TextStyle(color: Colors.black, fontSize: 24.0),
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.black, fontSize: 24.0),
                      ),
                      GestureDetector(
                        child: Container(
                          child: Transform.rotate(
                            angle:
                                animation.value == null ? 0 : animation.value,
                            child: Image.asset(
                              "assets/images/sort.png",
                              width: 18.0,
                              height: 18.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (!isRotate) {
                            isRotate = true;
                            if (animation.value == pi * 2) {
                              _animationController.reset();
                              animation = Tween(
                                      begin: animation.value - pi,
                                      end: animation.value)
                                  .animate(_animationController);
                              animation.addListener(() {
                                setState(() {});
                              });
                            }
                            for (int i = 0; i < chapters.length; i++) {
                              var chapter = chapters[chapters.length - 1 - i];
                              chaptersRe.add(chapter);
                            }
                            chapters.clear();
                            chapters.addAll(chaptersRe);
                            chaptersRe.clear();
                            _animationController.forward();
                          } else {
                            isRotate = false;
                            _animationController.reset();
                            animation = Tween(begin: pi, end: pi * 2)
                                .animate(_animationController);
                            animation.addListener(() {
                              setState(() {});
                            });
                            for (int i = 0; i < chapters.length; i++) {
                              var chapter = chapters[chapters.length - 1 - i];
                              chaptersRe.add(chapter);
                            }
                            chapters.clear();
                            chapters.addAll(chaptersRe);
                            chaptersRe.clear();
                            _animationController.forward();
                          }
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: chapters.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildItem(index);
                        }))
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            top: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop(-1);
              },
                child: Container(
                  padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 10.0),
              child: Image.asset(
                "assets/images/left_128px.png",
                height: 30.0,
                width: 30.0,
              ),
            )),
          )
        ],
      ),
      floatingActionButton: !isShowFloatButton
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
            ),
    );
  }

  Widget _buildItem(int index) {
    int indexRotate = 0;
    if (!isRotate) {
      indexRotate = index;
    } else {
      indexRotate = chapters.length - index - 1;
    }
    var chapter = chapters[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(index);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            indexRotate == widget.currentChapter
                ? Icon(
                    Icons.place,
                    color: Colors.red,
                    size: 24,
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(
                  left: indexRotate == widget.currentChapter ? 8.0 : 32.0),
              child: Text(
                "${chapter.title}",
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
