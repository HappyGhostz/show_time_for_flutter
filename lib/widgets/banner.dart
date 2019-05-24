import 'package:flutter/material.dart';
import 'dart:async';
import 'package:show_time_for_flutter/modul/news_info.dart';

const MAX_COUNT = 0x7fffffff;

typedef TextInfo = String Function(int index);
typedef GestureTapCallback = void Function();
class BannerView<T> extends StatefulWidget {
  BannerView({
    Key key,
    @required this.banners,
    this.initIndex = 0,
    this.cycleRolling = true,
    this.autoRolling = true,
    this.intervalDuration = const Duration(seconds: 1),
    this.animationDuration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.onPageChanged,
    this.height,
    this.textBackgroundColor = const Color(0x99000000),
    this.hasTextinfo = true,
    this.itemTextInfo,
    this.pointRadius = 3.0,
    this.selectedColor = Colors.red,
    this.unSelectedColor = Colors.white,
    this.isShowCycleWidget =true,
    this.isShowTextInfoWidget =true,
    this.onTap,
  }) : super(key: key);

  final List<Widget> banners;
  final GestureTapCallback onTap;

  //whether cycyle rolling
  final bool cycleRolling;
  final bool isShowCycleWidget;
  final bool isShowTextInfoWidget;

  //whether auto rolling
  final bool autoRolling;
  final bool hasTextinfo;

  //init index
  final int initIndex;

  //switch interval
  final Duration intervalDuration;
  final Curve curve;

  //animation duration
  final Duration animationDuration;

  final ValueChanged onPageChanged;

  final double height;
  final Color textBackgroundColor;
  final double pointRadius;
  final Color selectedColor;
  final Color unSelectedColor;

  final TextInfo itemTextInfo;

  @override
  State<StatefulWidget> createState() => BannerViewState();
}

class BannerViewState extends State<BannerView>
    with SingleTickerProviderStateMixin {
  List<Widget> _originBanners = [];
  List<Widget> _banners = [];
  PageController _pageController;
  int _currentIndex = 0;
  Duration _duration;

  bool isStartScroll = false;

  Timer timer;

  Animation<double> animation;
  Animation<double> opacityAnimation;
  AnimationController controller;
  var pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    CurvedAnimation curvedAnimation = new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = new Tween(begin: 0.0, end: 30.0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    opacityAnimation = new Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);
    controller.forward();

    initDtata();
  }

  void initDtata() {
    _originBanners.clear();
    _banners.clear();
    _originBanners = widget.banners;
     _banners = this._banners..addAll(_originBanners);
    //是否循环滚动
    if (widget.cycleRolling) {
      Widget first = this._originBanners[0];
      Widget last = this._originBanners[this._originBanners.length - 1];

      this._banners.insert(0, last);
      this._banners.add(first);
      this._currentIndex = widget.initIndex + 1;
    } else {
      this._currentIndex = widget.initIndex;
    }

    this._duration = widget.intervalDuration;
    this._pageController = PageController(initialPage: this._currentIndex);
    _pageController.addListener(() {
      setState(() {
        controller.reset();
        isStartScroll = true;
      });
    });
    this._nextBannerTask();
  }

  Timer _timer;

  void _nextBannerTask() {
    if (!mounted) {
      return;
    }

    if (!widget.autoRolling) {
      this._cancel(manual: false);
      return;
    }

    this._cancel(manual: false);

    //security check[for fuck the gesture notification handle]
    if (_seriesUserScrollRecordCount != 0) {
      return;
    }
    _timer = new Timer(_duration, () {
      this._doChangeIndex();
    });
  }

  bool _canceledByManual = false;

  /// [manual] 是否手动停止
  void _cancel({bool manual = false}) {
    _timer?.cancel();
    if (manual) {
      this._canceledByManual = true;
    }
  }

  void _doChangeIndex({bool increment = true}) {
    if (!mounted) {
      return;
    }
    this._canceledByManual = false;
    if (increment) {
      this._currentIndex++;
    } else {
      this._currentIndex--;
    }
    this._currentIndex = this._currentIndex % this._banners.length;
    if (0 == this._currentIndex) {
      this._pageController.jumpToPage(this._currentIndex);
      this._nextBannerTask();
      setState(() {});
    } else {
      this
          ._pageController
          .animateToPage(
            this._currentIndex,
            duration: widget.animationDuration,
            curve: widget.curve,
          )
          .whenComplete(() {
        isStartScroll = false;
        setState(() {
          controller.forward();
        });
        if (!mounted) {
          return;
        }
      });
    }
  }

  initTextHeight() {
    setState(() {
      isStartScroll = false;
      controller.forward();
    });
  }

  @override
  void didUpdateWidget(BannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    initDtata();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: widget.height == null ? 180.0 : widget.height,
      child: Stack(
        children: <Widget>[
          _buildViewPage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: isStartScroll
                ? Container()
                : Opacity(
                    opacity: opacityAnimation.value,
                    child: widget.hasTextinfo? Container(
                      width: MediaQuery.of(context).size.width,
                      height: widget.isShowTextInfoWidget?animation.value:0,
                      padding: EdgeInsets.only(right: 8.0,left: 8.0,top: 8.0,bottom: 8.0),
                      color: widget.textBackgroundColor,
                      child: _bannerTextInfoWidget(),
                    ):Container(),
                  ),
          ),
          widget.isShowCycleWidget?
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _builderCriInd(),
            ),
          ):Container(),
        ],
      ),
    );
  }

