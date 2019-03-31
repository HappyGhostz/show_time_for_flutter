/**
 * @author zcp
 * @date 2019/3/30
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'book_community.g.dart';


@JsonSerializable()
class BookCommunity{

  @JsonKey(name: 'helps')
  List<Helps> helps;

  @JsonKey(name: 'ok')
  bool ok;

  BookCommunity(this.helps,this.ok,);

  factory BookCommunity.fromJson(Map<String, dynamic> srcJson) => _$BookCommunityFromJson(srcJson);

}


@JsonSerializable()
class Helps {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'likeCount')
  int likeCount;

  @JsonKey(name: 'haveImage')
  bool haveImage;

  @JsonKey(name: 'state')
  String state;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'commentCount')
  int commentCount;

  @JsonKey(name: 'title')
  String title;

  Helps(this.id,this.author,this.likeCount,this.haveImage,this.state,this.updated,this.created,this.commentCount,this.title,);

  factory Helps.fromJson(Map<String, dynamic> srcJson) => _$HelpsFromJson(srcJson);

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


