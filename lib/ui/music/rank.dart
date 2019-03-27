import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/net/music_service.dart';
import 'package:show_time_for_flutter/modul/music/rank_data.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/music/rank_list.dart';
/**
 * @author zcp
 * @date 2019/3/25
 * @Description
 */

class MusicRankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MusicRankPageState();
}

class MusicRankPageState extends State<MusicRankPage>
    with AutomaticKeepAliveClientMixin {
  MusicService musicService = new MusicService();
  List<RangkingDetail> ranks = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    RankingListItem rankingListItem = await musicService.getRankMusics();
    ranks = rankingListItem.ranks;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (ranks.length == 0) {
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
          itemCount: ranks.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(index);
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

  Widget _buildItem(int index) {
    var rank = ranks[index];
    return GestureDetector(
      onTap: (){
        _toListDetails(rank,index);
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
              child: ImageUtils.showFadeImageForSize(
                  rank.pic_s192, 110, 110, BoxFit.cover),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      rank.name == null ? "" : rank.name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildSong(rank, 0),
                  _buildSong(rank, 1),
                  _buildSong(rank, 2),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
  _toListDetails(RangkingDetail rank,int position){
    //1 是新歌榜 2是热歌榜 25网络歌曲榜 21欧美金曲榜  22经典老歌榜 24影视金曲榜
    int typeId = 0;
    var type = position + 1;
    if (type == 3) {
      typeId =25;
    } else if (type == 4) {
      typeId = 24;
    } else if (type == 5) {
      typeId = 22;
    } else if (type == 6) {
      typeId = 21;
    } else if (type == 1) {
      typeId = 2;
    } else if (type == 2) {
      typeId = 1;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return RankMusicListPage(typeId: typeId,title: rank.name,);
    }));
  }
  Widget _buildSong(RangkingDetail rank, int index) {
    var songInfo = rank.songInfos[index];
    var title = songInfo?.title;
    var author = songInfo?.author;
    return new Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        "1.$title-$author",
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
