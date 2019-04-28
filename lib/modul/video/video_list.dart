/**
 * @author zcp
 * @date 2019/4/27
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'video_list.g.dart';


@JsonSerializable()
class Videos {

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

  @JsonKey(name: 'dataList')
  List<DataList> dataList;

  @JsonKey(name: 'hotList')
  List<HotListBean> hotLists;

  @JsonKey(name: 'contList')
  List<ContList> contList;

  Videos(this.resultCode,this.resultMsg,this.reqId,this.systemTime,
      this.areaList,this.dataList,this.hotLists,this.contList,
      );

  factory Videos.fromJson(Map<String, dynamic> srcJson) => _$VideosFromJson(srcJson);

}

@JsonSerializable()
class HotListBean {
  /**
   * contId : 1064298
   * name : 颤抖吧!老戏骨们7句狠话猛喷小鲜肉
   * pic : http://image1.pearvideo.com/cont/20170414/cont-1064298-10256023.png
   * nodeInfo : {"nodeId":"66","name":"水煮娱","logoImg":"http://image2.pearvideo.com/node/66-10035464-logo.jpg"}
   * link : http://
   * linkType : 0
   * cornerLabel : 5
   * cornerLabelDesc : 推荐
   * forwordType : 1
   * videoType : 1
   * duration : 01'47"
   * liveStatus :
   * liveStartTime :
   * praiseTimes : 314
   */
  @JsonKey(name: 'contId')
  String contId;

  @JsonKey(name: 'pic')
  String pic;

  @JsonKey(name: 'name')
  String name;

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

  @JsonKey(name: 'liveStartTime')
  String liveStartTime;

  @JsonKey(name: 'praiseTimes')
  String praiseTimes;


  HotListBean(this.contId,this.name,this.pic,this.nodeInfo,this.link,this.linkType,this.cornerLabel,this.cornerLabelDesc,this.forwordType,this.videoType,this.duration,this.liveStatus,this.liveStartTime,this.praiseTimes,);

  factory HotListBean.fromJson(Map<String, dynamic> srcJson) => _$HotListBeanFromJson(srcJson);
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
class DataList {

  @JsonKey(name: 'nodeType')
  String nodeType;

  @JsonKey(name: 'nodeName')
  String nodeName;

  @JsonKey(name: 'isOrder')
  String isOrder;

  @JsonKey(name: 'nodeLogo')
  String nodeLogo;

  @JsonKey(name: 'nodeDesc')
  String nodeDesc;

  @JsonKey(name: 'moreId')
  String moreId;

  @JsonKey(name: 'contList')
  List<ContList> contList;

  DataList(this.nodeType,this.nodeName,this.isOrder,this.nodeLogo,this.nodeDesc,this.moreId,this.contList,);

  factory DataList.fromJson(Map<String, dynamic> srcJson) => _$DataListFromJson(srcJson);

}


@JsonSerializable()
class ContList {

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

  @JsonKey(name: 'liveStartTime')
  String liveStartTime;

  @JsonKey(name: 'praiseTimes')
  String praiseTimes;

  @JsonKey(name: 'adExpMonitorUrl')
  String adExpMonitorUrl;

  @JsonKey(name: 'coverVideo')
  String coverVideo;

  ContList(this.contId,this.name,this.pic,this.nodeInfo,this.link,this.linkType,this.cornerLabel,this.cornerLabelDesc,this.forwordType,this.videoType,this.duration,this.liveStatus,this.liveStartTime,this.praiseTimes,this.adExpMonitorUrl,this.coverVideo,);

  factory ContList.fromJson(Map<String, dynamic> srcJson) => _$ContListFromJson(srcJson);

}


@JsonSerializable()
class NodeInfo {

  @JsonKey(name: 'nodeId')
  String nodeId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'logoImg')
  String logoImg;

  NodeInfo(this.nodeId,this.name,this.logoImg,);

  factory NodeInfo.fromJson(Map<String, dynamic> srcJson) => _$NodeInfoFromJson(srcJson);

}


