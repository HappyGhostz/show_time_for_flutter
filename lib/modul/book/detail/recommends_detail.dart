/**
 * @author zcp
 * @date 2019/4/24
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'recommends_detail.g.dart';


@JsonSerializable()
class BookRecommendsDetail {

  @JsonKey(name: 'ok')
  bool ok;

  @JsonKey(name: 'bookList')
  BookList bookList;

  BookRecommendsDetail(this.ok,this.bookList,);

  factory BookRecommendsDetail.fromJson(Map<String, dynamic> srcJson) => _$BookRecommendsDetailFromJson(srcJson);

}


@JsonSerializable()
class BookList {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: '_id')
  String bookId;

  @JsonKey(name: 'author')
  Author author;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'updateCount')
  int updateCount;

  @JsonKey(name: 'created')
  String created;

  @JsonKey(name: 'updated')
  String updated;

  @JsonKey(name: 'tags')
  List<String> tags;

  @JsonKey(name: 'isDraft')
  bool isDraft;

  @JsonKey(name: 'collectorCount')
  int collectorCount;

  @JsonKey(name: 'shareLink')
  String shareLink;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'books')
  List<Books> books;

  BookList(this.id,this.bookId,this.author,this.title,this.desc,this.gender,this.updateCount,this.created,this.updated,this.tags,this.isDraft,this.collectorCount,this.shareLink,this.total,this.books,);

  factory BookList.fromJson(Map<String, dynamic> srcJson) => _$BookListFromJson(srcJson);

}


@JsonSerializable()
class Author {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'lv')
  int lv;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'type')
  String type;

  Author(this.id,this.avatar,this.lv,this.nickname,this.type,);

  factory Author.fromJson(Map<String, dynamic> srcJson) => _$AuthorFromJson(srcJson);

}


@JsonSerializable()
class Books {

  @JsonKey(name: 'book')
  Book book;

  @JsonKey(name: 'comment')
  String comment;

  Books(this.book,this.comment,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

}


@JsonSerializable()
class Book {

  @JsonKey(name: 'cat')
  String cat;

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'longIntro')
  String longIntro;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'site')
  String site;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'minorCate')
  String minorCate;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'wordCount')
  int wordCount;

  @JsonKey(name: 'retentionRatio')
  double retentionRatio;

  Book(this.cat,this.id,this.title,this.author,this.longIntro,this.cover,this.site,this.majorCate,this.minorCate,this.allowMonthly,this.banned,this.latelyFollower,this.wordCount,this.retentionRatio,);

  factory Book.fromJson(Map<String, dynamic> srcJson) => _$BookFromJson(srcJson);

}


