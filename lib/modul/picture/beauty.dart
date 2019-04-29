/**
 * @author zcp
 * @date 2019/4/29
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'beauty.g.dart';


@JsonSerializable()
class BeautyPhoto {

  @JsonKey(name: 'col')
  String col;

  @JsonKey(name: 'tag')
  String tag;

  @JsonKey(name: 'tag3')
  String tag3;

  @JsonKey(name: 'sort')
  String sort;

  @JsonKey(name: 'totalNum')
  int totalNum;

  @JsonKey(name: 'startIndex')
  int startIndex;

  @JsonKey(name: 'returnNumber')
  int returnNumber;

  @JsonKey(name: 'imgs')
  List<Imgs> imgs;

  BeautyPhoto(this.col,this.tag,this.tag3,this.sort,this.totalNum,this.startIndex,this.returnNumber,this.imgs,);

  factory BeautyPhoto.fromJson(Map<String, dynamic> srcJson) => _$BeautyPhotoFromJson(srcJson);

}


@JsonSerializable()
class Imgs {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'tags')
  List<String> tags;

  @JsonKey(name: 'owner')
  Owner owner;

  @JsonKey(name: 'fromPageTitle')
  String fromPageTitle;

  @JsonKey(name: 'column')
  String column;

  @JsonKey(name: 'parentTag')
  String parentTag;

  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'downloadUrl')
  String downloadUrl;

  @JsonKey(name: 'imageUrl')
  String imageUrl;

  @JsonKey(name: 'imageWidth')
  int imageWidth;

  @JsonKey(name: 'imageHeight')
  int imageHeight;

  @JsonKey(name: 'thumbnailUrl')
  String thumbnailUrl;

  @JsonKey(name: 'thumbnailWidth')
  int thumbnailWidth;

  @JsonKey(name: 'thumbnailHeight')
  int thumbnailHeight;

  @JsonKey(name: 'thumbLargeWidth')
  int thumbLargeWidth;

  @JsonKey(name: 'thumbLargeHeight')
  int thumbLargeHeight;

  @JsonKey(name: 'thumbLargeUrl')
  String thumbLargeUrl;

  @JsonKey(name: 'thumbLargeTnWidth')
  int thumbLargeTnWidth;

  @JsonKey(name: 'thumbLargeTnHeight')
  int thumbLargeTnHeight;

  @JsonKey(name: 'thumbLargeTnUrl')
  String thumbLargeTnUrl;

  @JsonKey(name: 'siteName')
  String siteName;

  @JsonKey(name: 'siteLogo')
  String siteLogo;

  @JsonKey(name: 'siteUrl')
  String siteUrl;

  @JsonKey(name: 'fromUrl')
  String fromUrl;

  @JsonKey(name: 'isBook')
  String isBook;

  @JsonKey(name: 'bookId')
  String bookId;

  @JsonKey(name: 'objUrl')
  String objUrl;

  @JsonKey(name: 'shareUrl')
  String shareUrl;

  @JsonKey(name: 'setId')
  String setId;

  @JsonKey(name: 'albumId')
  String albumId;

  @JsonKey(name: 'isAlbum')
  int isAlbum;

  @JsonKey(name: 'albumName')
  String albumName;

  @JsonKey(name: 'albumNum')
  int albumNum;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'isVip')
  int isVip;

  @JsonKey(name: 'isDapei')
  int isDapei;

  @JsonKey(name: 'dressId')
  String dressId;

  @JsonKey(name: 'dressBuyLink')
  String dressBuyLink;

  @JsonKey(name: 'dressPrice')
  int dressPrice;

  @JsonKey(name: 'dressDiscount')
  int dressDiscount;

  @JsonKey(name: 'dressExtInfo')
  String dressExtInfo;

  @JsonKey(name: 'dressTag')
  String dressTag;

  @JsonKey(name: 'dressNum')
  int dressNum;

  @JsonKey(name: 'objTag')
  String objTag;

  @JsonKey(name: 'dressImgNum')
  int dressImgNum;

  @JsonKey(name: 'hostName')
  String hostName;

  @JsonKey(name: 'pictureId')
  String pictureId;

  @JsonKey(name: 'pictureSign')
  String pictureSign;

  @JsonKey(name: 'dataSrc')
  String dataSrc;

  @JsonKey(name: 'contentSign')
  String contentSign;

  @JsonKey(name: 'albumDi')
  String albumDi;

  @JsonKey(name: 'canAlbumId')
  String canAlbumId;

  @JsonKey(name: 'albumObjNum')
  String albumObjNum;

  @JsonKey(name: 'appId')
  String appId;

  @JsonKey(name: 'photoId')
  String photoId;

  @JsonKey(name: 'fromName')
  int fromName;

  @JsonKey(name: 'fashion')
  String fashion;

  @JsonKey(name: 'title')
  String title;

  Imgs(this.id,this.desc,this.tags,this.owner,this.fromPageTitle,this.column,this.parentTag,this.date,this.downloadUrl,this.imageUrl,this.imageWidth,this.imageHeight,this.thumbnailUrl,this.thumbnailWidth,this.thumbnailHeight,this.thumbLargeWidth,this.thumbLargeHeight,this.thumbLargeUrl,this.thumbLargeTnWidth,this.thumbLargeTnHeight,this.thumbLargeTnUrl,this.siteName,this.siteLogo,this.siteUrl,this.fromUrl,this.isBook,this.bookId,this.objUrl,this.shareUrl,this.setId,this.albumId,this.isAlbum,this.albumName,this.albumNum,this.userId,this.isVip,this.isDapei,this.dressId,this.dressBuyLink,this.dressPrice,this.dressDiscount,this.dressExtInfo,this.dressTag,this.dressNum,this.objTag,this.dressImgNum,this.hostName,this.pictureId,this.pictureSign,this.dataSrc,this.contentSign,this.albumDi,this.canAlbumId,this.albumObjNum,this.appId,this.photoId,this.fromName,this.fashion,this.title,);

  factory Imgs.fromJson(Map<String, dynamic> srcJson) => _$ImgsFromJson(srcJson);

}


@JsonSerializable()
class Owner {

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'userSign')
  String userSign;

  @JsonKey(name: 'isSelf')
  String isSelf;

  @JsonKey(name: 'portrait')
  String portrait;

  @JsonKey(name: 'isVip')
  String isVip;

  @JsonKey(name: 'isLanv')
  String isLanv;

  @JsonKey(name: 'isJiaju')
  String isJiaju;

  @JsonKey(name: 'isHunjia')
  String isHunjia;

  @JsonKey(name: 'orgName')
  String orgName;

  @JsonKey(name: 'resUrl')
  String resUrl;

  @JsonKey(name: 'cert')
  String cert;

  @JsonKey(name: 'budgetNum')
  String budgetNum;

  @JsonKey(name: 'lanvName')
  String lanvName;

  @JsonKey(name: 'contactName')
  String contactName;

  Owner(this.userName,this.userId,this.userSign,this.isSelf,this.portrait,this.isVip,this.isLanv,this.isJiaju,this.isHunjia,this.orgName,this.resUrl,this.cert,this.budgetNum,this.lanvName,this.contactName,);

  factory Owner.fromJson(Map<String, dynamic> srcJson) => _$OwnerFromJson(srcJson);

}


