import 'package:json_annotation/json_annotation.dart';
import 'package:show_time_for_flutter/utils/sql_helper.dart';
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
  String bookId;

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

  Books(this.bookId,this.cover,this.author,this.majorCate,this.title,this.shortIntro,this.contentType,this.allowMonthly,this.hasCp,this.latelyFollower,this.retentionRatio,this.updated,this.chaptersCount,this.lastChapter,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);
  Map<String, dynamic> toJson() => _$BooksToJson(this);

}

class BookModel{
  String tableName='book';
  SqlHelper sqlHelper;
  BookModel(){
    sqlHelper = SqlHelper.setTable(tableName);
  }
  Future close() async{
    sqlHelper.close();
  }
  Future<Books> getBookByCondition(String bookId)async{
    Map<dynamic, dynamic> conditions =Map();
    conditions["bookId"]=bookId;
    var list = await sqlHelper.getByCondition(conditions: conditions);
    List<Books> books = list.map((mapjson){
      Map<String, dynamic> map = Map<String, dynamic>.from(mapjson);
      if(map["allowMonthly"]==1){
        map["allowMonthly"]=true;
      }else{
        map["allowMonthly"]=false;
      }
      if(map["hasCp"]==1){
        map["hasCp"]=true;
      }else{
        map["hasCp"]=false;
      }
      map["_id"] = map["bookId"];
      return new Books.fromJson(map);
    }).toList();
    if(books==null||books.length==0){
      return null;
    }else{
      var book = books[0];
      return book;
    }

  }

  Future<List<Books>>  getSaveBooks()async{
    List<Map<String, dynamic>> list = await sqlHelper.get();
    List<Books> books = list.map((mapjson){
      Map<String, dynamic> map = Map<String, dynamic>.from(mapjson);
      if(map["allowMonthly"]==1){
        map["allowMonthly"]=true;
      }else{
        map["allowMonthly"]=false;
      }
      if(map["hasCp"]==1){
        map["hasCp"]=true;
      }else{
        map["hasCp"]=false;
      }
      map["_id"] = map["bookId"];
      return new Books.fromJson(map);
    }).toList();
    return books;
  }
  //通过返回的channel id来查看是否插入正确
  Future<Books> insertSelectChannel(Books book)async{
    Map<String, dynamic> json = book.toJson();
    if(json["allowMonthly"]){
      json["allowMonthly"]=1;
    }else{
      json["allowMonthly"]=0;
    }
    if(json["hasCp"]){
      json["hasCp"]=1;
    }else{
      json["hasCp"]=0;
    }
    json["bookId"] = json["_id"];
    json.remove("_id");

    Map<String, dynamic> bookMap = await sqlHelper.insert(json);
    if(json["allowMonthly"]==1){
      json["allowMonthly"]=true;
    }else{
      json["allowMonthly"]=false;
    }
    if(json["hasCp"]==1){
      json["hasCp"]=true;
    }else{
      json["hasCp"]=false;
    }
    json["_id"] = json["bookId"];
    return new Books.fromJson(bookMap);
  }

  Future<int> deleteSelectChannel(Books book)async{
    int count = await sqlHelper.delete( book.bookId,'bookId');
    return count;
  }

  Future insertSomeChannel(List<Books> books)async{
    books.forEach((book)async{
      await insertSelectChannel(book);
    });
  }

  Future<int> deleteAllBooks()async{
    int count = await sqlHelper.deleteAllData();
    return count;
  }
}


