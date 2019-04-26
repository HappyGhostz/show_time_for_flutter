/**
 * @author zcp
 * @date 2019/4/26
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';


@JsonSerializable()
class BookSearchResult {

  @JsonKey(name: 'books')
  List<Books> books;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'ok')
  bool ok;

  BookSearchResult(this.books,this.total,this.ok,);

  factory BookSearchResult.fromJson(Map<String, dynamic> srcJson) => _$BookSearchResultFromJson(srcJson);

}


@JsonSerializable()
class Books {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'hasCp')
  bool hasCp;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'aliases')
  String aliases;

  @JsonKey(name: 'cat')
  String cat;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'site')
  String site;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'shortIntro')
  String shortIntro;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  @JsonKey(name: 'retentionRatio')
  double retentionRatio;

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'wordCount')
  int wordCount;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: 'superscript')
  String superscript;

  @JsonKey(name: 'sizetype')
  int sizetype;

  @JsonKey(name: 'highlight')
  Highlight highlight;

  Books(this.id,this.hasCp,this.title,this.aliases,this.cat,this.author,this.site,this.cover,this.shortIntro,this.lastChapter,this.retentionRatio,this.banned,this.allowMonthly,this.latelyFollower,this.wordCount,this.contentType,this.superscript,this.sizetype,this.highlight,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

}


@JsonSerializable()
class Highlight {

  @JsonKey(name: 'title')
  List<String> title;

  Highlight(this.title,);

  factory Highlight.fromJson(Map<String, dynamic> srcJson) => _$HighlightFromJson(srcJson);

}


