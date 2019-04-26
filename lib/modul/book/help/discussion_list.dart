/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'discussion_list.g.dart';


@JsonSerializable()
class Discussions {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'today')
  int today;

  @JsonKey(name: 'posts')
  List<Posts> posts;

  @JsonKey(name: 'ok')
  bool ok;

  Discussions(this.total,this.today,this.posts,this.ok,);

  factory Discussions.fromJson(Map<String, dynamic> srcJson) => _$DiscussionsFromJson(srcJson);

}


@JsonSerializable()
class Posts {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'likeCount')
  int likeCount;

  @JsonKey(name: 'block')
  String block;

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

  @JsonKey(name: 'voteCount')
  int voteCount;

  @JsonKey(name: 'title')
  String title;

  Posts(this.id,this.author,this.type,this.likeCount,this.block,this.haveImage,this.state,this.updated,this.created,this.commentCount,this.voteCount,this.title,);

  factory Posts.fromJson(Map<String, dynamic> srcJson) => _$PostsFromJson(srcJson);

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


