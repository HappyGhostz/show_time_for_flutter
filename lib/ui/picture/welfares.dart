import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/picture_services.dart';
import 'package:show_time_for_flutter/modul/picture/welfare.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:show_time_for_flutter/utils/animation_router.dart';
import 'package:show_time_for_flutter/ui/picture/picture.dart';

/**
 * @author zcp
 * @date 2019/4/29
 * @Description
 */
class WelfarePictureListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>WelfarePictureListPageState();
}
class WelfarePictureListPageState extends State<WelfarePictureListPage> with AutomaticKeepAliveClientMixin{
  PictureServices _services = PictureServices();
  ScrollController _scrollController = new ScrollController();
  int page = 0;
  List<Results> results = [];
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
    Welfare welfare =
    await _services.getWelfarePhoto(page);
    results = welfare.results;
    page ++;
    setState(() {});
  }

  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      Welfare welfare =
      await _services.getWelfarePhoto(page);
      List<Results> resultsMore = welfare.results;
      page ++;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (resultsMore.isEmpty) {
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
          results.addAll(resultsMore);
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
    if (results.length == 0) {
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
        child: StaggeredGridView.countBuilder(
          primary: false,
          itemCount: results.length + 1,
          controller: _scrollController,
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemBuilder: (context, index) {
            if (index == results.length) {
              return _builderLoadMoreItem();
            } else {
              return _builderMusicItem(index);
            }
          },
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        ),
      );
    }
  }

  Widget _builderMusicItem(int index) {
    var img = results[index];
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(pageBuilder:  (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation){
            return PictureDetailPage(imgUrl: img.url,imgTitle: img.desc,);
          }, transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) {
            // 添加一个平移动画
            return RouterAnimationUtils.createScaleTransition(animation, child);
          }));
        },
        child: Card(
          child: new Column(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  //new Center(child: new CircularProgressIndicator()),
                  new Center(
                    child: ImageUtils.showFadeImageForSize(
                        img.url,
                        getHight(MediaQuery.of(context).size.width / 2 - 8),
                        MediaQuery.of(context).size.width / 2 - 8,
                        BoxFit.cover),
                  ),
                ],
              ),
              new Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  img.desc == null ? "" : img.desc,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _builderLoadMoreItem() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  double getHight(double width) {
    Random rnd = new Random();
    return rnd.nextInt(width * 3~/2) + width;
  }
}