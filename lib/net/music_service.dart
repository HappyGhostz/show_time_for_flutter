import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/modul/local_song.dart';
import 'dart:convert';

class MusicService{
  static const MethodChannel _channel = const MethodChannel('local/songs');
  MusicService() {
//    newsUtils = NetUtils();
//    newsClient = newsUtils.getNewsBaseClient();
  }
  Future<List<Song>> allLocalSongs() async {
    String _message; // 1
    try {
      var  result =
      await _channel.invokeMethod('getSongs');// 2
      var json = jsonDecode(result);
      List<Song> songs = getSongList(json);
      return songs;
    } on PlatformException catch (e) {
      _message = "Sadly I can not change your life: ${e.message}.";
    }
  }
}