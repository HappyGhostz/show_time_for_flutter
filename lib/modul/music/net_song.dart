/**
 * @author zcp
 * @date 2019/3/28
 * @Description
 */

class SongDetailInfo {
  /**
   * songinfo : {"special_type":0,"pic_huge":"","resource_type":"0","pic_premium":"http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg","havehigh":2,"author":"杨钰莹","toneid":"600902000007964201","has_mv":1,"song_id":"2121687","piao_id":"0","artist_id":"999","lrclink":"http://musicdata.baidu.com/data2/lrc/242441098/242441098.lrc","relate_status":"0","learn":1,"pic_big":"http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg@s_0,w_150","play_type":0,"album_id":"2121650","album_title":"也是情歌精选","bitrate_fee":"{\"0\":\"0|0\",\"1\":\"0|0\"}","song_source":"web","all_artist_id":"999","all_artist_ting_uid":"1451","all_rate":"31,64,128,192,256,320,flac","charge":0,"copy_type":"0","is_first_publish":0,"korean_bb_song":"0","pic_radio":"http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg@s_0,w_300","has_mv_mobile":0,"title":"轻轻地告诉你","pic_small":"http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg@s_0,w_90","album_no":"19","resource_type_ext":"0","ting_uid":"1451"}
   * error_code : 22000
   * bitrate : {"show_link":"http://zhangmenshiting.baidu.com/data2/music/134347684/134347684.mp3?xcode=294ea175cde8d4e6c6826868de970894","free":1,"song_file_id":66185015,"file_size":2244272,"file_extension":"mp3","file_duration":280,"file_bitrate":64,"file_link":"http://yinyueshiting.baidu.com/data2/music/134347684/134347684.mp3?xcode=294ea175cde8d4e6c6826868de970894","hash":"1203b61337d84097ba8f5b5591d107ec2b13c01e"}
   */

  SonginfoBean songinfo;
  int error_code;
  BitrateBean bitrate;

  SongDetailInfo(this.songinfo, this.error_code, this.bitrate);

  factory SongDetailInfo.fromJson(Map<String, dynamic> json) {
    var songInfoJson = json["songinfo"];
    SonginfoBean songinfoBean = SonginfoBean.fromJson(songInfoJson);
    var bitrateJson = json["bitrate"];
    BitrateBean bitrateBean = BitrateBean.fromJson(bitrateJson);
    return SongDetailInfo(songinfoBean, json["error_code"], bitrateBean);
  }
}

class SonginfoBean {
  /**
   * special_type : 0
   * pic_huge :
   * resource_type : 0
   * pic_premium : http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg
   * havehigh : 2
   * author : 杨钰莹
   * toneid : 600902000007964201
   * has_mv : 1
   * song_id : 2121687
   * piao_id : 0
   * artist_id : 999
   * lrclink : http://musicdata.baidu.com/data2/lrc/242441098/242441098.lrc
   * relate_status : 0
   * learn : 1
   * pic_big : http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg@s_0,w_150
   * play_type : 0
   * album_id : 2121650
   * album_title : 也是情歌精选
   * bitrate_fee : {"0":"0|0","1":"0|0"}
   * song_source : web
   * all_artist_id : 999
   * all_artist_ting_uid : 1451
   * all_rate : 31,64,128,192,256,320,flac
   * charge : 0
   * copy_type : 0
   * is_first_publish : 0
   * korean_bb_song : 0
   * pic_radio : http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg@s_0,w_300
   * has_mv_mobile : 0
   * title : 轻轻地告诉你
   * pic_small : http://musicdata.baidu.com/data2/pic/f8f2bac1a7444d6385d9e16f57e8afb5/261991690/261991690.jpg@s_0,w_90
   * album_no : 19
   * resource_type_ext : 0
   * ting_uid : 1451
   */

  int special_type;

  String pic_huge;

  String resource_type;

  String pic_premium;

  int havehigh;

  String author;

  String toneid;

  int has_mv;

  String song_id;

  String piao_id;

  String artist_id;
  String lrclink;
  String relate_status;
  int learn;
  String pic_big;
  int play_type;

  String album_id;
  String album_title;

  String bitrate_fee;

  String song_source;

  String all_artist_id;

  String all_artist_ting_uid;

  String all_rate;
  int charge;

  String copy_type;

  int is_first_publish;

  String korean_bb_song;
  String pic_radio;

  int has_mv_mobile;
  String title;
  String pic_small;

  String album_no;

  String resource_type_ext;

  String ting_uid;

  SonginfoBean(
    this.special_type,
    this.pic_huge,
    this.resource_type,
    this.pic_premium,
    this.havehigh,
    this.author,
    this.toneid,
    this.has_mv,
    this.song_id,
    this.piao_id,
    this.artist_id,
    this.lrclink,
    this.relate_status,
    this.learn,
    this.pic_big,
    this.play_type,
    this.album_id,
    this.album_title,
    this.bitrate_fee,
    this.song_source,
    this.all_artist_id,
    this.all_artist_ting_uid,
    this.all_rate,
    this.charge,
    this.copy_type,
    this.is_first_publish,
    this.korean_bb_song,
    this.pic_radio,
    this.has_mv_mobile,
    this.title,
    this.pic_small,
    this.album_no,
    this.resource_type_ext,
    this.ting_uid,
  );

  factory SonginfoBean.fromJson(Map<String, dynamic> json) {
    return SonginfoBean(
      json["special_type"],
      json["pic_huge"],
      json["resource_type"],
      json["pic_premium"],
      json["havehigh"],
      json["author"],
      json["toneid"],
      json["has_mv"],
      json["song_id"],
      json["piao_id"],
      json["artist_id"],
      json["lrclink"],
      json["relate_status"],
      json["learn"],
      json["pic_big"],
      json["play_type"],
      json["album_id"],
      json["album_title"],
      json["bitrate_fee"],
      json["song_source"],
      json["all_artist_id"],
      json["all_artist_ting_uid"],
      json["all_rate"],
      json["charge"],
      json["copy_type"],
      json["is_first_publish"],
      json["korean_bb_song"],
      json["pic_radio"],
      json["has_mv_mobile"],
      json["title"],
      json["pic_small"],
      json["album_no"],
      json["resource_type_ext"],
      json["ting_uid"],
    );
  }
}

class BitrateBean {
  /**
   * show_link : http://zhangmenshiting.baidu.com/data2/music/134347684/134347684.mp3?xcode=294ea175cde8d4e6c6826868de970894
   * free : 1
   * song_file_id : 66185015
   * file_size : 2244272
   * file_extension : mp3
   * file_duration : 280
   * file_bitrate : 64
   * file_link : http://yinyueshiting.baidu.com/data2/music/134347684/134347684.mp3?xcode=294ea175cde8d4e6c6826868de970894
   * hash : 1203b61337d84097ba8f5b5591d107ec2b13c01e
   */

  String show_link;

  int free;

  int song_file_id;

  int file_size;

  String file_extension;

  int file_duration;

  int file_bitrate;
  String file_link;

  String hash;

  BitrateBean(
    this.show_link,
    this.free,
    this.song_file_id,
    this.file_size,
    this.file_extension,
    this.file_duration,
    this.file_bitrate,
    this.file_link,
    this.hash,
  );

  factory BitrateBean.fromJson(Map<String, dynamic> json) {
    return BitrateBean(
      json["show_link"],
      json["free"],
      json["song_file_id"],
      json["file_size"],
      json["file_extension"],
      json["file_duration"],
      json["file_bitrate"],
      json["file_link"],
      json["hash"],
    );
  }
}
