
class PhotoSet  {

  PhotoInfo info;

  List<Photo> list;

  PhotoSet(this.info,this.list,);

  factory PhotoSet.fromJson(Map<String, dynamic> srcJson){
    var photoinfoJson = srcJson["info"];
    PhotoInfo photoInfo = PhotoInfo.fromJson(photoinfoJson);

    var list = srcJson["list"] as List;
    List<Photo> photos = list.map((i) => Photo.fromJson(i)).toList();
    PhotoSet photoSet = PhotoSet(photoInfo,photos);
    return photoSet;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'info':info,'list':list};

}


class PhotoInfo extends Object {

  String setname;

  int imgsum;

  String lmodify;

  String prevue;

  String channelid;

  String reporter;

  String source;

  String dutyeditor;


  PhotoInfo(this.setname,this.imgsum,this.lmodify,this.prevue,this.channelid,this.reporter,this.source,this.dutyeditor,);

  factory PhotoInfo.fromJson(Map<String, dynamic> srcJson){
    return new PhotoInfo(srcJson['setname'],
        srcJson['imgsum'], srcJson['lmodify'],
        srcJson['prevue'], srcJson['channelid'],
        srcJson['reporter'], srcJson['source'],
        srcJson['dutyeditor']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'setname': setname,
    'imgsum': imgsum,
    'lmodify': lmodify,
    'prevue': prevue,
    'channelid': channelid,
    'reporter':reporter,
    'source': source,
    'dutyeditor': dutyeditor,
  };

}


class Photo {

  String id;

  String img;

  String timg;

  String simg;

  String oimg;

  String title;

  String note;

  String newsurl;

  Photo(this.id,this.img,this.timg,this.simg,this.oimg,this.title,this.note,this.newsurl,);

  factory Photo.fromJson(Map<String, dynamic> srcJson) {
    return new Photo(srcJson['id'],
        srcJson['img'], srcJson['timg'],
        srcJson['simg'], srcJson['oimg'],
        srcJson['title'], srcJson['note'],
        srcJson['newsurl']);
  }

  Map<String, dynamic> toJson()=>  <String, dynamic>{
    'id': id,
    'img': img,
    'timg': timg,
    'simg': simg,
    'oimg': oimg,
    'title':title,
    'note': note,
    'newsurl': newsurl,
  };

}


  
