
import 'package:json_annotation/json_annotation.dart';

part 'book_detail.g.dart';
/**
 * @author zcp
 * @date 2019/4/19
 * @Description
 */

@JsonSerializable()
class BookDetail {

  @JsonKey(name: '_id')
  String bookId;

  @JsonKey(name: 'longIntro')
  String longIntro;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'minorCateV2')
  String minorCateV2;

  @JsonKey(name: 'minorCate')
  String minorCate;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'creater')
  String creater;

  @JsonKey(name: 'majorCateV2')
  String majorCateV2;

  @JsonKey(name: 'isMakeMoneyLimit')
  bool isMakeMoneyLimit;

  @JsonKey(name: 'isFineBook')
  bool isFineBook;

  @JsonKey(name: 'safelevel')
  int safelevel;

  @JsonKey(name: 'allowFree')
  bool allowFree;

  @JsonKey(name: 'originalAuthor')
  String originalAuthor;

  @JsonKey(name: 'anchors')
  List<dynamic> anchors;

  @JsonKey(name: 'authorDesc')
  String authorDesc;

  @JsonKey(name: 'rating')
  Rating rating;

  @JsonKey(name: 'hasCopyright')
  bool hasCopyright;

  @JsonKey(name: 'buytype')
  int buytype;

  @JsonKey(name: 'sizetype')
  int sizetype;

  @JsonKey(name: 'superscript')
  String superscript;

  @JsonKey(name: 'currency')
  int currency;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: '_le')
  bool le;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'allowVoucher')
  bool allowVoucher;

  @JsonKey(name: 'allowBeanVoucher')
  bool allowBeanVoucher;

  @JsonKey(name: 'hasCp')
  bool hasCp;

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'postCount')
  int postCount;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'followerCount')
  int followerCount;

  @JsonKey(name: 'wordCount')
  int wordCount;

  @JsonKey(name: 'serializeWordCount')
  int serializeWordCount;

  @JsonKey(name: 'retentionRatio')
  String retentionRatio;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'isSerial')
  bool isSerial;

  @JsonKey(name: 'chaptersCount')
  int chaptersCount;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  @JsonKey(name: 'gender')
  List<String> gender;

  @JsonKey(name: 'tags')
  List<dynamic> tags;

  @JsonKey(name: 'advertRead')
  bool advertRead;

  @JsonKey(name: 'cat')
  String cat;

  @JsonKey(name: 'donate')
  bool donate;

  @JsonKey(name: '_gg')
  bool gg;

  @JsonKey(name: 'isForbidForFreeApp')
  bool isForbidForFreeApp;

  @JsonKey(name: 'isAllowNetSearch')
  bool isAllowNetSearch;

  @JsonKey(name: 'limit')
  bool limit;

  @JsonKey(name: 'copyrightDesc')
  String copyrightDesc;

  BookDetail(this.bookId,this.longIntro,this.cover,this.author,this.minorCateV2,this.minorCate,this.majorCate,this.title,this.creater,this.majorCateV2,this.isMakeMoneyLimit,this.isFineBook,this.safelevel,this.allowFree,this.originalAuthor,this.anchors,this.authorDesc,this.rating,this.hasCopyright,this.buytype,this.sizetype,this.superscript,this.currency,this.contentType,this.le,this.allowMonthly,this.allowVoucher,this.allowBeanVoucher,this.hasCp,this.banned,this.postCount,this.latelyFollower,this.followerCount,this.wordCount,this.serializeWordCount,this.retentionRatio,this.updated,this.isSerial,this.chaptersCount,this.lastChapter,this.gender,this.tags,this.advertRead,this.cat,this.donate,this.gg,this.isForbidForFreeApp,this.isAllowNetSearch,this.limit,this.copyrightDesc,);

  factory BookDetail.fromJson(Map<String, dynamic> srcJson) => _$BookDetailFromJson(srcJson);


}


@JsonSerializable()
class Rating{

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'score')
  double score;

  @JsonKey(name: 'isEffect')
  bool isEffect;

  Rating(this.count,this.score,this.isEffect,);

  factory Rating.fromJson(Map<String, dynamic> srcJson) => _$RatingFromJson(srcJson);

}


