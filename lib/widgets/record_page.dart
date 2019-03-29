import 'package:flutter/material.dart';
import 'dart:io';
import 'package:show_time_for_flutter/utils/image_utils.dart';
/**
 * @author zcp
 * @date 2019/3/27
 * @Description
 */

class RecordAnimate extends AnimatedWidget {
  RecordAnimate(
      {Key key, this.isLocal, this.albumSrc, Animation<double> animation})
      : super(key: key, listenable: animation);
  bool isLocal;
  String albumSrc;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width - width * 0.24,
      height: width - width * 0.24,
      child: RotationTransition(
        turns: animation,
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset("assets/images/play_disc.png"),
            ),
            Center(
              child: ClipOval(
                child: Container(
                  width: width - width * 0.48,
                  height: width - width * 0.48,
                  child: isLocal
                      ? (albumSrc==null)?Image.asset("assets/images/music_local_default.png"):Image.file(new File(albumSrc))
                      : ImageUtils.showFadeImage(albumSrc, BoxFit.cover),
                ),
              )
              ,
            )
          ],
        ),
      ),
    );
  }
}
