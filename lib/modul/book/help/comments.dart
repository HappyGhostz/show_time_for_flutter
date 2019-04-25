/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'comments.g.dart';


@JsonSerializable()
class CommentList {

  @JsonKey(name: 'comments')
  List<Comments> comments;

  @JsonKey(name: 'ok')
  bool ok;

  CommentList(this.comments,this.ok,);

  factory CommentList.fromJson(Map<String, dynamic> srcJson) => _$CommentListFromJson(srcJson);

}


@JsonSerializable()
class Comments {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'author')
  Author author;
  @JsonKey(name: 'replyTo')
  ReplyToBean replyTo;

  @JsonKey(name: 'floor')
  int floor;

  @JsonKey(name: 'likeCount')
  int likeCount;

  @JsonKey(name: 'created')
  String created;

  Comments(this.id,this.content,this.author,this.replyTo,this.floor,this.likeCount,this.created,);

  factory Comments.fromJson(Map<String, dynamic> srcJson) => _$CommentsFromJson(srcJson);

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

  Author(this.id,this.avatar,this.nickname,this.activityAvatar,this.type,this.lv,this.gender,);

  factory Author.fromJson(Map<String, dynamic> srcJson) => _$AuthorFromJson(srcJson);

}

@JsonSerializable()
class ReplyToBean {

  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'author')
  Author author;
  @JsonKey(name: 'floor')
  int floor;
  ReplyToBean(this.id,this.author,this.floor);

  factory ReplyToBean.fromJson(Map<String, dynamic> srcJson) => _$ReplyToBeanFromJson(srcJson);

}


