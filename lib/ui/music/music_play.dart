import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:show_time_for_flutter/widgets/record_page.dart';
import 'package:show_time_for_flutter/widgets/needle_animate.dart';
import 'package:show_time_for_flutter/widgets/player.dart';
import 'package:show_time_for_flutter/modul/local_song.dart';

/**
 * @author zcp
 * @date 2019/3/27
 * @Description
 */
class MusicPlayPage extends StatefulWidget {
  MusicPlayPage({
    Key key,
    @required this.mp3Url,
    @required this.songs,
    @required this.countIndex,
    this.albumSrc,
    this.title,
    this.isLocal,
  }) : super(key: key);
  String albumSrc;
  String title;
  String mp3Url;
  bool isLocal;
  List<Song> songs;
  int countIndex;

  @override
  State<StatefulWidget> createState() => MusicPlayPageState();
}

class MusicPlayPageState extends State<MusicPlayPage>
    with TickerProviderStateMixin {
  AnimationController controller_record;
  Animation<double> animation_record;

  Animation<double> animation_needle;
  AnimationController controller_needle;

  final _rotateTween = new Tween<double>(begin: -0.15, end: 0.0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  String currentMp3 = "";
  int index = 0;
  int preViousIndex = 0;
  String albumSrc;
  String title;

  @override
  void initState() {
    super.initState();
    currentMp3 = widget.mp3Url;
    index = widget.countIndex;
    albumSrc = widget.albumSrc;
    title = widget.title;
    initAnimate();
  }

  void initAnimate() {
    controller_record = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animation_record =
        new CurvedAnimation(parent: controller_record, curve: Curves.linear);

    controller_needle = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation_needle =
        new CurvedAnimation(parent: controller_needle, curve: Curves.linear);

    animation_record.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller_record.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controller_record.forward();
      }
    });
    controller_record.forward();
    controller_needle.forward();
  }

  @override
  void dispose() {
    controller_record.dispose();
    controller_needle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: albumSrc == null
                      ? AssetImage("assets/images/music_local_default.png")
                      : widget.isLocal
                          ? FileImage(new File(albumSrc))
                          : NetworkImage(albumSrc),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                    Colors.black54,
                    BlendMode.overlay,
                  ),
                ),
              ),
            ),
            new Container(
                child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Opacity(
                opacity: 0.6,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
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
                    title == null ? "歌曲" : title.replaceAll(".mp3", ""),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                child: RecordAnimate(
                  animation: _commonTween.animate(controller_record),
                  albumSrc: albumSrc,
                  isLocal: widget.isLocal,
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              right: 80.0,
              child: new Container(
                child: new NeedleAnimatePage(
                  animation: _rotateTween.animate(controller_needle),
                  alignment: FractionalOffset.topLeft,
                  child: new Container(
                    width: 100.0,
                    child: Image.asset("assets/images/play_needle.png"),
                  ),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: new Player(
                onError: (e) {
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      content: new Text(e),
                    ),
                  );
                },
                onPrevious: (int playMode) {
                  _onPreVious(playMode);
                },
                onNext: (int playMode) {
                  _onNext(playMode);
                },
                onCompleted: (int playMode) {
                  _onNext(playMode);
                },
                onPlaying: (isPlaying) {
                  if (isPlaying) {
                    controller_record.forward();
                    controller_needle.forward();
                  } else {
                    controller_record.stop(canceled: false);
                    controller_needle.reverse();
                  }
                },
                color: Colors.white,
                audioUrl: currentMp3,
                isLocal: widget.isLocal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onNext(int playMode) {
    if (controller_record.isDismissed || controller_needle.isDismissed) {
      controller_record.forward();
      controller_needle.forward();
    }
    if (playMode == LIST_MODE) {
      preViousIndex = index;
      index = index == widget.songs.length - 1 ? 0 : ++index;
      var song = widget.songs[index];
      updataMusic(song);
      setState(() {});
    } else if (playMode == SINGO_MODE) {
      var song = widget.songs[index];
      updataMusic(song);
      setState(() {});
    } else if (playMode == SHUFFLE_MODE) {
      preViousIndex = index;
      var random = Random();
      var randomPosition = random.nextInt(widget.songs.length - 1);
      while (randomPosition == index) {
        randomPosition = random.nextInt(widget.songs.length - 1);
      }
      index = randomPosition;
      var song = widget.songs[index];
      updataMusic(song);
      setState(() {});
    }
  }

  void updataMusic(Song song) {
    title = song.title;
    albumSrc = song.albumArt;
    currentMp3 = song.url;
  }

  _onPreVious(int playMode) {
    if (controller_record.isDismissed || controller_needle.isDismissed) {
      controller_record.forward();
      controller_needle.forward();
    }
    if (playMode == LIST_MODE) {
      preViousIndex = index;
      index = index == 0 ? widget.songs.length - 1 : --index;
      var song = widget.songs[index];
      updataMusic(song);
      setState(() {});
    } else if (playMode == SINGO_MODE) {
      var song = widget.songs[index];
      updataMusic(song);
      setState(() {});
    } else if (playMode == SHUFFLE_MODE) {
      preViousIndex = index;
      var random = Random();
      var randomPosition = random.nextInt(widget.songs.length - 1);
      while (randomPosition == index) {
        randomPosition = random.nextInt(widget.songs.length - 1);
      }
      index = randomPosition;
      var song = widget.songs[index];
      updataMusic(song);
      setState(() {});
    }
  }
}
