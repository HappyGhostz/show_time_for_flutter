import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/music_service.dart';
import 'package:show_time_for_flutter/modul/music/recommend_music.dart';
import 'package:show_time_for_flutter/modul/music/song_list.dart';
import 'package:show_time_for_flutter/widgets/music_list_head.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';

/**
 * @author zcp
 * @date 2019/3/25
 * @Description
 */
class MusicListDetailPage extends StatefulWidget {
  MusicListDetailPage({Key key, this.songInfo, this.isPlayList})
      : super(key: key);
  bool isPlayList;
  SongListInfo songInfo;

  @override
  State<StatefulWidget> createState() => MusicListDetailPageState();
}

class MusicListDetailPageState extends State<MusicListDetailPage> {
  MusicService _musicService = new MusicService();
  SongListDetail songListDetail;
  List<SongDetail> songDetails = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (widget.songInfo != null) {
      songListDetail =
          await _musicService.getListMusics(widget.songInfo.listid);
      songDetails = songListDetail.songDetails;
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: songListDetail == null
          ? LoadingAndErrorView(
              layoutStatus: LayoutStatus.loading,
              noDataTab: () {
                loadData();
              },
              retryTab: () {
                loadData();
              },
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text("歌单"),
                  pinned: true,
                  //是否固定导航栏，
                  snap: false,
                  //往上滚动隐藏AppBar，往下滑动的时候会马上显示AppBar,true需pinned: false floating: true
                  floating: false,
                  //滑动到最上面，再滑动是否隐藏导航栏的文字和标题等的具体内容，为true是隐藏，为false是不隐藏
                  elevation: 4,
                  //阴影的高度
                  forceElevated: false,
                  //是否显示阴影
                  expandedHeight: 270.0,
                  //是初始化展开的高度。
                  flexibleSpace: FlexibleSpaceBar(
                    background: MusicListHeadPage(
                      imageSrc: songListDetail.pic_300,
                      countNum: songListDetail.listenum,
                      title: songListDetail.title,
                      tag: "标签：${songListDetail.tag.replaceAll(",", " ")}",
                    ),
                    //背景，一般是一个图片，在title后面，[Image.fit] set to [BoxFit.cover].
                    centerTitle: false,
                    collapseMode: CollapseMode
                        .parallax, // 背景 固定到位，直到达到最小范围。 默认是CollapseMode.parallax(将以视差方式滚动。)，还有一个是none，滚动没有效果
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHeadItem(),
                ),
                SliverList(delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index){
                          if((index+1)%2==0){
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0,top: 2.0),
                              child: new Divider(
                                height: 1.0,
                                color: Colors.grey,
                              ),
                            )
                              ;
                          }else{
                            final i = index ~/ 2;
                            return _buildSonglistItem(i);
                          }
                    },
                  childCount: songDetails.length*2,
                ))
              ],
            ),
    );
  }
  Widget _buildSonglistItem(int index){
    var songDetail = songDetails[index];
    return GestureDetector(
      child: Container(
        height: 55,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  width: 60,
                  margin: EdgeInsets.only(left: 17.0, right: 10.0),
                  alignment: AlignmentDirectional.centerStart,
                  child: Text("${index+1}"),
                )),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      songDetail.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: EdgeInsets.only(top: 5.0),
                  ),
                  Container(
                      child:Text(
                        songDetail.author,
                        style: TextStyle(fontSize: 12.0, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  Widget _buildHeadItem(){
    return GestureDetector(
      child: Container(
        height: 55,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 17.0, right: 10.0),
                  alignment: AlignmentDirectional.centerStart,
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.blue,
                  ),
                )),
            Expanded(
                flex: 4,
                child: Text(
                  "播放全部(共${songDetails.length}首)",
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                )),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.format_list_numbered,
                      color: Colors.grey,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
