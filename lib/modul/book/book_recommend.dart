import 'package:json_annotation/json_annotation.dart';

part 'book_recommend.g.dart';
/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */

@JsonSerializable()
class BookRecommend {

  @JsonKey(name: 'books')
  List<Books> books;

  @JsonKey(name: 'ok')
  bool ok;

  BookRecommend(this.books,this.ok,);

  factory BookRecommend.fromJson(Map<String, dynamic> srcJson) => _$BookRecommendFromJson(srcJson);

}


@JsonSerializable()
class Books {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'shortIntro')
  String shortIntro;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'hasCp')
  bool hasCp;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'retentionRatio')
  double retentionRatio;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'chaptersCount')
  int chaptersCount;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  Books(this.id,this.cover,this.author,this.majorCate,this.title,this.shortIntro,this.contentType,this.allowMonthly,this.hasCp,this.latelyFollower,this.retentionRatio,this.updated,this.chaptersCount,this.lastChapter,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

}


