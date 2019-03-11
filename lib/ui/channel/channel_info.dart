import 'package:show_time_for_flutter/utils/sql_helper.dart';
import 'package:show_time_for_flutter/widgets/dragablegridviewbin.dart';

class ChannelList{
  List<Channel> channels;
  ChannelList({this.channels});

  factory ChannelList.fromJson(List<dynamic> parseJsons){
    List<Channel> channelLists  =new List();
    channelLists = parseJsons.map((c){
      return Channel.fromJson(c);
    }).toList();
    for(int i =0;i<channelLists.length;i++){
      Channel cahnnel = channelLists[i];
      cahnnel.id = i;
    }
    return new ChannelList(channels: channelLists);
  }
}
class Channel extends DragAbleGridViewBin{
  int id;
  String name;
  String typeId;

  Channel({this.name,this.typeId});

  Channel.fromJson(Map json):
        id  =json["id"]==null?0:json["id"],
        name = json["name"],
        typeId = json["typeId"];

  String toString() => name;

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'name': name,
        'typeId': typeId,
      };

  Map toSqlCondition() {
    Map _map = this.toJson();
    Map condition = {};
    _map.forEach((k, value) {

      if (value != null) {

        condition[k] = value;
      }
    });

    if (condition.isEmpty) {
      return {};
    }

    return condition;
  }
}

class ChannelModel{
  String tableName='channel';
  SqlHelper sqlHelper;
  ChannelModel(){
    sqlHelper = SqlHelper.setTable(tableName);
  }

  Future<List<Channel>>  getSelectChannels()async{
    List<Map<String, dynamic>> list = await sqlHelper.get();
    List<Channel> channels = list.map((json){
      return new Channel.fromJson(json);
    }).toList();
    return channels;
  }
  //通过返回的channel id来查看是否插入正确
  Future<Channel> insertSelectChannel(Channel channel)async{
    Map<String, dynamic> json = channel.toJson();
    Map<String, dynamic> channelMap = await sqlHelper.insert(json);
    return new Channel.fromJson(channelMap);
  }

  Future<int> deleteSelectChannel(Channel channel)async{
    int count = await sqlHelper.delete(channel.typeId, 'typeId');
    return count;
  }

  Future insertSomeChannel(List<Channel> channels)async{
    channels.forEach((channel)async{
      await insertSelectChannel(channel);
    });
  }

  Future<int> deleteAllChannels()async{
    int count = await sqlHelper.deleteAllData();
    return count;
  }
}