
import 'package:show_time_for_flutter/modul/news_info.dart';

class SpecialNews {
  NewsSpecialInfo newsSpecialInfo;

  SpecialNews(
    this.newsSpecialInfo,
  );

  factory SpecialNews.fromJson(String specialId, Map<String, dynamic> srcJson) {
    var json = srcJson["$specialId"];
    var newsSpecialInfo = NewsSpecialInfo.fromJson(json);
    return SpecialNews(newsSpecialInfo);
  }
}

class NewsSpecialInfo {
  List<dynamic> headpics;

  int supportGentie;

  List<dynamic> topicspatch;

  int supportEmoji;

  int del;

  String lmodify;

  String gentieId;

  String type;

  String sid;

  String bigBanner;

  String digest;

  String tag;

  String imgsrc;

  String pushTime;

  String ptime;

  String ec;

//  List<Topicslatest> topicslatest;

  String skipcontent;

  List<dynamic> topicsplus;

  List<Topics> topics;

  String banner;

  String sdocid;

  String sname;

  List<dynamic> webviews;

  String photoset;

  String shownav;

  NewsSpecialInfo(
    this.headpics,
    this.supportGentie,
    this.topicspatch,
    this.supportEmoji,
    this.del,
    this.lmodify,
    this.gentieId,
    this.type,
    this.sid,
    this.bigBanner,
    this.digest,
    this.tag,
    this.imgsrc,
    this.pushTime,
    this.ptime,
    this.ec,
//    this.topicslatest,
    this.skipcontent,
    this.topicsplus,
    this.topics,
    this.banner,
    this.sdocid,
    this.sname,
    this.webviews,
    this.photoset,
    this.shownav,
  );

  factory NewsSpecialInfo.fromJson(Map<String, dynamic> srcJson) {
    List<Topicslatest> topicslatests = (srcJson['topicslatest'] as List)
        ?.map((e) => e == null
        ? null
        : Topicslatest.fromJson(e as Map<String, dynamic>))
        ?.toList();
    List<Topics> topics = (srcJson['topics'] as List)?.map((e) =>
    e == null ? null : Topics.fromJson(e as Map<String, dynamic>))
        ?.toList();
    for(int i=0;i<topicslatests.length;i++){
      Topicslatest topicslatest = topicslatests[i];
      Topics topic = new Topics(topicslatest.docs, topicslatest.index, topicslatest.tname,
          topicslatest.type, topicslatest.shortname);
      topics.insert(topicslatest.index-1, topic);
    }
    return NewsSpecialInfo(
      srcJson["headpics"] as List,
      srcJson["supportGentie"] as int,
      srcJson["topicspatch"] as List,
      srcJson["supportEmoji"] as int,
      srcJson["del"] as int,
      srcJson["lmodify"] as String,
      srcJson["gentieId"] as String,
      srcJson["type"] as String,
      srcJson["sid"] as String,
      srcJson["bigBanner"] as String,
      srcJson["digest"] as String,
      srcJson["tag"] as String,
      srcJson["imgsrc"] as String,
      srcJson["pushTime"] as String,
      srcJson["ptime"] as String,
      srcJson["ec"] as String,
      srcJson["skipcontent"] as String,
      srcJson["topicsplus"] as List,
      topics,
      srcJson["banner"] as String,
      srcJson["sdocid"] as String,
      srcJson["sname"] as String,
      srcJson["webviews"] as List,
      srcJson["photoset"] as String,
      srcJson["shownav"] as String,
    );
  }
}

class Topicslatest {
  List<NewsType> docs;

  String showformat;

  int index;

  String tname;

  String timeformat;

  String type;

  String shortname;

  Topicslatest(
    this.docs,
    this.showformat,
    this.index,
    this.tname,
    this.timeformat,
    this.type,
    this.shortname,
  );

  factory Topicslatest.fromJson(Map<String, dynamic> srcJson) {
    return Topicslatest(
      (srcJson['docs'] as List)
          ?.map((e) =>
              e == null ? null : NewsType.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      srcJson["showformat"] as String,
      srcJson["index"] as int,
      srcJson["tname"] as String,
      srcJson["timeformat"] as String,
      srcJson["type"] as String,
      srcJson["shortname"] as String,
    );
  }
}

class Topics {
  List<NewsType> docs;

  int index;

  String tname;

  String type;

  String shortname;

  Topics(
    this.docs,
    this.index,
    this.tname,
    this.type,
    this.shortname,
  );

  factory Topics.fromJson(Map<String, dynamic> srcJson) {
    return Topics(
      (srcJson['docs'] as List)
          ?.map((e) =>
              e == null ? null : NewsType.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      srcJson["index"] as int,
      srcJson["tname"] as String,
      srcJson["type"] as String,
      srcJson["shortname"] as String,
    );
  }
}

class Docs {
  int votecount;

  String docid;

  String lmodify;

  String postid;

  String source;

  String title;

  String ipadcomment;

  String url;

  int replyCount;

  String ltitle;

  int imgsum;

  String digest;

  String tag;

  String imgsrc;

  String ptime;

  Docs(
    this.votecount,
    this.docid,
    this.lmodify,
    this.postid,
    this.source,
    this.title,
    this.ipadcomment,
    this.url,
    this.replyCount,
    this.ltitle,
    this.imgsum,
    this.digest,
    this.tag,
    this.imgsrc,
    this.ptime,
  );

  factory Docs.fromJson(Map<String, dynamic> srcJson) {
    return Docs(
      srcJson["votecount"] as int,
      srcJson["docid"] as String,
      srcJson["lmodify"] as String,
      srcJson["postid"] as String,
      srcJson["source"] as String,
      srcJson["title"] as String,
      srcJson["ipadcomment"] as String,
      srcJson["url"] as String,
      srcJson["replyCount"] as int,
      srcJson["ltitle"] as String,
      srcJson["imgsum"] as int,
      srcJson["digest"] as String,
      srcJson["tag"] as String,
      srcJson["imgsrc"] as String,
      srcJson["ptime"] as String,
    );
  }
}
