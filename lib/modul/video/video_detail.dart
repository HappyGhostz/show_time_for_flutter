/**
 * @author zcp
 * @date 2019/4/28
 * @Description
 */

import 'package:json_annotation/json_annotation.dart';

part 'video_detail.g.dart';


@JsonSerializable()
class VideoDetail {

  @JsonKey(name: 'resultCode')
  String resultCode;

  @JsonKey(name: 'resultMsg')
  String resultMsg;

  @JsonKey(name: 'reqId')
  String reqId;

  @JsonKey(name: 'systemTime')
  String systemTime;

  @JsonKey(name: 'areaList')
  List<AreaList> areaList;

  @JsonKey(name: 'content')
  Content content;

  @JsonKey(name: 'nextInfo')
  NextInfo nextInfo;

  @JsonKey(name: 'postInfo')
  PostInfo postInfo;

  @JsonKey(name: 'relateConts')
  List<RelateConts> relateConts;

  VideoDetail(this.resultCode,this.resultMsg,this.reqId,this.systemTime,this.areaList,this.content,this.nextInfo,this.postInfo,this.relateConts,);

  factory VideoDetail.fromJson(Map<String, dynamic> srcJson) => _$VideoDetailFromJson(srcJson);

}


@JsonSerializable()
class AreaList {

  @JsonKey(name: 'area_id')
  String areaId;

  @JsonKey(name: 'expInfo')
  ExpInfo expInfo;

  AreaList(this.areaId,this.expInfo,);

  factory AreaList.fromJson(Map<String, dynamic> srcJson) => _$AreaListFromJson(srcJson);

}


@JsonSerializable()
class ExpInfo {

  @JsonKey(name: 'algorighm_exp_id')
  String algorighmExpId;

  @JsonKey(name: 'front_exp_id')
  String frontExpId;

  @JsonKey(name: 's_value')
  String sValue;

  ExpInfo(this.algorighmExpId,this.frontExpId,this.sValue,);

  factory ExpInfo.fromJson(Map<String, dynamic> srcJson) => _$ExpInfoFromJson(srcJson);

}


@JsonSerializable()
class Content {

  @JsonKey(name: 'contId')
  String contId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'summary')
  String summary;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'pubTime')
  String pubTime;

  @JsonKey(name: 'isVr')
  String isVr;

  @JsonKey(name: 'aspectRatio')
  String aspectRatio;

  @JsonKey(name: 'contentHtml')
  String contentHtml;

  @JsonKey(name: 'liveHtml')
  String liveHtml;

  @JsonKey(name: 'postHtml')
  String postHtml;

  @JsonKey(name: 'praiseTimes')
  String praiseTimes;

  @JsonKey(name: 'commentTimes')
  String commentTimes;

  @JsonKey(name: 'isFavorited')
  String isFavorited;

  @JsonKey(name: 'pic')
  String pic;

  @JsonKey(name: 'postId')
  String postId;

  @JsonKey(name: 'liveRoomId')
  String liveRoomId;

  @JsonKey(name: 'sharePic')
  String sharePic;

  @JsonKey(name: 'shareUrl')
  String shareUrl;

  @JsonKey(name: 'liveInfo')
  LiveInfo liveInfo;

  @JsonKey(name: 'cornerLabel')
  String cornerLabel;

  @JsonKey(name: 'cornerLabelDesc')
  String cornerLabelDesc;

  @JsonKey(name: 'authors')
  List<Authors> authors;

  @JsonKey(name: 'tags')
  List<Tags> tags;

  @JsonKey(name: 'videos')
  List<VideoChilds> videos;

  @JsonKey(name: 'nodeInfo')
  NodeInfo nodeInfo;

  @JsonKey(name: 'copyright')
  String copyright;

  @JsonKey(name: 'isDownload')
  String isDownload;

  @JsonKey(name: 'duration')
  String duration;

  @JsonKey(name: 'adMonitorUrl')
  String adMonitorUrl;

  Content(this.contId,this.name,this.summary,this.source,this.pubTime,this.isVr,this.aspectRatio,this.contentHtml,this.liveHtml,this.postHtml,this.praiseTimes,this.commentTimes,this.isFavorited,this.pic,this.postId,this.liveRoomId,this.sharePic,this.shareUrl,this.liveInfo,this.cornerLabel,this.cornerLabelDesc,this.authors,this.tags,this.videos,this.nodeInfo,this.copyright,this.isDownload,this.duration,this.adMonitorUrl,);

  factory Content.fromJson(Map<String, dynamic> srcJson) => _$ContentFromJson(srcJson);

}


@JsonSerializable()
class LiveInfo {

  LiveInfo();

  factory LiveInfo.fromJson(Map<String, dynamic> srcJson) => _$LiveInfoFromJson(srcJson);

}


@JsonSerializable()
class Authors {

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'isPaike')
  String isPaike;

  @JsonKey(name: 'paikeType')
  String paikeType;

  Authors(this.userId,this.nickname,this.isPaike,this.paikeType,);

  factory Authors.fromJson(Map<String, dynamic> srcJson) => _$AuthorsFromJson(srcJson);

}


