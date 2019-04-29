import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/picture/beautys.dart';
import 'package:show_time_for_flutter/ui/picture/welfares.dart';
/**
 * @author zcp
 * @date 2019/4/29
 * @Description
 */
class BeautyPictureTabPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>BeautyPictureTabPageState();
}
class BeautyPictureTabPageState extends State<BeautyPictureTabPage>with TickerProviderStateMixin{
  List<String> pictureTabs = ["美图", "福利"];
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: pictureTabs.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("图片"),
    bottom: TabBar(
    isScrollable:false,
    controller: _tabController,
    tabs: buildTabs(),
    ),
    ),
    body: TabBarView(
    children: buildTabViewPage(),
    controller: _tabController,
    ));
  }
  List<Widget> buildTabs() {
    List<Widget> widgets = new List<Widget>();
    widgets = pictureTabs.map((title) {
      return new Tab(
        text: title,
      );
    }).toList();
    return widgets;
  }List<Widget> buildTabViewPage() {
    List<Widget> widgets = new List<Widget>();
    widgets = pictureTabs.map((title) {
      if(title=="美图"){
        return new BeautyPictureListPage(
        );
      }else{
        return new WelfarePictureListPage(
        );
      }

    }).toList();
    return widgets;
  }
}