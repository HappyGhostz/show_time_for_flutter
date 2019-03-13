
class NewsDetail {
  NewsDetailInfo newsDetailInfo;

  NewsDetail(this.newsDetailInfo);

  factory NewsDetail.fromJson(String id,Map<String, dynamic> json){
    var newsDetail = json["$id"];
    NewsDetailInfo newsDetailInfo = NewsDetailInfo.fromJson(newsDetail);
    return NewsDetail(newsDetailInfo);
  }
}


class NewsDetailInfo {

  String template;

  List<ImgInfo> img;

  List<dynamic> searchKw;

  List<Topiclist_news> topiclistNews;

  List<dynamic> book;

  List<dynamic> link;

  String shareLink;

  String source;

  int threadVote;

  String title;

  String body;

  String tid;

  bool picnews;

  List<Spinfo> spinfo;

  String advertiseType;

  String articleType;

  String digest;

  List<dynamic> boboList;

  String ptime;

  String ec;

  String docid;

  int threadAgainst;

  bool hasNext;

  String recImgsrc;

  String dkeys;

  List<dynamic> ydbaike;

  bool hidePlane;

  int replyCount;

  String voicecomment;

  String replyBoard;

  List<dynamic> votes;

  List<dynamic> topiclist;

  List<RelativeSys>relative_sys;

  NewsDetailInfo(this.template,this.img,this.searchKw,this.topiclistNews,this.book,
      this.link,this.shareLink,this.source,this.threadVote,this.title,this.body,
      this.tid,this.picnews,this.spinfo,this.advertiseType,this.articleType,
      this.digest,this.boboList,this.ptime,this.ec,this.docid,this.threadAgainst,
      this.hasNext,this.recImgsrc,this.dkeys,this.ydbaike,this.hidePlane,this.replyCount,
      this.voicecomment,this.replyBoard,this.votes,this.topiclist,this.relative_sys,);

  factory NewsDetailInfo.fromJson(Map<String, dynamic> srcJson){
    return NewsDetailInfo(
      srcJson["template"] as String,
        (srcJson["img"] as List)
          ?.map((e)=> e == null ? null : ImgInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
      srcJson["searchKw"] as List,
      (srcJson["topiclistNews"] as List)
          ?.map((e)=> e == null ? null : Topiclist_news.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      srcJson["book"] as List,
      srcJson["link"] as List,
      srcJson["shareLink"] as String,
      srcJson["source"] as String,
      srcJson["threadVote"] as int,
      srcJson["title"] as String,
      srcJson["body"] as String,
      srcJson["tid"] as String,
      srcJson["picnews"] as bool,
      (srcJson["spinfo"] as List)
          ?.map((e)=> e == null ? null : Spinfo.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      srcJson["advertiseType"] as String,
      srcJson["articleType"] as String,
      srcJson["digest"] as String,
      srcJson["boboList"] as List,
      srcJson["ptime"] as String,
      srcJson["ec"] as String,
      srcJson["docid"] as String,
      srcJson["threadAgainst"] as int,
      srcJson["hasNext"] as bool,
      srcJson["recImgsrc"] as String,
      srcJson["dkeys"] as String,
      srcJson["ydbaike"] as List,
      srcJson["hidePlane"] as bool,
      srcJson["replyCount"] as int,
      srcJson["voicecomment"] as String,
      srcJson["replyBoard"] as String,
      srcJson["votes"] as List,
      srcJson["topiclist"] as List,
      (srcJson["relative_sys"] as List)
          ?.map((e)=> e == null ? null : RelativeSys.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}

class ImgInfo {

  String ref;

  String src;

  String alt;

  String pixel;

  ImgInfo(this.ref,this.src,this.alt,this.pixel,);

  factory ImgInfo.fromJson(Map<String, dynamic> srcJson){
    return  ImgInfo(
      srcJson["ref"] as String,
      srcJson["src"]as String,
      srcJson["alt"]as String,
      srcJson["pixel"]as String,
    );
  }

}

class Topiclist_news {

  String ename;

  bool hasCover;

  String tname;

  String alias;

  String subnum;

  String tid;

  String cid;

  Topiclist_news(this.ename,this.hasCover,this.tname,this.alias,this.subnum,this.tid,this.cid,);

  factory Topiclist_news.fromJson(Map<String, dynamic> srcJson){
   return  Topiclist_news(
     srcJson["ename"] as String,
     srcJson["hasCover"]as bool,
     srcJson["tname"]as String,
     srcJson["alias"]as String,
     srcJson["subnum"]as String,
     srcJson["tid"]as String,
     srcJson["cid"]as String,
   );
  }

}


class Spinfo {

  String ref;

  String spcontent;

  String sptype;

  Spinfo(this.ref,this.spcontent,this.sptype,);

  factory Spinfo.fromJson(Map<String, dynamic> srcJson) {
    return Spinfo(
      srcJson["ref"] as String,
      srcJson["spcontent"] as String,
      srcJson["sptype"] as String,
    );
  }

}
class RelativeSys {

  String id;
  String docID;
  String type;
  String href;
  String postid;
  int votecount;
  int replyCount;
  String tag;
  String ltitle;
  String digest;
  String url;
  String ipadcomment;
  String docid;
  String title;
  String source;
  String lmodify;
  String imgsrc;
  String ptime;
  String skipType;
  String specialID;
  RelativeSys(this.id,this.docID,this.type,this.href,this.postid,this.votecount,
      this.replyCount,this.tag,this.ltitle,this.digest,this.url,this.ipadcomment,
      this.docid,this.title,this.source,this.lmodify,this.imgsrc,this.ptime,
      this.skipType,this.specialID,);

  factory RelativeSys.fromJson(Map<String, dynamic> srcJson) {
    return RelativeSys(
      srcJson["id"] as String,
      srcJson["docID"] as String,
      srcJson["type"] as String,
      srcJson["href"] as String,
      srcJson["postid"] as String,
      srcJson["votecount"] as int,
      srcJson["replyCount"] as int,
      srcJson["tag"] as String,
      srcJson["ltitle"] as String,
      srcJson["digest"] as String,
      srcJson["url"] as String,
      srcJson["ipadcomment"] as String,
      srcJson["docid"] as String,
      srcJson["title"] as String,
      srcJson["source"] as String,
      srcJson["lmodify"] as String,
      srcJson["imgsrc"] as String,
      srcJson["ptime"] as String,
      srcJson["skipType"] as String,
      srcJson["specialID"] as String,
    );
  }

}