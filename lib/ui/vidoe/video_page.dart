import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/video_service.dart';
import 'package:show_time_for_flutter/modul/video/video_list.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/widgets/banner.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/vidoe/video_play.dart';

/**
 * @author zcp
 * @date 2019/4/27
 * @Description  用的梨视频的接口https://github.com/jokermonn/-Api/blob/master/Livideo.md#details
 */

class VideoListPlayPage extends StatefulWidget {
  VideoListPlayPage({
    Key key,
    this.categoryId,
  }) : super(key: key);
  String categoryId;

  @override
  State<StatefulWidget> createState() => VideoListPlayPageState();
}

class VideoListPlayPageState extends State<VideoListPlayPage> with AutomaticKeepAliveClientMixin{
  VideoServices _videoServices = VideoServices();
  List<DataList> dataList = [];
  int start = 0;
  int page = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    Videos videos = await _videoServices.getKankanVideoList();
    dataList = videos.dataList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (dataList.length == 0) {
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
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _builderBanner(dataList[0]);
            } else {
              DataList newsType = dataList[index];
              return _BuildListItem(newsType);
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

  Widget _builderBanner(DataList dataList) {
    return BannerView(
      banners: _buildBannerView(dataList.contList),
      intervalDuration: new Duration(seconds: 5),
      itemTextInfo: (index) {
        ContList contList = dataList.contList[index - 1];
        return contList.name;
      },
      height: 200.0,
    );
  }

  List<Widget> _buildBannerView(List<ContList> contLists) {
    List<Widget> widget = [];
    for (int i = 0; i < contLists.length; i++) {
      ContList contList = contLists[i];
      widget.add(GestureDetector(
        child: ImageUtils.showFadeImageForSize(contList.pic, 75.0,
            MediaQuery.of(context).size.width, BoxFit.cover),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return VideoPlayPage(
              videoId: contList.contId,
            );
          }));
        },
      ));
    }
    return widget;
  }

  Widget _BuildListItem(DataList dataList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            dataList.nodeName,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0),
          child: dataList.contList == null
              ? Container()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dataList.contList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2.0,
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0),
                  itemBuilder: (BuildContext context, int index) {
                    var contLists = dataList.contList;
                    ContList contList = contLists[index];
                    return _buildGridView(contList);
                  }),
        )
      ],
    );
  }

  Widget _buildGridView(ContList contList) {
    var width = MediaQuery.of(context).size.width / 2 - 22;
    var height = width * 9 / 16;
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            ImageUtils.showFadeImageForSize(
                contList.pic, height, width, BoxFit.cover),
            Text(contList.name),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return VideoPlayPage(
            videoId: contList.contId,
          );
        }));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
