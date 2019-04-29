import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/channel/channel.dart';
import 'package:show_time_for_flutter/ui/channel/channel_info.dart';
import 'package:show_time_for_flutter/ui/news/news_list.dart';
import 'package:show_time_for_flutter/ui/music/local_music.dart';
import 'package:show_time_for_flutter/ui/music/recommend_sons.dart';
import 'package:show_time_for_flutter/ui/music/rank.dart';
import 'package:show_time_for_flutter/ui/music/search_music.dart';
import 'package:show_time_for_flutter/ui/book/rack/rack_page.dart';
import 'package:show_time_for_flutter/ui/book/category/book_category.dart';
import 'package:show_time_for_flutter/ui/book/community/community_book.dart';
import 'package:show_time_for_flutter/ui/book/rank/rank_page.dart';
import 'package:show_time_for_flutter/ui/book/search/book_search.dart';
import 'package:show_time_for_flutter/widgets/search_hero.dart';
import 'package:show_time_for_flutter/ui/vidoe/video_page.dart';
import 'package:show_time_for_flutter/ui/vidoe/video_page_category.dart';
import 'package:show_time_for_flutter/ui/picture/picture_tab.dart';

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

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ChannelModel channelModel;
  List<Channel> tabs = [];
  List<String> videoTabs = ["头条", "娱乐", "社会", "搞笑", "世界", "科技", "体育", "生活", "财富", "新知", "美食"];
  List<String> videoTabscategoryIds = ["0", "4", "1", "7", "2", "8", "9", "5", "3", "10", "6"];
  List<String> bookTabs = ["书架", "分类", "社区", "排行榜"];
  List<String> musicTabs = ["本地音乐", "推荐歌单", "排行榜"];
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
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    channelModel = new ChannelModel();
    initSelectChannels();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      _currentTabIndex = _tabController.index;
    });
  }

  changeTabController() {
    _tabController = TabController(vsync: this, length: tabs.length);
    if (_currentTabIndex > 0 && _currentTabIndex < tabs.length) {
      _tabController.animateTo(_currentTabIndex);
    }
    _tabController.addListener(() {
      _currentTabIndex = _tabController.index;
    });
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
    super.dispose();
  }

  List<Widget> buildTabs() {
    List<Widget> widgets = new List<Widget>();
    if (tabs == null) {
      widgets.add(new Tab( text: "",));
      return widgets;
    }
    ;
    if (_selectedIndex == 0) {
      widgets = tabs.map((channel) {
        return new Tab(
          text: channel.name,
        );
      }).toList();
    } else if (_selectedIndex == 1) {
      widgets = videoTabs.map((title) {
        return new Tab(
          text: title,
        );
      }).toList();
    } else if (_selectedIndex == 2) {
      widgets = musicTabs.map((title) {
        return new Tab(
          text: title,
        );
      }).toList();
    } else if (_selectedIndex == 3) {
      widgets = bookTabs.map((title) {
        return new Tab(
          text: title,
        );
      }).toList();
    }

    return widgets;
  }

  bool _isScrollable() {
    if (_selectedIndex == 0||_selectedIndex==1) {
      //||_selectedIndex==1
      return true;
    } else {
      return false;
    }
  }

  List<Widget> buildTabViewPage() {
    List<Widget> widgets = new List<Widget>();
    if (_selectedIndex == 0) {
      widgets = tabs.map((channel) {
        return new NewsListPage(
          typeId: channel.typeId,
        );
      }).toList();
    } else if (_selectedIndex == 1) {
      widgets = videoTabs.map((title) {
        String categoryId = getVideoCatagory(title);
        if(categoryId=="0"){
          return new VideoListPlayPage(categoryId: categoryId,);
        }else{
          return new VideoCategoryListPlayPage(categoryId: categoryId,);
        }
      }).toList();
    } else if (_selectedIndex == 2) {
      widgets = musicTabs.map((title) {
        if (title == "本地音乐") {
          return new LocalMusicPage();
        } else if (title == "推荐歌单") {
          return new RecommendSonsPage();
        } else if (title == "排行榜") {
          return new MusicRankPage();
        }
      }).toList();
    } else if (_selectedIndex == 3) {
      widgets = bookTabs.map((title) {
        if (title == "书架") {
          return BookRackPage();
        } else if (title == "分类") {
          return BookCategoryPage();
        } else if (title == "社区") {
          return BookCommunityPage();
        } else if (title == "排行榜") {
          return BookRankPage();
        }
      }).toList();
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTitles.elementAt(_selectedIndex)),
        actions: _buildActions(),
        bottom: TabBar(
          isScrollable: _isScrollable(),
          controller: _tabController,
          tabs: buildTabs(),
        ),
      ),
      body: TabBarView(
        children: buildTabViewPage(),
        controller: _tabController,
      ),
      drawer: Drawer(
        child: _onDrawViewPage(),
      ),
      bottomNavigationBar: Theme(
          data: ThemeData(
              canvasColor: Colors.red,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: style)),
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
    _tabController.animateTo(0);
    setState(() {
      _selectedIndex = index;
      changeTabController();
    });
  }

  Color _selectIconColor(int index) {
    return _selectedIndex == index ? Colors.white : Colors.grey;
  }

  List<Widget> _buildActions() {
    if (_selectedIndex == 0) {
      return <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChannelPage();
              })).then((value) {
                setState(() {
                  tabs = value;
                  changeTabController();
                });
              });
            })
      ];
    } else if (_selectedIndex == 1) {
      return [];
    } else if (_selectedIndex == 2) {
      return <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MusicSearchBarDelegate());
            })
      ];
    } else if (_selectedIndex == 3) {
      return <Widget>[
        SearchHero(
          width: 30.0,
          search: "search",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BookSearchPage();
            }));
          },
        ),
//        IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () {
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                return BookSearchPage();
//              }));
//            }),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ];
    }
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
        if(drawItemIndex==1){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return BeautyPictureTabPage();
          }));
        }
        _onDrawItemSelect(drawItemIndex);
      },
    );
  }

  _onDrawItemSelect(int drawItemIndex) {
    _selectDrawItemIndex = drawItemIndex;
    setState(() {});
  }
//  ["头条", "娱乐", "社会", "搞笑", "世界", "科技", "体育", "生活", "财富", "新知", "美食"];
//  ["0", "4", "1", "7", "2", "8", "9", "5", "3", "10", "6"];
  String getVideoCatagory(String title) {
    if(title=="头条"){
      return "0";
    }else if(title=="娱乐"){
      return "4";
    }else if(title=="社会"){
      return "1";
    }else if(title=="搞笑"){
      return "7";
    }else if(title=="世界"){
      return "2";
    }else if(title=="科技"){
      return "8";
    }else if(title=="体育"){
      return "9";
    }else if(title=="生活"){
      return "5";
    }else if(title=="财富"){
      return "3";
    }else if(title=="新知"){
      return "10";
    }else if(title=="美食"){
      return "6";
    }
  }
}
