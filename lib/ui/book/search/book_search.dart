import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/widgets/search_hero.dart';
import 'package:show_time_for_flutter/net/book_service.dart';
import 'package:show_time_for_flutter/modul/book/search/auto_complete.dart';
import 'package:show_time_for_flutter/modul/book/search/hot_key.dart';
import 'package:show_time_for_flutter/modul/book/search/search_result.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_time_for_flutter/ui/book/detail/book_detail.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:flutter/scheduler.dart';

/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */

class BookSearchPage extends StatefulWidget {
  BookSearchPage({
    Key key,
    this.searchKey,
  }) : super(key: key);
  String searchKey;

  @override
  State<StatefulWidget> createState() => BookSearchPageState();
}

class BookSearchPageState extends State<BookSearchPage> {
  BookService _bookService = BookService();
  TextEditingController _controller;
  OverlayEntry overlayEntry;
  LayerLink layerLink = new LayerLink();
  SharedPreferences prefs;
  bool isEditing = false;
  bool isHasShowPop = false;
  List<String> keywords = [];
  List<String> hotWords = [];
  List<String> limitHotWords = [];
  List<Color> limitHotWordsColor = [];
  List<String> historys;

  List<Books> books = [];
  int hotIndex = 0;

  bool isInitOrRefresh = false;

  bool isAllRightRemove =false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      isEditing = true;
      print(_controller.text);
      if (_controller.text == "") {
        isHasShowPop = false;
      }
      setState(() {
        if (!isHasShowPop) {
          isHasShowPop = true;
          loadAutoComplete(_controller.text);
        }
      });
    });
    loadWord();
    initCallBack();
  }
  void initCallBack() {
    if(widget.searchKey!=null){//在build完成后回调搜索
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _controller.text=widget.searchKey;
          search(widget.searchKey);
        });
      }
    }
  }
  void loadWord() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    initHistory();
    HotKeyWord hotKeyWord = await _bookService.getHotWord();
    hotWords = hotKeyWord.hotWords;
    isInitOrRefresh = true;
    setState(() {});
  }

  void initHistory() {
    historys = prefs.getStringList("book—searchs");
    if (historys == null) {
      historys = [];
    }
  }

  void loadAutoComplete(String query) async {
    if (context == null || query == "") {
      isHasShowPop = false;
      return;
    }
    AutoComplete _autoComplete = await _bookService.autoComplete(query);
    keywords = _autoComplete.keywords;
    if(keywords.length>0){
      overlayEntry = createSelectPopupWindow();
      Overlay.of(context).insert(overlayEntry);
      isAllRightRemove=false;
    }
//    final result =await showMenu(//有很多问题
//        context: context,
//        items: _buildPopItems(),
//        position: RelativeRect.fromLTRB(0.0, 90.0, 0.0, 0.0),
//    );
//    print(result);
//    setState(() {
//      _controller.text=result;
//    });
  }

  List<PopupMenuItem<String>> _buildPopItems() {
    List<PopupMenuItem<String>> pops = [];
    for (int i = 0; i < keywords.length; i++) {
      var keyword = keywords[i];
      print(keyword);
      PopupMenuItem popupMenuItem =
          new PopupMenuItem<String>(value: keyword, child: new Text(keyword));
      pops.add(popupMenuItem);
    }
    return pops;
  }

  /**
   * 利用Overlay实现PopupWindow效果，悬浮的widget
   * 利用CompositedTransformFollower和CompositedTransformTarget
   */
  OverlayEntry createSelectPopupWindow() {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
        width: 200,
        child: new CompositedTransformFollower(
          offset: Offset(0.0, 90.0),
          link: layerLink,
          child: new Material(
            elevation: 8.0,
            child: Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return buildPopItems(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.white,
                      height: 2.0,
                    );
                  },
                  itemCount: keywords.length),
            ),
          ),
        ),
      );
    });
    return overlayEntry;
  }

  Widget buildPopItems(int index) {
    var keyword = keywords[index];
    return ListTile(
      title: new Text(
        keyword,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        _controller.text = keyword;
        search(keyword);
        if(!isAllRightRemove){
          removePop();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            _buildSearchBar(),
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height - 90.0,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: _buildChange(),
                      ),
                      hotWords == null
                          ? SliverToBoxAdapter(
                        child: Container(),
                      )
                          : SliverToBoxAdapter(
                        child: builerTags(),
                      ),
                      SliverToBoxAdapter(
                        child: _buildHistoryInfo(),
                      ),
                      (historys == null || historys.length == 0)
                          ? SliverToBoxAdapter(
                        child: Container(),
                      )
                          : _buildHistorys()
                    ],
                  ),
                ),
                books.length == 0
                    ? Container()
                    : Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height - 90.0,
                  width: MediaQuery.of(context).size.width,
                  child: _buildSearchResult(),
                )
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    ), onWillPop: (){
      if(!isAllRightRemove){
        removePop();
      }
    });
  }

  Widget _buildSearchBar() {
    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
          height: 90.0,
          color: Theme.of(context).primaryColor,
          child: new Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if(!isAllRightRemove){
                          removePop();
                        }
                      }),
                  Expanded(
                      child: new Container(
                    //height: double.infinity, //This is extra
                    // Subtract sums of paddings and margins from actual width
                    child: new TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (keyWord) {
                        search(keyWord);
                      },
                      controller: _controller,
                      cursorColor: Colors.white,
                      cursorWidth: 1,
                      cursorRadius: Radius.circular(30.0),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      decoration: new InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[700])),