//tack the user scroll callback count in a series
  int _seriesUserScrollRecordCount = 0;

  Widget _buildViewPage() {
    Widget pageView = PageView.builder(
        itemCount: _banners.length,
        controller: _pageController,
        onPageChanged: onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          Widget widgetBanner = _banners[index];
          return GestureDetector(
            child: widgetBanner,
            onTap:widget.onTap,
            onTapDown: (details) {
              this._cancel(manual: true);
            },
          );
        });
    return new NotificationListener(
      child: pageView,
      onNotification: (notification) {
        this._handleScrollNotification(notification);
      },
    );
  }

  _handleScrollNotification(Notification notification) {
    if (notification is UserScrollNotification) {
      _handleUserScroll(notification);
    } else if (notification is ScrollUpdateNotification) {
      _handleOtherScroll(notification);
    }
  }

  _handleUserScroll(UserScrollNotification notification) {
    UserScrollNotification sn = notification;
    PageMetrics pm = sn.metrics;
    var depth = sn.depth;
    var page = pm.page;
    var left = page == .0 ? .0 : page % (page.round());
    if (_seriesUserScrollRecordCount == 0) {
      //用户手动滑动开始
      this._cancel(manual: true);
    }
    if (depth == 0) {
      if (left == 0) {
        if (_seriesUserScrollRecordCount != 0) {
          //用户手动滑动结束
          setState(() {
            isStartScroll = false;
            controller.forward();
            _seriesUserScrollRecordCount = 0;
            _canceledByManual = false;
            _resetWhenAtEdge(pm);
          });
          this._nextBannerTask();
        } else {
          _seriesUserScrollRecordCount++;
        }
      } else {
        _seriesUserScrollRecordCount++;
      }
    }
  }

  _resetWhenAtEdge(PageMetrics pm) {
    if (null == pm || !pm.atEdge) {
      return;
    }
    if (!widget.cycleRolling) {
      return;
    }
    try {
      if (_currentIndex == 0) {
        _pageController.jumpToPage(this._banners.length - 2);
      } else if (this._currentIndex == this._banners.length - 1) {
        _pageController.jumpToPage(1);
      }
//      print("_resetWhenAtEdge");
      initTextHeight();
    } catch (e) {
      print('Exception: ${e?.toString()}');
    }
  }

  _handleOtherScroll(ScrollUpdateNotification notification) {
    ScrollUpdateNotification sn = notification;
    if (widget.cycleRolling && sn.metrics.atEdge) {
      if (this._canceledByManual) {
        return;
      }
      _resetWhenAtEdge(sn.metrics);
    }
  }

  Widget _bannerTextInfoWidget() {
    return Opacity(opacity: opacityAnimation.value,
    child: Text(widget.itemTextInfo==null?"":widget.itemTextInfo(_currentIndex)==null?"":widget.itemTextInfo(_currentIndex),
      style: TextStyle(color: Colors.white,fontSize: 12.0),));
  }

  List<Widget> _builderCriInd() {
    List<Widget> circle = [];
    int index =
        widget.cycleRolling ? this._currentIndex - 1 : this._currentIndex;
    index = index <= 0 ? 0 : index;
    for (var i = 0; i < widget.banners.length; i++) {
      circle.add(Container(
        margin: EdgeInsets.only(left: 0.0, top: 0.0, right: 4.0, bottom: 10.0),
        width: widget.pointRadius * 2,
        height: widget.pointRadius * 2,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: index == i ? widget.selectedColor : widget.unSelectedColor,
        ),
      ));
    }
    return circle;
  }

  onPageChanged(index) {
    this._currentIndex = index;
    if (!(this._timer?.isActive ?? false)) {
      this._nextBannerTask();
    }
    setState(() {});
    if (null != widget.onPageChanged) {
      widget.onPageChanged(index);
    }
  }
}
