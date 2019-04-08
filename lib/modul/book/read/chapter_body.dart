/**
 * @author zcp
 * @date 2019/4/1
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'chapter_body.g.dart';


@JsonSerializable()
class ChapterBody {

  @JsonKey(name: 'ok')
  bool ok;

  @JsonKey(name: 'chapter')
  Chapter chapter;

  ChapterBody(this.ok,this.chapter,);

  factory ChapterBody.fromJson(Map<String, dynamic> srcJson) => _$ChapterBodyFromJson(srcJson);

}


@JsonSerializable()
class Chapter{

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'body')
  String body;

  Chapter(this.title,this.body,);

  factory Chapter.fromJson(Map<String, dynamic> srcJson) => _$ChapterFromJson(srcJson);

}