//                    decoration: InputDecoration(
//                        contentPadding: EdgeInsets.all(10.0),
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(15.0),
//                        )),//边框样式的输入

                      // onChanged: onSearchTextChanged,
                    ),
                  )),
                  isEditing
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if(!isAllRightRemove){
                              removePop();
                            }
                            _controller.text = "";
                            books.clear();
                            isEditing = false;
                            isHasShowPop = false;
                            setState(() {});
                          })
                      : SearchHero(
                          width: 30.0,
                          search: "search",
                          onTap: () {},
                        ),
                ],
              ))),
    );
  }

  void removePop() {
    if (overlayEntry != null) {
      isAllRightRemove=true;
      overlayEntry.remove();
    }
  }

  Widget _buildChange() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "大家都在搜",
            style: TextStyle(color: Colors.grey),
          ),
          IconButton(
              icon: Icon(Icons.autorenew, color: Colors.grey),
              onPressed: () {
                setState(() {
                  isInitOrRefresh = true;
                });
              }),
        ],
      ),
    );
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
    if (!isInitOrRefresh) {
      for (int i = 0; i < limitHotWords.length; i++) {
        //每次显示8个
        var tag = limitHotWords[i];
        var color = limitHotWordsColor[i];
        GestureDetector gestureDetector = _buildeGesTag(tag, color);
        widgets.add(gestureDetector);
      }
      return widgets;
    }
    isInitOrRefresh = false;
    limitHotWords.clear();
    for (int i = 0; i < 8; i++) {
      //每次显示8个
      var tag = hotWords[hotIndex % hotWords.length];
      limitHotWords.add(tag);
      hotIndex++;
      var color = getColor();
      limitHotWordsColor.add(color);
      GestureDetector gestureDetector = _buildeGesTag(tag, color);
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget _buildeGesTag(String tag, Color color) {
    return new GestureDetector(
      child: Chip(
        label: new Text(
          tag,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        shape: RoundedRectangleBorder(side: BorderSide(color: color)),
      ),
      onTap: () {
        isHasShowPop=true;
        _controller.text=tag;
        search(tag);
      },
    );
  }

  Color getColor() {
    var color = colors[Random().nextInt(colors.length - 1)];
    return color;
  }

  Widget _buildHistoryInfo() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "搜索历史",
            style: TextStyle(color: Color(0xfff212121), fontSize: 14.0),
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                historys.clear();
                saveHistory();
                setState(() {});
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  Text(
                    "清空",
                    style: TextStyle(color: Color(0xfff212121), fontSize: 14.0),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHistorys() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      if ((index + 1) == historys.length * 2) {
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
        return _buildHitsoryItem(i);
      }
    }, childCount: historys.length * 2));
  }

  Widget _buildHitsoryItem(int index) {
    var history = historys[index];
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.timer,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(
                history,
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  void search(String keyWord) async {
    if(historys==null){
      historys=[];
    }
    if (!historys.contains(keyWord)) {
      historys.add(keyWord);
    }
    saveHistory();
    BookSearchResult _bookSearchResult =
        await _bookService.searchBooks(keyWord);
    books = _bookSearchResult.books;
    if(!isAllRightRemove){
      removePop();
    }
    setState(() {});
  }

  void saveHistory() async{
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs.setStringList("book—searchs", historys);
  }

  Widget _buildSearchResult() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _buildSearchBookItems(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.grey,
              height: 2.0,
            );
          },
          itemCount: books.length),
    );
  }

  Widget _buildSearchBookItems(int index) {
    var book = books[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BookDetailPage(
            bookId: book.id,
          );
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
                  Text(
                    book.title,
                    style: TextStyle(color: Color(0xff212121), fontSize: 16.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3.0),
                    child: Text(
                      "${book?.author == null ? "未知" : book.author} | ${book?.cat == null ? "未知" : book.cat}",
                      style:
                          TextStyle(color: Color(0xff727272), fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3.0),
                    child: Text(
                      book?.shortIntro,
                      style:
                          TextStyle(color: Color(0xff727272), fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    "${book?.latelyFollower}人在追 | ${book?.retentionRatio == null ? "0" : book.retentionRatio}读者留存",
                    style: TextStyle(color: Color(0xff727272), fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }


}

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
