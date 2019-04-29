import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/video_service.dart';
import 'package:show_time_for_flutter/modul/video/video_list.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/vidoe/video_play.dart';

/**
 * @author zcp
 * @date 2019/4/27
 * @Description 用的梨视频的接口https://github.com/jokermonn/-Api/blob/master/Livideo.md#details
 */

class VideoCategoryListPlayPage extends StatefulWidget {
  VideoCategoryListPlayPage({
    Key key,
    this.categoryId,
  }) : super(key: key);
  String categoryId;

  @override
  State<StatefulWidget> createState() => VideoCategoryListPlayPageState();
}

class VideoCategoryListPlayPageState extends State<VideoCategoryListPlayPage> with AutomaticKeepAliveClientMixin{
  VideoServices _videoServices = VideoServices();
  ScrollController _scrollController = new ScrollController();
  List<ContList> contLists = [];
  List<HotListBean> hotLists = [];
  int start = 0;
  int page = 0;
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
    page = 1;
    start = 0;
    Videos videos = await _videoServices.getKankanVideoFromCate(
        page, start, widget.categoryId);
    contLists = videos.contList;
    hotLists = videos.hotLists;
    page++;
    start += contLists.length;
    setState(() {});
  }

  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      Videos videos = await _videoServices.getKankanVideoFromCate(
          page, start, widget.categoryId);
      List<ContList> contListMores = videos.contList;
      page++;
      start += contListMores.length;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (contListMores.isEmpty) {
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
          contLists.addAll(contListMores);
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
    if (hotLists.length == 0 || contLists.length == 0) {
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
          itemCount: 3,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _BuildHotListItem();
            } else if (index == 2) {
              return _buildLoadMore();
            } else {
              if (contLists == null) {
                return Container();
              } else {
                return _BuildListItem(false);
              }
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

  Widget _BuildListItem(bool isHot) {
    return contLists == null
        ? Container()
        : _buildItem(null, contLists.length, isHot);
  }

  Widget _buildItem(String name, int length, bool isHot) {
    return name == null
        ? buildeConstGridViewItem(length, isHot)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              buildeConstGridViewItem(length, isHot)
            ],
          );
  }

  Container buildeConstGridViewItem(int length, bool isHot) {
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 2.0, crossAxisCount: 2, crossAxisSpacing: 2.0),
          itemBuilder: (BuildContext context, int index) {
            return isHot ? _buildHotGridView(index) : _buildGridView(index);
          }),
    );
  }

  Widget _buildGridView(int index) {
    ContList contList = contLists[index];
    var width = MediaQuery.of(context).size.width / 2 - 22;
    var height = width * 9 / 16;
    return GestureDetector(
      onTap: (){
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return VideoPlayPage(
            videoId: contList.contId,
          );
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            ImageUtils.showFadeImageForSize(
                contList.pic, height, width, BoxFit.cover),
            Text(contList.name),
          ],
        ),
      ),
    );
  }

  Widget _BuildHotListItem() {
    return hotLists.length == 0
        ? Container()
        : _buildItem("最热", hotLists.length, true);
  }

  Widget _buildHotGridView(int index) {
    HotListBean hotListBean = hotLists[index];
    var width = MediaQuery.of(context).size.width / 2 - 22;
    var height = width * 9 / 16;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return VideoPlayPage(
            videoId: hotListBean.contId,
          );
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            ImageUtils.showFadeImageForSize(
                hotListBean.pic, height, width, BoxFit.cover),
            Text(hotListBean.name),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMore() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