@JsonSerializable()
class Tags {

  @JsonKey(name: 'tagId')
  String tagId;

  @JsonKey(name: 'name')
  String name;

  Tags(this.tagId,this.name,);

  factory Tags.fromJson(Map<String, dynamic> srcJson) => _$TagsFromJson(srcJson);

}


@JsonSerializable()
class VideoChilds {

  @JsonKey(name: 'videoId')
  String videoId;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'tag')
  String tag;

  @JsonKey(name: 'format')
  String format;

  @JsonKey(name: 'fileSize')
  String fileSize;

  @JsonKey(name: 'duration')
  String duration;

  VideoChilds(this.videoId,this.url,this.tag,this.format,this.fileSize,this.duration,);

  factory VideoChilds.fromJson(Map<String, dynamic> srcJson) => _$VideoChildsFromJson(srcJson);

}

@JsonSerializable()
class NextInfo {

  @JsonKey(name: 'contId')
  String contId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'forwordType')
  String forwordType;

  NextInfo(this.contId,this.name,this.forwordType,);

  factory NextInfo.fromJson(Map<String, dynamic> srcJson) => _$NextInfoFromJson(srcJson);

}


@JsonSerializable()
class PostInfo {

  @JsonKey(name: 'postId')
  String postId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'commentTimes')
  String commentTimes;

  @JsonKey(name: 'communityInfo')
  CommunityInfo communityInfo;

  @JsonKey(name: 'isfavorited')
  String isfavorited;

  @JsonKey(name: 'postHtml')
  String postHtml;

  @JsonKey(name: 'childList')
  List<ChildList> childList;

  PostInfo(this.postId,this.name,this.commentTimes,this.communityInfo,this.isfavorited,this.postHtml,this.childList,);

  factory PostInfo.fromJson(Map<String, dynamic> srcJson) => _$PostInfoFromJson(srcJson);

}


@JsonSerializable()
class CommunityInfo {

  @JsonKey(name: 'communityId')
  String communityId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'logoImg')
  String logoImg;

  CommunityInfo(this.communityId,this.name,this.logoImg,);

  factory CommunityInfo.fromJson(Map<String, dynamic> srcJson) => _$CommunityInfoFromJson(srcJson);

}


@JsonSerializable()
class ChildList {

  @JsonKey(name: 'commentId')
  String commentId;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'pubTime')
  String pubTime;

  @JsonKey(name: 'topTimes')
  String topTimes;

  @JsonKey(name: 'stepTimes')
  String stepTimes;

  @JsonKey(name: 'replyTimes')
  String replyTimes;

  @JsonKey(name: 'userInfo')
  UserInfo userInfo;

  ChildList(this.commentId,this.content,this.pubTime,this.topTimes,this.stepTimes,this.replyTimes,this.userInfo,);

  factory ChildList.fromJson(Map<String, dynamic> srcJson) => _$ChildListFromJson(srcJson);

}


@JsonSerializable()
class UserInfo {

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'isPaike')
  String isPaike;

  @JsonKey(name: 'pic')
  String pic;

  UserInfo(this.userId,this.nickname,this.isPaike,this.pic,);

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) => _$UserInfoFromJson(srcJson);

}


@JsonSerializable()
class RelateConts {

  @JsonKey(name: 'contId')
  String contId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'pic')
  String pic;

  @JsonKey(name: 'nodeInfo')
  NodeInfo nodeInfo;

  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'linkType')
  String linkType;

  @JsonKey(name: 'cornerLabel')
  String cornerLabel;

  @JsonKey(name: 'cornerLabelDesc')
  String cornerLabelDesc;

  @JsonKey(name: 'forwordType')
  String forwordType;

  @JsonKey(name: 'videoType')
  String videoType;

  @JsonKey(name: 'duration')
  String duration;

  @JsonKey(name: 'liveStatus')
  String liveStatus;

  @JsonKey(name: 'praiseTimes')
  String praiseTimes;

  RelateConts(this.contId,this.name,this.pic,this.nodeInfo,this.link,this.linkType,this.cornerLabel,this.cornerLabelDesc,this.forwordType,this.videoType,this.duration,this.liveStatus,this.praiseTimes,);

  factory RelateConts.fromJson(Map<String, dynamic> srcJson) => _$RelateContsFromJson(srcJson);

}

@JsonSerializable()
class NodeInfo {

  @JsonKey(name: 'nodeId')
  String nodeId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'logoImg')
  String logoImg;

  @JsonKey(name: 'isOrder')
  String isOrder;

  @JsonKey(name: 'desc')
  String desc;

  NodeInfo(this.nodeId,this.name,this.logoImg,this.isOrder,this.desc,);

  factory NodeInfo.fromJson(Map<String, dynamic> srcJson) => _$NodeInfoFromJson(srcJson);

}


