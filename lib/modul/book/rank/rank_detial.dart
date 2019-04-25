/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'rank_detial.g.dart';


@JsonSerializable()
class RankDetail {

  @JsonKey(name: 'ranking')
  Ranking ranking;

  @JsonKey(name: 'ok')
  bool ok;

  RankDetail(this.ranking,this.ok,);

  factory RankDetail.fromJson(Map<String, dynamic> srcJson) => _$RankDetailFromJson(srcJson);

}


@JsonSerializable()
class Ranking {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'tag')
  String tag;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: '__v')
  int v;

  @JsonKey(name: 'monthRank')
  String monthRank;

  @JsonKey(name: 'totalRank')
  String totalRank;

  @JsonKey(name: 'shortTitle')
  String shortTitle;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'biTag')
  String biTag;

  @JsonKey(name: 'isSub')
  bool isSub;

  @JsonKey(name: 'collapse')
  bool collapse;

  @JsonKey(name: 'new')
  bool isNew;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'priority')
  int priority;

  @JsonKey(name: 'books')
  List<Books> books;

  @JsonKey(name: 'id')
  String bookId;

  @JsonKey(name: 'total')
  int total;

  Ranking(this.id,this.updated,this.title,this.tag,this.cover,this.icon,this.v,this.monthRank,this.totalRank,this.shortTitle,this.created,this.biTag,this.isSub,this.collapse,this.isNew,this.gender,this.priority,this.books,this.bookId,this.total,);

  factory Ranking.fromJson(Map<String, dynamic> srcJson) => _$RankingFromJson(srcJson);

}


@JsonSerializable()
class Books {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'site')
  String site;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'minorCate')
  String minorCate;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'shortIntro')
  String shortIntro;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'retentionRatio')
  dynamic retentionRatio;

  Books(this.id,this.cover,this.site,this.author,this.majorCate,this.minorCate,this.title,this.shortIntro,this.allowMonthly,this.banned,this.latelyFollower,this.retentionRatio,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

}


