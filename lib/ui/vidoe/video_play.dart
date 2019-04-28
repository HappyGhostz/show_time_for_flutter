import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:show_time_for_flutter/net/video_service.dart';
import 'package:show_time_for_flutter/modul/video/video_detail.dart';
import 'dart:ui';
import 'package:show_time_for_flutter/utils/string_format.dart';
import 'dart:async';

/**
 * @author zcp
 * @date 2019/4/28
 * @Description
 */

class VideoPlayPage extends StatefulWidget {
  VideoPlayPage({
    Key key,
    @required this.videoId,
  }) : super(key: key);
  String videoId;

  @override
  State<StatefulWidget> createState() => VideoPlayPageState();
}

class VideoPlayPageState extends State<VideoPlayPage> {
  VideoPlayerController _controller;
  VideoServices _videoServices = VideoServices();
  Content content;
  String url = "";
  VideoPlayerValue _latestValue;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _showTimer;

  @override
  void initState() {
    super.initState();
    getVideoPath(widget.videoId);
    _showTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _hideStuff = false;
      });
    });
  }

  void getVideoPath(String id) async {
    VideoDetail _videoDetail = await _videoServices.getVideoDetailInfo(id);
    content = _videoDetail?.content;
    var videos = content?.videos;
    for (int i = 0; i < videos.length; i++) {
      var video = videos[i];
      if (video.tag == "sd") {
        url = video.url;
      }
    }
    setState(() {
      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
      _controller.setLooping(true);
      _controller.addListener(_updateState);
      _updateState();
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = _controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: (_controller != null && _controller.value.initialized)
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            constraints: BoxConstraints.expand(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              constraints: BoxConstraints.expand(),
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          Center(
              child: GestureDetector(
            onTap: () {
              _cancelAndRestartTimer();
            },
            child: AbsorbPointer(
              absorbing: _hideStuff,
              child: Stack(
                children: <Widget>[
                  (_controller != null && _controller.value.initialized)
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                  _buildBottomControll(context),
                ],
              ),
            ),
          )),
          Container(
            margin: EdgeInsets.only(left: 16.0, top: 40.0),
            child: Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  margin: EdgeInsets.only(right: 10.0),
                ),
                Text(
                  content == null ? "视频" : content.name,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _playPause();
        },
        child: Icon(
          (_controller != null && _controller.value.isPlaying)
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        _controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!_controller.value.initialized) {
          _controller.initialize().then((_) {
            _controller.play();
          });
        } else {
          _controller.play();
        }
      }
    });
  }
  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }
  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
    });
  }
  Widget _buildBottomControll(BuildContext context) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;
    return
      Positioned(
          bottom: 10.0,
          right: 10.0,
          left: 10.0,
          child: AnimatedOpacity(
            opacity: _hideStuff ? 0.0 : 1.0,
            duration: Duration(milliseconds: 300),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: Text(
                    StringUtils.formatDuration(position),
                    style: TextStyle(color: Colors.white),
                  )),
                  Expanded(
                    flex: 6,
                      child: _buildProgressBar(position,duration)),
                  Expanded(child: Text(
                    StringUtils.formatDuration(duration),
                    style: TextStyle(color: Colors.white),
                  )),
                ],
              ),
            ),
          ));
  }

  @override
  void dispose() {
    if (_controller != null) {
      _dispose();
    }
    super.dispose();
  }
  void _dispose() {
    _controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _showTimer?.cancel();
    _controller.dispose();
  }
 Widget  _buildProgressBar(Duration position,Duration  doution) {
    return Slider(
        activeColor: Colors.red,
        value: position.inSeconds.toDouble(),
        max: doution.inSeconds.toDouble(),
        onChanged: (newValue) {
          _controller.seekTo(Duration(seconds: newValue.toInt()));
        });
 }
}
