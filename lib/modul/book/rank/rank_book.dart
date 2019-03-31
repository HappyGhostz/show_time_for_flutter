/**
 * @author zcp
 * @date 2019/3/31
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'rank_book.g.dart';


@JsonSerializable()
class RankBook {

  @JsonKey(name: 'female')
  List<Female> female;

  @JsonKey(name: 'picture')
  List<Picture> picture;

  @JsonKey(name: 'male')
  List<Male> male;

  @JsonKey(name: 'epub')
  List<Epub> epub;

  @JsonKey(name: 'ok')
  bool ok;

  RankBook(this.female,this.picture,this.male,this.epub,this.ok,);

  factory RankBook.fromJson(Map<String, dynamic> srcJson) => _$RankBookFromJson(srcJson);

}


@JsonSerializable()
class Female {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'collapse')
  bool collapse;

  @JsonKey(name: 'monthRank')
  String monthRank;

  @JsonKey(name: 'totalRank')
  String totalRank;

  @JsonKey(name: 'shortTitle')
  String shortTitle;

  Female(this.id,this.title,this.cover,this.collapse,this.monthRank,this.totalRank,this.shortTitle,);

  factory Female.fromJson(Map<String, dynamic> srcJson) => _$FemaleFromJson(srcJson);

}


@JsonSerializable()
class Picture {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'collapse')
  bool collapse;

  @JsonKey(name: 'shortTitle')
  String shortTitle;

  Picture(this.id,this.title,this.cover,this.collapse,this.shortTitle,);

  factory Picture.fromJson(Map<String, dynamic> srcJson) => _$PictureFromJson(srcJson);

}


@JsonSerializable()
class Male{

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'collapse')
  bool collapse;

  @JsonKey(name: 'monthRank')
  String monthRank;

  @JsonKey(name: 'totalRank')
  String totalRank;

  @JsonKey(name: 'shortTitle')
  String shortTitle;

  Male(this.id,this.title,this.cover,this.collapse,this.monthRank,this.totalRank,this.shortTitle,);

  factory Male.fromJson(Map<String, dynamic> srcJson) => _$MaleFromJson(srcJson);

}


@JsonSerializable()
class Epub {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'collapse')
  bool collapse;

  @JsonKey(name: 'shortTitle')
  String shortTitle;

  Epub(this.id,this.title,this.cover,this.collapse,this.shortTitle,);

  factory Epub.fromJson(Map<String, dynamic> srcJson) => _$EpubFromJson(srcJson);

}


