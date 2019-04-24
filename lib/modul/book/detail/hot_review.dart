import 'package:json_annotation/json_annotation.dart';

part 'hot_review.g.dart';

/**
 * @author zcp
 * @date 2019/4/23
 * @Description
 */


@JsonSerializable()
class BookHotReview {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'reviews')
  List<Reviews> reviews;

  @JsonKey(name: 'ok')
  bool ok;

  BookHotReview(this.total,this.reviews,this.ok,);

  factory BookHotReview.fromJson(Map<String, dynamic> srcJson) => _$BookHotReviewFromJson(srcJson);

}


@JsonSerializable()
class Reviews {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'rating')
  int rating;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'helpful')
  Helpful helpful;

  @JsonKey(name: 'likeCount')
  int likeCount;

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

  Reviews(this.id,this.rating,this.author,this.helpful,this.likeCount,this.state,this.updated,this.created,this.commentCount,this.content,this.title,);

  factory Reviews.fromJson(Map<String, dynamic> srcJson) => _$ReviewsFromJson(srcJson);

}


@JsonSerializable()
class Author{

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
class Helpful{

  @JsonKey(name: 'no')
  int no;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'yes')
  int yes;

  Helpful(this.no,this.total,this.yes,);

  factory Helpful.fromJson(Map<String, dynamic> srcJson) => _$HelpfulFromJson(srcJson);

}


