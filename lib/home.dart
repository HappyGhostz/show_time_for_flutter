import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget{
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

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>HomePageState();
}
class HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  final _selectedTitles =[
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTitles.elementAt(_selectedIndex)),
//        在有draw控件的情况下，忽略leading会默认有个图标打开draw
//        leading: IconButton(icon:Icon( Icons.list),
//        onPressed: (){
//          ScaffoldState().openDrawer();
//        },),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: (){

          },),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child:  _onDrawViewPage(),
      ),
      bottomNavigationBar: Theme(
          data: ThemeData(
            canvasColor: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith(caption: style)
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home,color:_selectIconColor(0),),
                  title: Text('News',)),
              BottomNavigationBarItem(icon: Icon(Icons.video_label,color: _selectIconColor(1),),
                  title: Text('Video',)),
              BottomNavigationBarItem(icon: Icon(Icons.queue_music,color: _selectIconColor(2),),
                  title: Text('Music',)),
              BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark,color: _selectIconColor(3),),
                  title: Text('Books',)),
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
  Color _selectIconColor(int index){
    return _selectedIndex==index?Colors.white:Colors.grey;
  }
  Widget _onDrawViewPage(){
    return Column(
      children: <Widget>[
        const UserAccountsDrawerHeader(
          accountName: Text('ShowTime'),
          accountEmail: Text('zcphappyghost@163.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage(
              'images/drawhead.png',
            ),
          ),
          margin: EdgeInsets.zero,
        ),
        gestureDetectorForItem(Icons.library_books,'段子',0,_selectDrawItemIndex),
        gestureDetectorForItem(Icons.image,'图片',1,_selectDrawItemIndex),
        gestureDetectorForItem(Icons.live_tv,'直播',2,_selectDrawItemIndex),
        gestureDetectorForItem(Icons.settings,'设置',3,_selectDrawItemIndex),
      ],
    );
  }

  GestureDetector gestureDetectorForItem(IconData icon,String title,int drawItemIndex,int _selectDrawItemIndex) {
    return GestureDetector(
        child: Container(
          color:_selectDrawItemIndex==drawItemIndex?Colors.grey:Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(icon,color: _selectDrawItemIndex==drawItemIndex?Colors.red:Colors.grey,),
                margin: EdgeInsets.all(16.0),
              ),
              Container(
                child: Text(title,style: TextStyle(
                  color: _selectDrawItemIndex==drawItemIndex?Colors.red:Colors.black
                ),),
                margin: EdgeInsets.all(16.0),
              )
            ],
          ),
        ),
        onTap:(){
          _onDrawItemSelect(drawItemIndex);
        },
      );
  }
  _onDrawItemSelect(int drawItemIndex){
    _selectDrawItemIndex = drawItemIndex;
    setState(() {
    });
  }
}