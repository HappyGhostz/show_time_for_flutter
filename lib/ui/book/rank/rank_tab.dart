import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/book/rank/rank_list.dart';
/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */

class RankTabPage extends StatefulWidget {
  RankTabPage({
    Key key,
    @required this.id,
    @required this.title,
    this.monthRank,
    this.totalRank,
  }) : super(key: key);
  String id;
  String title;
  String monthRank;
  String totalRank;

  @override
  State<StatefulWidget> createState() => RankTabPageState();
}

class RankTabPageState extends State<RankTabPage>
    with TickerProviderStateMixin {
  List<String> bookTabs = ["周榜", "月榜", "总榜"];
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
          widget.title,
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
      if(title=="周榜"){
        return RankListPage(id: widget.id,);
      }else if(title=="月榜"){
        return RankListPage(id: widget.monthRank,);
      }else if(title=="总榜"){
        return RankListPage(id: widget.totalRank,);
      }
    }).toList();
    return widgets;
  }
}
