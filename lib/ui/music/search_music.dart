import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/music_service.dart';
import 'package:show_time_for_flutter/modul/music/search_music.dart';
import 'package:show_time_for_flutter/ui/music/music_play.dart';
import 'package:show_time_for_flutter/modul/local_song.dart';
import 'package:show_time_for_flutter/modul/music/net_song.dart';
/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */

class MusicSearchBarDelegate extends SearchDelegate<String> {
  MusicSearchBarDelegate() : super();
  MusicService _musicService = MusicService();
  MusicSearchList musicSearchList;
  List<SongListBean> song_list = [];
  List<Song> songs;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            return query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            color: Colors.white,
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SongListBean>>(
      future: loadData(),
      builder:
          (BuildContext context, AsyncSnapshot<List<SongListBean>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return new Center(
              child: new Text("ERROR"),
            );
          } else if (snapshot.hasData) {
            song_list = snapshot.data;
            return ListView.builder(
                itemCount: song_list.length * 2,
                itemBuilder: (BuildContext context, int index) {
                  if ((index + 1) % 2 == 0) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
                      child: new Divider(
                        height: 1.0,
                        color: Colors.grey,
                      ),
                    );
                  } else {
                    final i = index ~/ 2;
                    return _buildSonglistItem(context, i);
                  }
                });
          }
        }
      },
    );
  }

  Future<List<SongListBean>>loadData() async {

    musicSearchList = await _musicService.getSearchSons(query);
    song_list = musicSearchList.song_list;
    if(songs!=null){
      return song_list;
    }
    songs = [];
    songs.clear();
    for (int i = 0; i < song_list.length; i++) {
      var songDetail = song_list[i];
      SongDetailInfo songDetailInfo =
          await _musicService.getSong(songDetail.song_id);
      var songinfo = songDetailInfo.songinfo;
      Song song = Song(i, songinfo.author, songinfo.title, songinfo.album_title,
          0, 0, songDetailInfo.bitrate.file_link, 0, songinfo.pic_premium);
      songs.add(song);
    }
    return song_list;
  }

  Widget _buildSonglistItem(BuildContext context, int index) {
    var songDetail = song_list[index];
    return GestureDetector(
      onTap: () {
        if (songs == null || songs.length < song_list.length) {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("资源尚未加载完成，请稍后再试!"),
          ));
          return;
        } else if (songs != null && songs.length == song_list.length) {
          var song = songs[index];
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return MusicPlayPage(
              songs: songs,
              countIndex: index,
              mp3Url: song.url,
              albumSrc: song.albumArt,
              title: song.title,
              isLocal: false,
            );
          }));
        }
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
                  child: Text("${index + 1}"),
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
                    child: Text(
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.red,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme:theme.textTheme.copyWith(title: theme.textTheme.title.copyWith(color: Colors.white)),
      textTheme: theme.textTheme.copyWith(title: theme.textTheme.title.copyWith(color: Colors.white)),
    );
  }
}
