
class NewsInfo {
  List<NewsType> news;
  String typeid;

  NewsInfo(this.news,);

  factory NewsInfo.fromJson(String typeId,Map<String, dynamic> srcJson){
    var list = srcJson["$typeId"] as List;
    List<NewsType> news = list.map((i) => NewsType.fromJson(i)).toList();
    NewsInfo newsInfo = NewsInfo(news);
    newsInfo.typeid = typeId;
    return newsInfo;
  }


  Map<String, dynamic> toJson() => <String, dynamic>{'$typeid':news};

}

class NewsType {

  String template;

  String skipID;

  String lmodify;

  String postid;

  String source;

  String title;

  String mtime;

  int hasImg;

  String topicBackground;

  String digest;

  String photosetID;

  String boardid;

  String alias;

  int hasAD;

  String imgsrc;

  String ptime;

  String daynum;

  int hasHead;

  int imgType;

  int order;

  List<dynamic> editor;

  int votecount;

  bool hasCover;

  String docid;

  String tname;

  int priority;

  List<Ads> ads;
  List<Imgextra> imgextra;

  String ename;

  int replyCount;

  int imgsum;

  bool hasIcon;

  String skipType;

  String cid;
  String specialID;

  NewsType(this.imgextra,this.template,this.skipID,this.lmodify,this.postid,this.source,
      this.title,this.mtime,this.hasImg,this.topicBackground,this.digest,this.photosetID,
      this.boardid,this.alias,this.hasAD,this.imgsrc,this.ptime,this.daynum,this.hasHead,
      this.imgType,this.order,this.editor,this.votecount,this.hasCover,this.docid,
      this.tname,this.priority,this.ads,this.ename,this.replyCount,this.imgsum,
      this.hasIcon,this.skipType,this.cid,this.specialID);

  factory NewsType.fromJson(Map<String, dynamic> json){
    return NewsType(
        (json['imgextra'] as List)
            ?.map(
                (e) => e == null ? null : Imgextra.fromJson(e as Map<String, dynamic>))
            ?.toList(),
        json['template'] as String,
        json['skipID'] as String,
        json['lmodify'] as String,
        json['postid'] as String,
        json['source'] as String,
        json['title'] as String,
        json['mtime'] as String,
        json['hasImg'] as int,
        json['topic_background'] as String,
        json['digest'] as String,
        json['photosetID'] as String,
        json['boardid'] as String,
        json['alias'] as String,
        json['hasAD'] as int,
        json['imgsrc'] as String,
        json['ptime'] as String,
        json['daynum'] as String,
        json['hasHead'] as int,
        json['imgType'] as int,
        json['order'] as int,
        json['editor'] as List,
        json['votecount'] as int,
        json['hasCover'] as bool,
        json['docid'] as String,
        json['tname'] as String,
        json['priority'] as int,
        (json['ads'] as List)
            ?.map(
                (e) => e == null ? null : Ads.fromJson(e as Map<String, dynamic>))
            ?.toList(),
        json['ename'] as String,
        json['replyCount'] as int,
        json['imgsum'] as int,
        json['hasIcon'] as bool,
        json['skipType'] as String,
        json['cid'] as String,
        json['specialID'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'template': template,
    'skipID': skipID,
    'lmodify': lmodify,
    'postid': postid,
    'source': source,
    'title': title,
    'mtime': mtime,
    'hasImg': hasImg,
    'topic_background': topicBackground,
    'digest': digest,
    'photosetID': photosetID,
    'boardid': boardid,
    'alias': alias,
    'hasAD': hasAD,
    'imgsrc': imgsrc,
    'ptime': ptime,
    'daynum': daynum,
    'hasHead': hasHead,
    'imgType': imgType,
    'order': order,
    'editor': editor,
    'votecount': votecount,
    'hasCover': hasCover,
    'docid': docid,
    'tname': tname,
    'priority': priority,
    'ads': ads,
    'ename': ename,
    'replyCount': replyCount,
    'imgsum': imgsum,
    'hasIcon': hasIcon,
    'skipType': skipType,
    'cid': cid
  };

}

class Imgextra{
  String imgsrc;
  Imgextra(this.imgsrc);

  factory Imgextra.fromJson(Map<String, dynamic> json) {
    return Imgextra(
        json['imgsrc'] as String
    );
  }

  Map<String, dynamic> toJson() =>  <String, dynamic>{
    'imgsrc': imgsrc,
  };
}

class Ads {

  String subtitle;

  String skipType;

  String skipID;

  String tag;

  String title;

  String imgsrc;

  String url;

  Ads(this.subtitle,this.skipType,this.skipID,this.tag,this.title,this.imgsrc,this.url,);

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
        json['subtitle'] as String,
        json['skipType'] as String,
        json['skipID'] as String,
        json['tag'] as String,
        json['title'] as String,
        json['imgsrc'] as String,
        json['url'] as String);
  }

  Map<String, dynamic> toJson() =>  <String, dynamic>{
    'subtitle': subtitle,
    'skipType': skipType,
    'skipID': skipID,
    'tag': tag,
    'title': title,
    'imgsrc':imgsrc,
    'url': url
  };

}


