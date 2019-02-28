import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/channel/channel.dart';
import 'package:show_time_for_flutter/channel/channel_info.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ChannelModel channelModel;
  List<Channel> tabs = [];
  int _selectedIndex = 0;
  final _selectedTitles = [
    "新闻",
    "视频",
    "音乐爽听",
    "阅读",
  ];
  final _widgetOptions = [
    Text('Index 0: News'),
    Text('Index 1: Video'),
    Text('Index 2: Music'),
    Text('Index 3: Books'),
  ];
  int _selectDrawItemIndex = -1;
  TextStyle style = TextStyle(color: Colors.black);
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    channelModel = new ChannelModel();
    initSelectChannels();
    _tabController = TabController(vsync: this, length: tabs.length);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }
  changeTabController(){
    _tabController = TabController(vsync: this, length: tabs.length);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  initSelectChannels() async {
    tabs = await channelModel.getSelectChannels();
    setState(() {
      changeTabController();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }
  List<Widget> buildTabs(){
    List<Widget> widgets = new List<Widget>();
    widgets =tabs.map((channel){
      return new Tab(text: channel.name,);
    }).toList();
    return widgets;
  }
  List<Widget> buildTabViewPage(){
    List<Widget> widgets = new List<Widget>();
    widgets =tabs.map((channel){
      return new Text(channel.name);
    }).toList();
    return widgets;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(_selectedTitles.elementAt(_selectedIndex)),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ChannelPage();
                        })).then((value) {
                          tabs = value;
                          setState(() {
                            changeTabController();
                          });
                        });
                      })
                ],
                pinned: true,
                floating: true,
                forceElevated: boxIsScrolled,
                bottom: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: buildTabs(),
                ),
              )
            ];
          },
          controller: _scrollViewController,
          body: TabBarView(
            children: buildTabViewPage(),
            controller: _tabController,
          )),
      drawer: Drawer(
        child: _onDrawViewPage(),
      ),
      bottomNavigationBar: Theme(
          data: ThemeData(
              canvasColor: Colors.red,
              textTheme: Theme.of(context).textTheme.copyWith(caption: style)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _selectIconColor(0),
                  ),
                  title: Text(
                    'News',
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.video_label,
                    color: _selectIconColor(1),
                  ),
                  title: Text(
                    'Video',
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.queue_music,
                    color: _selectIconColor(2),
                  ),
                  title: Text(
                    'Music',
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.collections_bookmark,
                    color: _selectIconColor(3),
                  ),
                  title: Text(
                    'Books',
                  )),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
//             这两个属性一起用才起作用
//            fixedColor: Colors.deepPurple,
//            type: BottomNavigationBarType.fixed,
          )),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _selectIconColor(int index) {
    return _selectedIndex == index ? Colors.white : Colors.grey;
  }

  Widget _onDrawViewPage() {
    return Column(
      children: <Widget>[
        const UserAccountsDrawerHeader(
          accountName: Text('ShowTime'),
          accountEmail: Text('zcphappyghost@163.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/drawhead.png',
            ),
          ),
          margin: EdgeInsets.zero,
        ),
        gestureDetectorForItem(
            Icons.library_books, '段子', 0, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.image, '图片', 1, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.live_tv, '直播', 2, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.settings, '设置', 3, _selectDrawItemIndex),
      ],
    );
  }

  GestureDetector gestureDetectorForItem(IconData icon, String title,
      int drawItemIndex, int _selectDrawItemIndex) {
    return GestureDetector(
      child: Container(
        color:
            _selectDrawItemIndex == drawItemIndex ? Colors.grey : Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(
                icon,
                color: _selectDrawItemIndex == drawItemIndex
                    ? Colors.red
                    : Colors.grey,
              ),
              margin: EdgeInsets.all(16.0),
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                    color: _selectDrawItemIndex == drawItemIndex
                        ? Colors.red
                        : Colors.black),
              ),
              margin: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
      onTap: () {
        _onDrawItemSelect(drawItemIndex);
      },
    );
  }

  _onDrawItemSelect(int drawItemIndex) {
    _selectDrawItemIndex = drawItemIndex;
    setState(() {});
  }
}
