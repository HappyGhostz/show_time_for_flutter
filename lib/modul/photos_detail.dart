

class PhotoSetInfo{
  String postid;
  String clientadurl;
  String desc;
  String datatime;
  String createdate;
  String scover;
  String autoid;
  String url;
  String creator;
  String reporter;
  String setname;
  String neteasecode;
  String cover;
  String commenturl;
  String source;
  String settag;
  String boardid;
  String tcover;
  String imgsum;
  List<dynamic> relatedids;

  /**
   * timgurl : http://img4.cache.netease.com/photo/0006/2016-08-26/t_BVDAI9QS17KK0006.jpg
   * photohtml : http://travel.163.com/photoview/17KK0006/2136404.html#p=BVDAI9QS17KK0006
   * newsurl : #
   * squareimgurl : http://img3.cache.netease.com/photo/0006/2016-08-26/400x400_BVDAI9QS17KK0006.jpg
   * cimgurl : http://img3.cache.netease.com/photo/0006/2016-08-26/c_BVDAI9QS17KK0006.jpg
   * imgtitle :
   * simgurl : http://img4.cache.netease.com/photo/0006/2016-08-26/s_BVDAI9QS17KK0006.jpg
   * note : 6岁的维罗妮卡在纽约度过了4年这样的夏日。4年前，莎宾娜与丈夫马克通过中间机构在中国安徽的福利院收养了维罗妮卡，当时同行的还有他们的大女儿和二女儿，在之后的时光里维罗妮卡在家排行老三，一年后姐妹仨又多一位妹妹，现在姐妹四人在父母和两位保姆的呵护下，在纽约曼哈顿一天一天长大。（来源：中国新闻网）
   * photoid : BVDAI9QS17KK0006
   * imgurl : http://img4.cache.netease.com/photo/0006/2016-08-26/BVDAI9QS17KK0006.jpg
   */

  List<PhotosEntity> photos;
  PhotoSetInfo(
      this.postid,
      this.clientadurl,
      this.desc,
      this.datatime,
      this.createdate,
      this.scover,
      this.autoid,
      this.url,
      this.creator,
      this.reporter,
      this.setname,
      this.neteasecode,
      this.cover,
      this.commenturl,
      this.source,
      this.settag,
      this.boardid,
      this.tcover,
      this.imgsum,
      this.relatedids,
      this.photos,
      );
  factory PhotoSetInfo.fromJson(Map<String, dynamic> srcJson){
    return PhotoSetInfo(
      srcJson["postid"] as String,
      srcJson["clientadurl"] as String,
      srcJson["desc"] as String,
      srcJson["datatime"] as String,
      srcJson["createdate"] as String,
      srcJson["scover"] as String,
      srcJson["autoid"] as String,
      srcJson["url"] as String,
      srcJson["creator"] as String,
      srcJson["reporter"] as String,
      srcJson["setname"] as String,
      srcJson["neteasecode"] as String,
      srcJson["cover"] as String,
      srcJson["commenturl"] as String,
      srcJson["source"] as String,
      srcJson["settag"] as String,
      srcJson["boardid"] as String,
      srcJson["tcover"] as String,
      srcJson["imgsum"] as String,
      srcJson["relatedids"] as List,
      (srcJson['photos'] as List)
          ?.map(
              (e) => e == null ? null : PhotosEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}
class  PhotosEntity{
  String timgurl;
  String photohtml;
  String newsurl;
  String squareimgurl;
  String cimgurl;
  String imgtitle;
  String simgurl;
  String note;
  String photoid;
  String imgurl;
  PhotosEntity(
      this.timgurl,
      this.photohtml,
      this.newsurl,
      this.squareimgurl,
      this.cimgurl,
      this.imgtitle,
      this.simgurl,
      this.note,
      this.photoid,
      this.imgurl,
      );
  factory PhotosEntity.fromJson(Map<String, dynamic> srcJson){
    return PhotosEntity(
        srcJson["timgurl"] as String,
        srcJson["photohtml"] as String,
        srcJson["newsurl"] as String,
        srcJson["squareimgurl"] as String,
        srcJson["cimgurl"] as String,
        srcJson["imgtitle"] as String,
        srcJson["simgurl"] as String,
        srcJson["note"] as String,
        srcJson["photoid"] as String,
        srcJson["imgurl"] as String,
    );
  }

}