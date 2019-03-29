import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/net/music_service.dart';
import 'package:show_time_for_flutter/modul/local_song.dart';
import 'package:show_time_for_flutter/ui/music/music_play.dart';

class LocalMusicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LocalMusicPageState();
}

class LocalMusicPageState extends State<LocalMusicPage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController = new ScrollController();
  MusicService musicService = new MusicService();
  List<Song> localSons = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    localSons = await musicService.allLocalSongs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (localSons.length == 0) {
      return LoadingAndErrorView(
        layoutStatus: LayoutStatus.loading,
        noDataTab: () {
          loadData();
        },
        retryTab: () {
          loadData();
        },
      );
    } else {
      return new RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: loadData,
        child: ListView.separated(
          itemCount: localSons.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _builderPlayAllItem();
            } else {
              return _buildListItem(index);
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return new Divider(
              height: 1.0,
              color: Colors.grey,
            );
          },
        ),
      );
    }
  }

  Widget _builderPlayAllItem() {
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
                flex: 3,
                child: Text(
                  '播放全部',
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

  Widget _buildListItem(int index) {
    var localSon = localSons[index-1];
    return GestureDetector(
      onTap: (){
        _playMusic(index-1);
      },
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
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.blue,
                  ),
                )),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      localSon.title.replaceAll(".mp3", ""),
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
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          localSon.singer,
                          style: TextStyle(fontSize: 12.0, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8.0,right: 2.0),
                        child: Text(
                          '|',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        localSon.album == null ? "" : localSon.album,
                        style: TextStyle(fontSize: 12.0, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  )),
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
  _playMusic(int index){
    var localSon = localSons[index];
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return MusicPlayPage(songs:localSons,countIndex:index,mp3Url:localSon.url,albumSrc: localSon.albumArt,title: localSon.title,
      isLocal: true,);
    }));
  }
  @override
  bool get wantKeepAlive => true;
}
