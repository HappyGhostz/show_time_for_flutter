/**
 * @author zcp
 * @date 2019/4/23
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'recommend_list.g.dart';


@JsonSerializable()
class BookRecommends {

  @JsonKey(name: 'ok')
  bool ok;

  @JsonKey(name: 'booklists')
  List<Booklists> booklists;

  @JsonKey(name: 'total')
  int total;

  BookRecommends(this.ok,this.booklists,this.total,);

  factory BookRecommends.fromJson(Map<String, dynamic> srcJson) => _$BookRecommendsFromJson(srcJson);

}


@JsonSerializable()
class Booklists {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'collectorCount')
  int collectorCount;

  @JsonKey(name: 'covers')
  List<String> covers;

  Booklists(this.id,this.title,this.author,this.desc,this.bookCount,this.cover,this.collectorCount,this.covers,);

  factory Booklists.fromJson(Map<String, dynamic> srcJson) => _$BooklistsFromJson(srcJson);

}


