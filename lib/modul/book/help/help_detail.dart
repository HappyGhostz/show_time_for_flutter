/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'help_detail.g.dart';


@JsonSerializable()
class BookHelpDetail {

  @JsonKey(name: 'help')
  Help help;

  @JsonKey(name: 'ok')
  bool ok;

  BookHelpDetail(this.help,this.ok,);

  factory BookHelpDetail.fromJson(Map<String, dynamic> srcJson) => _$BookHelpDetailFromJson(srcJson);

}


@JsonSerializable()
class Help {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'state')
  String state;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'commentCount')
  int commentCount;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'shareLink')
  String shareLink;

  @JsonKey(name: 'id')
  String helpId;

  Help(this.id,this.author,this.type,this.state,this.updated,this.created,this.commentCount,this.content,this.title,this.shareLink,this.helpId,);

  factory Help.fromJson(Map<String, dynamic> srcJson) => _$HelpFromJson(srcJson);

}


@JsonSerializable()
class Author {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'activityAvatar')
  String activityAvatar;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'lv')
  int lv;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'id')
  String authorId;

  Author(this.id,this.avatar,this.nickname,this.activityAvatar,this.type,this.lv,this.gender,this.created,this.authorId,);

  factory Author.fromJson(Map<String, dynamic> srcJson) => _$AuthorFromJson(srcJson);

}


