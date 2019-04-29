import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/picture_services.dart';
import 'package:show_time_for_flutter/modul/picture/beauty.dart';
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
class BeautyPictureListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BeautyPictureListPageState();
}

class BeautyPictureListPageState extends State<BeautyPictureListPage>
    with AutomaticKeepAliveClientMixin {
  PictureServices _services = PictureServices();
  ScrollController _scrollController = new ScrollController();
  int start = 0;
  int size = 30;
  List<Imgs> imgs = [];
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
    start = 0;
    BeautyPhoto beautyPhoto =
        await _services.getBeautyPhoto(start, size, "美女", "全部");
    imgs = beautyPhoto.imgs;
    start += imgs.length;
    setState(() {});
  }

  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      BeautyPhoto beautyPhoto =
          await _services.getBeautyPhoto(start, size, "美女", "全部");
      List<Imgs> imgsMore = beautyPhoto.imgs;
      start += imgsMore.length;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (imgsMore.isEmpty) {
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
          imgs.addAll(imgsMore);
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
    if (imgs.length == 0) {
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
          itemCount: imgs.length + 1,
          controller: _scrollController,
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemBuilder: (context, index) {
            if (index == imgs.length) {
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
    var img = imgs[index];
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(pageBuilder:  (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation){
            return PictureDetailPage(imgUrl: img.imageUrl,imgTitle: img.desc,);
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
                        img.imageUrl,
                        getHight(MediaQuery.of(context).size.width / 2 - 8,img.imageHeight,img.imageWidth),
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

  double getHight(double width,int height,int imgWidth) {
    if(height==0||height==null){
      Random rnd = new Random();
      return rnd.nextInt(width * 3~/2) + width;
    }else{
      double imgHeight = width*height/imgWidth;
      return imgHeight;
    }

  }
}
