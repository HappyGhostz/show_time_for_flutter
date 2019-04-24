/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'category_bean.g.dart';

@JsonSerializable()
class BookCategorys {
  @JsonKey(name: 'ok')
  bool ok;
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'books')
  List<Book> books;

  BookCategorys(
    this.ok,
    this.total,
    this.books,
  );

  factory BookCategorys.fromJson(Map<String, dynamic> srcJson) =>
      _$BookCategorysFromJson(srcJson);
}

@JsonSerializable()
class Book {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'author')
  String author;
  @JsonKey(name: 'shortIntro')
  String shortIntro;
  @JsonKey(name: 'cover')
  String cover;
  @JsonKey(name: 'site')
  String site;
  @JsonKey(name: 'majorCate')
  String majorCate;
  @JsonKey(name: 'lastChapter')
  String lastChapter;
  @JsonKey(name: 'latelyFollower')
  int latelyFollower;
  @JsonKey(name: 'latelyFollowerBase')
  int latelyFollowerBase;
  @JsonKey(name: 'minRetentionRatio')
  int minRetentionRatio;
  @JsonKey(name: 'retentionRatio')
  double retentionRatio;
  @JsonKey(name: 'tags')
  List<dynamic> tags;

  Book(
    this.id,
    this.title,
    this.author,
    this.shortIntro,
    this.cover,
    this.site,
    this.majorCate,
    this.lastChapter,
    this.latelyFollower,
    this.latelyFollowerBase,
    this.minRetentionRatio,
    this.retentionRatio,
    this.tags,
  );

  factory Book.fromJson(Map<String, dynamic> srcJson) =>
      _$BookFromJson(srcJson);
}
