/**
 * @author zcp
 * @date 2019/4/11
 * @Description
 */

class BookMark{
  String title;
  int chapter;
  int index;
  BookMark(
      this.title,
      this.chapter,
      this.index
      );
  factory BookMark.fromJson(Map<String,dynamic> json){
    return BookMark(
      json["title"],
      json["chapter"],
      json["index"],
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title':title,
    'chapter':chapter,
    'index':index,
  };
}