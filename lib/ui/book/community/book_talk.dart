import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/book/community/talk/book_talk_list.dart';
import 'package:show_time_for_flutter/ui/book/community/talk/book_community_list.dart';
/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */

class BookTalkTabPage extends StatefulWidget {
  BookTalkTabPage({
    Key key,
    @required this.bookId,
    @required this.bookTitle,
  }) : super(key: key);
  String bookId;
  String bookTitle;

  @override
  State<StatefulWidget> createState() => BookTalkTabPageState();
}

class BookTalkTabPageState extends State<BookTalkTabPage>
    with TickerProviderStateMixin {
  List<String> bookTabs = ["评论", "讨论"];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: bookTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookTitle,
        ),
        bottom: TabBar(
          isScrollable: false,
          controller: _tabController,
          tabs: buildTabs(),
        ),
      ),
      body: TabBarView(
        children: buildTabViewPage(),
        controller: _tabController,
      ),
    );
  }

  List<Widget> buildTabs() {
    List<Widget> widgets = new List<Widget>();
    widgets = bookTabs.map((title) {
      return new Tab(
        text: title,
      );
    }).toList();

    return widgets;
  }

  List<Widget> buildTabViewPage() {
    List<Widget> widgets = new List<Widget>();
    widgets = bookTabs.map((title) {
      if (title == "评论") {
        return BookCommunityListPage(
          bookId: widget.bookId,
        );
      } else if (title == "讨论") {
        return BookTalkDetailPage(
          bookId: widget.bookId,
        );
      }
    }).toList();
    return widgets;
  }
}
