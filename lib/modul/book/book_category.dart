
import 'package:json_annotation/json_annotation.dart';

part 'book_category.g.dart';

/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */
@JsonSerializable()
class BookCategory{

  @JsonKey(name: 'male')
  List<Male> male;

  @JsonKey(name: 'female')
  List<Female> female;

  @JsonKey(name: 'picture')
  List<Picture> picture;

  @JsonKey(name: 'press')
  List<Press> press;

  @JsonKey(name: 'ok')
  bool ok;

  BookCategory(this.male,this.female,this.picture,this.press,this.ok,);

  factory BookCategory.fromJson(Map<String, dynamic> srcJson) => _$BookCategoryFromJson(srcJson);

}


@JsonSerializable()
class Male {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Male(this.name,this.bookCount,this.monthlyCount,this.icon,this.bookCover,);

  factory Male.fromJson(Map<String, dynamic> srcJson) => _$MaleFromJson(srcJson);

}


@JsonSerializable()
class Female {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Female(this.name,this.bookCount,this.monthlyCount,this.icon,this.bookCover,);

  factory Female.fromJson(Map<String, dynamic> srcJson) => _$FemaleFromJson(srcJson);

}


@JsonSerializable()
class Picture {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Picture(this.name,this.bookCount,this.monthlyCount,this.icon,this.bookCover,);

  factory Picture.fromJson(Map<String, dynamic> srcJson) => _$PictureFromJson(srcJson);

}


@JsonSerializable()
class Press {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'monthlyCount')
  int monthlyCount;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'bookCover')
  List<String> bookCover;

  Press(this.name,this.bookCount,this.monthlyCount,this.icon,this.bookCover,);

  factory Press.fromJson(Map<String, dynamic> srcJson) => _$PressFromJson(srcJson);

}


