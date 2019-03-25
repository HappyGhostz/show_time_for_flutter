import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/net/news_service.dart';
import 'dart:async';
import 'package:show_time_for_flutter/modul/news_info.dart';
import 'package:show_time_for_flutter/widgets/banner.dart';
import 'package:show_time_for_flutter/widgets/error_loading.dart';
import 'package:show_time_for_flutter/ui/news/news_item.dart';
import 'package:show_time_for_flutter/utils/image_utils.dart';
import 'package:show_time_for_flutter/ui/news/photos/photos_banner.dart';
import 'package:show_time_for_flutter/modul/photos.dart';
import 'package:show_time_for_flutter/widgets/load_more.dart';

int INIT_PAGE = 20;

class NewsListPage extends StatefulWidget {
  NewsListPage({Key key, @required this.typeId}) : super(key: key);
  final String typeId;

  @override
  State<StatefulWidget> createState() => NewsListPageState();
}

class NewsListPageState extends State<NewsListPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  NewsServiceApi newsServiceApi = new NewsServiceApi();
  List<NewsType> news = [];
  List<String> photos = [];
  List<PhotoSet> photosets=[];

  int _page = 0;
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
    _page = 0;
    NewsInfo newsInfo =
        await newsServiceApi.getnewsList(widget.typeId, _page * INIT_PAGE);
    news = newsInfo.news;
    _page++;
    buildPhoto(news);
    setState(() {});
  }

  getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      NewsInfo newsInfo =
          await newsServiceApi.getnewsList(widget.typeId, _page * INIT_PAGE);
      List<NewsType> newsMore = newsInfo.news;
      _page++;
      new Future.delayed(const Duration(microseconds: 500), () {
        if (newsMore.isEmpty) {
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
          news.addAll(newsMore);
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
    if (news.length == 0) {
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
          itemCount: news.length + 1,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0 && isAbNews(news[0])) {
              return _builderBanner(news[0].ads);
            } else if (index == news.length) {
              return _buildLoadMore();
            } else {
              NewsType newsType = news[index];
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

  bool isAbNews(NewsType newsBean) {
    return (newsBean.hasHead == 1 &&
        newsBean.ads != null &&
        newsBean.ads.length > 1);
  }

  Widget _builderBanner(List<Ads> ads) {
    return BannerView(
      banners: _buildBannerView(ads),
      intervalDuration: new Duration(seconds: 5),
      itemTextInfo: (index) {
        var ad = ads[index - 1];
        return ad.title;
      },
      height: 200.0,
    );
  }

  List<Widget> _buildBannerView(List<Ads> ads) {
    List<Widget> widget = [];
    for (int i = 0; i < ads.length; i++) {
      if (ads.length == photos.length) {
        PhotoSet photoset = photosets[i];
        widget.add(GestureDetector(
          child: FadeInImage.assetNetwork(
            placeholder: getAssetsImage(),
            image: photos[i],
            width: MediaQuery.of(context).size.width,
            height: 75.0,
            fit: BoxFit.fill,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return PhotosBannerPage(photoset: photoset,);
            }));
          },
        ));
      } else {
        widget.add(Container());
      }
    }
    return widget;
  }

  buildPhoto(List<NewsType> news) async {
    photos.clear();
    if (isAbNews(news[0])) {
      for (int i = 0; i < news[0].ads.length; i++) {
        var ad = news[0].ads[i];
        String skipID = ad.skipID;
        skipID = skipID.replaceAll('|', '/');
        PhotoSet photoSet = await newsServiceApi.getPhotos(skipID);
        var list = photoSet.list;
        photosets.add(photoSet);
        photos.add(list[0].img);
      }
      setState(() {});
    }
  }

  Widget _BuildListItem(NewsType newsType) {
    return NewsItemWidget(
      newsType: newsType,
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
