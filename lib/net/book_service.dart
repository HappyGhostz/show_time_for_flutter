import 'package:show_time_for_flutter/net/net_utils.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/modul/book/book_category.dart';
import 'package:show_time_for_flutter/modul/book/book_community.dart';
import 'package:show_time_for_flutter/modul/book/rank/rank_book.dart';
/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */
String IMG_BASE_URL = "http://statics.zhuishushenqi.com";
class BookService{
  NetUtils bookUtils;
  Dio bookClient;

  BookService() {
    bookUtils = NetUtils();
    bookClient = bookUtils.getBookBaseClient();
  }
  //获取推荐列表
  Future<BookRecommend> getRecomendBooks() async {
    try {
      //404
      var response =
      await bookClient.get("/book/recommend?gender=male");
      BookRecommend bookRecommend = BookRecommend.fromJson(response.data);
      return bookRecommend;
    } on DioError catch (e) {
      printError(e);
    }
  }
  //获取分类列表
  Future<BookCategory> getCategoryList() async {
    try {
      //404
      var response =
      await bookClient.get("/cats/lv2/statistics");
      BookCategory bookCategory = BookCategory.fromJson(response.data);
      return bookCategory;
    } on DioError catch (e) {
      printError(e);
    }
  }
  /**
   * 获取书荒区帖子列表
   * 全部、默认排序  http://api.zhuishushenqi.com/post/help?duration=all&sort=updated&start=0&limit=20&distillate=
   * 精品、默认排序  http://api.zhuishushenqi.com/post/help?duration=all&sort=updated&start=0&limit=20&distillate=true
   *
   * @param duration   all
   * @param sort       updated(默认排序)
   * created(最新发布)
   * comment-count(最多评论)
   * @param start      0
   * @param limit      20
   * @param distillate true(精品) 、空字符（全部）
   * @return
   */
  Future<BookCommunity> getBookHelpList(String start) async {
    Map<String, dynamic> querys =Map();
    querys["duration"]="all";
    querys["sort"]="updated";
    querys["start"]=start;
    querys["limit"]="30";
    querys["distillate"]="";
    try {
      //404
      var response =
      await bookClient.get("/post/help",queryParameters: querys);
      BookCommunity bookCommunity = BookCommunity.fromJson(response.data);
      return bookCommunity;
    } on DioError catch (e) {
      printError(e);
    }
  }
  /**
   * 获取所有排行榜
   *
   * @return
   */
  Future<RankBook> getRanking() async {
    try {
      //404
      var response =
      await bookClient.get("/ranking/gender");
      RankBook bookRank = RankBook.fromJson(response.data);
      return bookRank;
    } on DioError catch (e) {
      printError(e);
    }
  }

  printError(DioError e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.request);
      print(e.message);
    }
  }
}