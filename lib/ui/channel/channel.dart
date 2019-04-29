import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/channel/channel_info.dart';
import 'dart:convert';
import 'package:show_time_for_flutter/widgets/drag_grid.dart';

class ChannelPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChannelPageState();
}

class ChannelPageState extends State<ChannelPage>{
  ChannelModel channelModel;
  List<Channel> categories = [];
  List<Channel> unSelectChannels = [];
  List<String> selectChannelsType = [];
  //数据源备份，在拖动时 会直接在数据源上修改 来影响UI变化，当拖动取消等情况，需要通过备份还原
  List<Channel> categoriesBackup;
  //手指覆盖的地方，即item被拖动时 底部的那个widget是否可见；
  bool _showItemWhenCovered = false;
  //当拖动覆盖到某个item上的时候，记录这个item的坐标
  int _willAcceptIndex = -1;
  var editSwitchController=EditSwitchController();
  @override
  void initState() {
    super.initState();
    channelModel = new ChannelModel();
    initSelectChannels();
  }
  initSelectChannels()async{
    List<Channel> channels = await channelModel.getSelectChannels();
    String channelString = await DefaultAssetBundle.of(context).loadString("assets/json/newschannel.json");
    List jsons = jsonDecode(channelString);
    ChannelList channelList = ChannelList.fromJson(jsons);
    List<Channel> channelAseets = channelList.channels;
//    List<Channel> channelAseets = jsons.map((jsonMap){
//      return new Channel.fromJson(jsonMap);
//    });
    if(channels==null||channels.isEmpty){
      await channelModel.insertSomeChannel(channelAseets.sublist(0,4));
      setState(() {
        categories = channelAseets.sublist(0,4);
        unSelectChannels = channelAseets.sublist(4,channelAseets.length-1);
      });
    }else{
      List<Channel> unChannels = [];
      unChannels.addAll(channelAseets);
      channels.forEach((selectChannels){
        selectChannelsType.add(selectChannels.typeId);
      });
      for(int i=0;i<selectChannelsType.length-1;i++){
        String channelsType = selectChannelsType[i];
        for(int j=0;j<channelAseets.length-1;j++ ){
          Channel channelAseet = channelAseets[j];
          if(channelAseet.typeId==channelsType){
            unChannels.remove(channelAseet);
          }
        }
      }
      setState(() {
        categories = channels;
        unSelectChannels = unChannels;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('栏目管理'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.of(context).pop(categories);
        }),
      ),
      body: WillPopScope(child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildSelecthead('我的栏目','长按拖拽排序或右滑删除'),
          ),
          SliverGrid(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              return buildeGridItem(categories[index],index,true);
            },childCount: categories.length,),),
          SliverToBoxAdapter(
            child: _buildSelecthead('更多栏目','点击添加'),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              return buildeGridItem(unSelectChannels[index],index,false);
            },childCount: unSelectChannels.length,),),
        ],
      ), onWillPop: (){
        Navigator.of(context).pop(categories);
      })
    );
  }
  Widget _buildSelecthead(String channelTitle,String subtitle){
    return new Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8.0),
          child: Text(channelTitle,style: TextStyle(fontSize: 16.0),),
        ),
        Container(
          child: Text(subtitle,style: TextStyle(fontSize: 12.0),),
        )
      ],
    );
  }
  buildeGridItem(Channel channel,int index,bool isSelectChannel){
    String name = channel.name;
    return GestureDetector(
      onTap: (){
        if(!isSelectChannel){
          unSelectChannels.remove(channel);
          categories.add(channel);
          setState(() {
            channelModel.insertSelectChannel(channel);
          });
        }
      },
      child:isSelectChannel?builderSelectItem(channel,index):builder(name),
    );
  }
  builderSelectItem(Channel channel,int index){
    return Dismissible(
        key: ValueKey(channel),
        child: builder(channel.name),
        background:Container(
          padding: EdgeInsets.all(8.0),
          color:Colors.red,
        ),
      onDismissed: (direction){
          categories.remove(channel);
          unSelectChannels.add(channel);
          channelModel.deleteSelectChannel(channel);
          setState(() {
          });
      },
    );
  }
  builder(String name){
    return Container(
//      decoration: new BoxDecoration(
//        borderRadius: BorderRadius.all(new Radius.circular(3.0)),
//        border: new Border.all(color: Colors.blue),
//      ),
      child: Card(
        elevation: 4.0,
        child: Center(
          child: Text('$name',style: TextStyle(color: Colors.black,fontSize: 14.0),),
        ),
      ),
    );
  }
}