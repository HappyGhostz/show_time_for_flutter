import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/music_service.dart';
import 'package:show_time_for_flutter/modul/music/recommend_music.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/ui/music/list_detail.dart';

/**
 * @author zcp
 * @date 2019/3/21
 * @Description
 */
class RecommendSonsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecommendSonsPageState();
}

class RecommendSonsPageState extends State<RecommendSonsPage>with AutomaticKeepAliveClientMixin {
  MusicService musicService = new MusicService();
  ScrollController _scrollController = new ScrollController();
  List<SongListInfo> songListInfos = [];
  int startPage = 1;
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    loadData();
  }

  Future<void> loadData() async {
    startPage = 1;
    RecommendMusicData recommendMusicData =
        await musicService.getRecommendMusics(startPage);
    songListInfos = recommendMusicData.content;
    startPage++;
    setState(() {});
  }
  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      RecommendMusicData recommendMusicData =
      await musicService.getRecommendMusics(startPage);
      List<SongListInfo> songListInfosMore= recommendMusicData.content;
      startPage++;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (songListInfosMore.isEmpty) {
          double edge = 72;
          double offsetFromBottom = _scrollController.position.maxScrollExtent -
              _scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            _scrollController.animateTo(
                _scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
        }
        setState(() {
          songListInfos.addAll(songListInfosMore);
          isPerformingRequest = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (songListInfos.length == 0) {
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
        child: GridView.builder(
            padding: EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == songListInfos.length) {
                return _builderLoadMoreItem();
              } else {
                return _builderMusicItem(index);
              }
            },
          itemCount: songListInfos.length+1,
          controller: _scrollController,
        ),
      );
    }
  }

  Widget _builderLoadMoreItem() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _builderMusicItem(int index) {
    var songListInfo = songListInfos[index];
    var count = int.parse(songListInfo?.listenum);
    String countNum = "";
    if (count > 10000) {
      count = count ~/ 10000;
      countNum = count.toString() + "万";
    } else {
      countNum = songListInfo?.listenum;
    }
    return GestureDetector(
      onTap: (){
        _recommendDetails(songListInfo);
      },
      child: Container(
        padding:EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Container(
                  height: 160,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: ImageUtils.showFadeImageForHeight(
                            songListInfo.pic_300, 160, BoxFit.cover),
                        constraints: BoxConstraints.expand(),
                      )
                      ,
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: double.infinity,
                        ),
                        color: Colors.black54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Image.asset("assets/images/index_icn_earphone.png",
                              width: 12.0,),
                            Container(
                              margin: EdgeInsets.only(left: 4.0,right: 2.0,top:2.0,bottom: 2.0),
                              child: Text(
                                countNum,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            ,
            Expanded(
                flex: 1,
                child: Container(
                  child:Row(
                    children: <Widget>[
                      Expanded(child: Text(songListInfo.title,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),))
                    ],
                  )
                  ,
                ))
          ],
        ),
      ),
    );
  }
  _recommendDetails(SongListInfo songListInfo){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return MusicListDetailPage(isPlayList: true,songInfo: songListInfo,);
    }));
  }

  @override
  bool get wantKeepAlive => true;
}
