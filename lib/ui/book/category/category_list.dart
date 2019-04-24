import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/book/category/category_detail.dart';
/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */

class BookCategoryList extends StatefulWidget{
  BookCategoryList({
    Key key,
    @required this.categoryName,
    @required this.categoryType,
}):super(key:key);
  String categoryName;
  String categoryType;
  @override
  State<StatefulWidget> createState() =>BookCategoryListState();
}

class BookCategoryListState extends State<BookCategoryList>with TickerProviderStateMixin{
  List<String> bookTabs = ["新书", "热门", "口碑", "完结"];
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
        title: Text(widget.categoryName,),
    bottom: TabBar(
    isScrollable: false,
    controller: _tabController,
    tabs: buildTabs(),
    ),
    ),
    body: TabBarView(
    children: buildTabViewPage(),
    controller: _tabController,
    ),);
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
      return BookCategoryDetail(
        categoryName: widget.categoryName,
        categoryType: widget.categoryType,
        type: title,
      );
    }).toList();
    return widgets;
  }
}