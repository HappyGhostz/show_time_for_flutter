import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_time_for_flutter/utils/string_format.dart';

/**
 * @author zcp
 * @date 2019/3/28
 * @Description
 */
String  MUSIC_MODE = "MUSICMODE";
//播放的模式
int  LIST_MODE = 0;
int SINGO_MODE = 1;
int SHUFFLE_MODE = 2;
class Player extends StatefulWidget {
  /// [AudioPlayer] 播放地址
  final String audioUrl;

  /// 音量
  final double volume;

  /// 错误回调
  final Function(String) onError;

  ///播放完成
  final Function(int playMode) onCompleted;

  /// 上一首
  final Function(int playMode) onPrevious;

  ///下一首
  final Function(int playMode) onNext;

  final Function(bool) onPlaying;

  final Key key;

  final Color color;
  final Color sliderColor;

  /// 是否是本地资源
  final bool isLocal;

  Player(
      {@required this.audioUrl,
      @required this.onCompleted,
      @required this.onError,
      @required this.onNext,
      @required this.onPrevious,
      this.key,
      this.volume: 1.0,
      this.onPlaying,
      this.color: Colors.white,
      this.sliderColor: Colors.redAccent,
      this.isLocal: false});

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  AudioPlayer audioPlayer;
  bool isPlaying = false;
  double sliderValue;
  Duration duration;
  Duration position;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  int mCurrentMode = 0;
  bool isFromHandlerPlay =false;

  @override
  void initState() {
    super.initState();
    Future<int> mode = get();
    mode.then((int mode) {
      if(mode==null){
        mCurrentMode=0;
      }else{
        mCurrentMode=mode;
      }
    });
    audioPlayer = new AudioPlayer();
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        this.position = position;
        if (duration != null) {
          this.sliderValue = (position.inSeconds / duration.inSeconds);
        }
      });
    });
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          this.duration = audioPlayer.duration;
          if (position != null) {
            this.sliderValue = (position.inSeconds / duration.inSeconds);
          }
        });
      } else if (state == AudioPlayerState.COMPLETED) {
        isFromHandlerPlay=false;
        widget.onCompleted(mCurrentMode);
      }
    }, onError: (msg) {
      widget.onError(msg);
    });
  }
  save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(MUSIC_MODE, mCurrentMode);
  }

  Future<int> get() async {
    var mCurrentMode;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    mCurrentMode = prefs.getInt(MUSIC_MODE);
    return mCurrentMode;
  }
  @override
  void deactivate() {
    audioPlayer.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        buildRowTimer(),
        buildControllers(),
      ],
    );
  }
  Widget upDataMusicMode(){
    String url ="";
    if(mCurrentMode==SINGO_MODE){
      url= "assets/images/play_icn_one.png";
    }else if(mCurrentMode==LIST_MODE){
      url= "assets/images/play_icn_loop.png";
    }else if(mCurrentMode==SHUFFLE_MODE){
      url= "assets/images/play_icn_shuffle.png";
    }else if(mCurrentMode==SHUFFLE_MODE){
      url= "assets/images/play_icn_loop.png";
    }
    return Image.asset(url,fit: BoxFit.cover,
      height: 48,);
  }
  Widget buildControllers() {
    if(!isFromHandlerPlay){
      play(widget.audioUrl, widget.isLocal);
    }
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GestureDetector(
            child: Container(
              child: upDataMusicMode(),
            ),
            onTap: (){
              mCurrentMode = ++mCurrentMode % 3;
              save();
              setState(() {
              });
            },
          ),
          new IconButton(
            onPressed: () {
              stop();
              isFromHandlerPlay=false;
              widget.onPrevious(mCurrentMode);
            },
            icon: new Icon(
              Icons.skip_previous,
              size: 32.0,
              color: widget.color,
            ),
          ),
          new IconButton(
            onPressed: () {
              if (isPlaying)
                pause();
              else {
                play(widget.audioUrl, widget.isLocal);
              }
              isFromHandlerPlay=true;
              setState(() {
                isPlaying = !isPlaying;
                widget.onPlaying(isPlaying);
              });
            },
            padding: const EdgeInsets.all(0.0),
            icon: new Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 48.0,
              color: widget.color,
            ),
          ),
          new IconButton(
            onPressed: (){
              stop();
              isFromHandlerPlay=false;
              widget.onNext(mCurrentMode);
            },
            icon: new Icon(
              Icons.skip_next,
              size: 32.0,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Center(
                child: new Text(
                  position == null ? "--:--" : StringUtils.formatDuration(position),
                  style: TextStyle(color: widget.color),
                ),
              ),
            )),
        Expanded(
            flex: 6,
            child: Slider(
                activeColor: widget.sliderColor,
                value: sliderValue ?? 0.0,
                onChanged: (newValue) {
                  if (duration != null) {
                    int seconds = (duration.inSeconds * newValue).round();
                    print("audioPlayer.seek: $seconds");
                    audioPlayer.seek(seconds.toDouble());
                  }
                })),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Center(
                child: new Text(
                  duration == null ? "--:--" : StringUtils.formatDuration(duration),
                  style: TextStyle(color: widget.color),
                ),
              ),
            )),
      ],
    );
  }


  Future<void> play(String url,bool islocal) async {
    await audioPlayer.play(url,isLocal: islocal);
    isPlaying = true;
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }
}
