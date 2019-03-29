import 'dart:async';
import 'package:flutter/services.dart';
import 'package:show_time_for_flutter/modul/local_song.dart';
import 'dart:convert' ;
import 'package:show_time_for_flutter/net/net_utils.dart';
import 'package:dio/dio.dart';
import 'package:show_time_for_flutter/modul/music/recommend_music.dart';
import 'package:show_time_for_flutter/modul/music/rank_data.dart';
import 'package:show_time_for_flutter/modul/music/song_list.dart';
import 'package:show_time_for_flutter/modul/music/rank_list_data.dart';
import 'package:show_time_for_flutter/modul/music/net_song.dart';
import 'package:show_time_for_flutter/modul/music/search_music.dart';


String MUSIC_URL_FROM = "webapp_music";
String MUSIC_URL_FORMAT = "json";
String MUSIC_URL_METHOD_GEDAN = "baidu.ting.diy.gedan";
String MUSIC_URL_METHOD_RANKINGLIST = "baidu.ting.billboard.billCategory";
int MUSIC_URL_RANKINGLIST_FLAG = 1;
String MUSIC_URL_METHOD_SONGLIST_DETAIL = "baidu.ting.diy.gedanInfo";
String MUSIC_URL_METHOD_RANKING_DETAIL = "baidu.ting.billboard.billList";
String MUSIC_URL_FROM_2 = "android";
String MUSIC_URL_VERSION = "5.6.5.6";
String MUSIC_URL_METHOD_SONG_DETAIL = "baidu.ting.song.play";
//http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.search.common&query=%E9%81%87%E8%A7%81&page_size=30&page_no=1&format=xml
String MUSIC_URL_METHOD_SONG_SEARCH = "baidu.ting.search.common";
int pageSize = 40;
int startPage = 0;

//播放的模式
int LIST_MODE = 0;
int SINGO_MODE = 1;
int SHUFFLE_MODE = 2;
String MUSIC_MODE = "MUSICMODE";

String CURRENT_MILL_TIME = "currentstime";
String CURRENT_MILL_TIME_FUNNY = "currentstimefunny";

class MusicService {
  NetUtils musicUtils;
  Dio musicClient;
  static const MethodChannel _channel = const MethodChannel('local/songs');

  MusicService() {
    musicUtils = NetUtils();
    musicClient = musicUtils.getMusicBaseClient();
  }

  Future<List<Song>> allLocalSongs() async {
    String _message; // 1
    try {
      var result =
      await _channel.invokeMethod('getSongs'); // 2
      var json = jsonDecode(result);
      List<Song> songs = getSongList(json);
      return songs;
    } on PlatformException catch (e) {
      _message = "Sadly I can not change your life: ${e.message}.";
    }
  }

  Future<RecommendMusicData> getRecommendMusics(int page_no) async {
    String format = MUSIC_URL_FORMAT;
    String from = MUSIC_URL_FROM;
    String method = MUSIC_URL_METHOD_GEDAN;
    int page_size = pageSize;
    try {
      //404
      var response =
      await musicClient.get(
          "/ting?format=$format&from=$from&method=$method&page_size=$page_size&page_no=$page_no");
      var recommendMusicData = RecommendMusicData.fromJson(response.data);
      return recommendMusicData;
    } on DioError catch (e) {
      printError(e);
    }
  }

  Future<RankingListItem> getRankMusics() async {
    String format = MUSIC_URL_FORMAT;
    String from = MUSIC_URL_FROM;
    String method = MUSIC_URL_METHOD_RANKINGLIST;
    int kflag = MUSIC_URL_RANKINGLIST_FLAG;
    try {
      //404
      var response =
      await musicClient.get(
          "/ting?format=$format&from=$from&method=$method&kflag=$kflag");
      var rankMusicData = RankingListItem.fromJson(response.data);
      return rankMusicData;
    } on DioError catch (e) {
      printError(e);
    }
  }

  //获取某个歌单的信息
  Future<SongListDetail> getListMusics(String listid) async {
    String format = MUSIC_URL_FORMAT;
    String from = MUSIC_URL_FROM;
    String method = MUSIC_URL_METHOD_SONGLIST_DETAIL;
    try {
      //404
      var response =
      await musicClient.get(
          "/ting?format=$format&from=$from&method=$method&listid=$listid");
      var songMusicsData = SongListDetail.fromJson(response.data);
      return songMusicsData;
    } on DioError catch (e) {
      printError(e);
    }
  }

  //获取排行榜的信息
  Future<RankingListDetail> getRankListMusics(int listType) async {
    String fields = encode(
        "song_id,title,author,album_title,pic_big,pic_small,havehigh,all_rate," +
            "charge,has_mv_mobile,learn,song_source,korean_bb_song");
    String format = MUSIC_URL_FORMAT;
    String from = MUSIC_URL_FROM;
    String method = MUSIC_URL_METHOD_RANKING_DETAIL;
    int offset = 0;
    int size = 100;
    try {
      //404
      var response =
      await musicClient.get(
          "/ting?format=$format&from=$from&method=$method&type=$listType&offset=$offset&size=$size&fields=$fields");
      var rankListMusicsData = RankingListDetail.fromJson(response.data);
      return rankListMusicsData;
    } on DioError catch (e) {
      printError(e);
    }
  }
  //获取歌曲详情
  Future<SongDetailInfo> getSong(String songid) async {
    String version = MUSIC_URL_VERSION;
    String format = MUSIC_URL_FORMAT;
    String from = MUSIC_URL_FROM_2;
    String method = MUSIC_URL_METHOD_SONG_DETAIL;
    try {
      //404
      var response =
      await musicClient.get(
          "/ting?from=$from&version=$version&format=$format&method=$method&songid=$songid");
      var songData = SongDetailInfo.fromJson(response.data);
      return songData;
    } on DioError catch (e) {
      printError(e);
    }
  }
  //获取搜索结果
  Future<MusicSearchList> getSearchSons(String query) async {
    int page_no = 1;
    String format = MUSIC_URL_FORMAT;
    int page_size = 50;
    String method = MUSIC_URL_METHOD_SONG_SEARCH;
    try {
      //404
      var response =
      await musicClient.get(
          "/ting?method=$method&query=$query&page_size=$page_size&page_no=$page_no&format=$format");
      var songSarchData = MusicSearchList.fromJson(response.data);
      return songSarchData;
    } on DioError catch (e) {
      printError(e);
    }
  }

  printError(DioError e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.request);
      print(e.message);
    }
  }

  String encode(String encode) {
    if (encode == null) return "";

    try {
      return Uri.encodeQueryComponent(encode);
    } catch (e) {
      print(e.message);
    }
  }
}