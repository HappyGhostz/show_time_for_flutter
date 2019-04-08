/**
 * @author zcp
 * @date 2019/4/1
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'chapters.g.dart';


@JsonSerializable()
class ChapterBook {

  @JsonKey(name: 'mixToc')
  MixToc mixToc;

  @JsonKey(name: 'ok')
  bool ok;

  ChapterBook(this.mixToc,this.ok,);

  factory ChapterBook.fromJson(Map<String, dynamic> srcJson) => _$ChapterBookFromJson(srcJson);

}


@JsonSerializable()
class MixToc {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'chaptersCount1')
  int chaptersCount1;

  @JsonKey(name: 'book')
  String book;

  @JsonKey(name: 'chaptersUpdated')
  String chaptersUpdated;

  @JsonKey(name: 'chapters')
  List<Chapters> chapters;

  @JsonKey(name: 'updated')
  String updated;

  MixToc(this.id,this.chaptersCount1,this.book,this.chaptersUpdated,this.chapters,this.updated,);

  factory MixToc.fromJson(Map<String, dynamic> srcJson) => _$MixTocFromJson(srcJson);

}


@JsonSerializable()
class Chapters {

  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'unreadble')
  bool unreadble;

  Chapters(this.link,this.title,this.unreadble,);

  factory Chapters.fromJson(Map<String, dynamic> srcJson) => _$ChaptersFromJson(srcJson);

}


