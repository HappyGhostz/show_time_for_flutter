import 'package:show_time_for_flutter/net/net_utils.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:show_time_for_flutter/modul/book/book_recommend.dart';
import 'package:show_time_for_flutter/modul/book/book_category.dart';
import 'package:show_time_for_flutter/modul/book/book_community.dart';
import 'package:show_time_for_flutter/modul/book/rank/rank_book.dart';
import 'package:show_time_for_flutter/modul/book/read/chapters.dart';
import 'package:show_time_for_flutter/modul/book/read/chapter_body.dart';
import 'package:path_provider/path_provider.dart';
import 'package:event_bus/event_bus.dart';
import 'package:show_time_for_flutter/event/book_download_event.dart';
import 'package:show_time_for_flutter/modul/book/detail/book_detail.dart';
import 'package:show_time_for_flutter/modul/book/detail/hot_review.dart';
import 'package:show_time_for_flutter/modul/book/detail/recommend_list.dart';
import 'package:show_time_for_flutter/modul/book/detail/recommends_detail.dart';
import 'package:show_time_for_flutter/modul/book/category/category_bean.dart';
import 'package:show_time_for_flutter/modul/book/help/help_detail.dart';
import 'package:show_time_for_flutter/modul/book/help/comments.dart';
import 'package:show_time_for_flutter/modul/book/rank/rank_detial.dart';
import 'package:show_time_for_flutter/modul/book/help/discussion_list.dart';
import 'package:show_time_for_flutter/modul/book/search/auto_complete.dart';
import 'package:show_time_for_flutter/modul/book/search/hot_key.dart';
import 'package:show_time_for_flutter/modul/book/search/search_result.dart';

/**
 * @author zcp
 * @date 2019/3/29
 * @Description
 */
String IMG_BASE_URL = "http://statics.zhuishushenqi.com";

class BookService {
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
      var response = await bookClient.get("/book/recommend?gender=male");
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
      var response = await bookClient.get("/cats/lv2/statistics");
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
    Map<String, dynamic> querys = Map();
    querys["duration"] = "all";
    querys["sort"] = "updated";
    querys["start"] = start;
    querys["limit"] = "30";
    querys["distillate"] = "";
    try {
      //404
      var response =
          await bookClient.get("/post/help", queryParameters: querys);
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
      var response = await bookClient.get("/ranking/gender");
      RankBook bookRank = RankBook.fromJson(response.data);
      return bookRank;
    } on DioError catch (e) {
      printError(e);
    }
  }

  Future<ChapterBook> getBook(String bookId) async {
    Map<String, dynamic> querys = Map();
    querys["view"] = "chapters";

    try {
      //404
      var response =
          await bookClient.get("/mix-atoc/$bookId", queryParameters: querys);
      var data = response.data;
      ChapterBook chapterBook = ChapterBook.fromJson(data);
      return chapterBook;
    } on DioError catch (e) {
      printError(e);
    }
  }
  /**
   * 获取书籍详情数据
   */
  Future<BookDetail> getBookDetail(String bookId) async {
    try {
      //404
      var response =
      await bookClient.get("/book/$bookId");
      var data = response.data;
      BookDetail bookDetail = BookDetail.fromJson(data);
      return bookDetail;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  Future<BookHotReview> getBookHotReview(String bookId) async {
    Map<String, dynamic> querys = Map();
    querys["book"] = bookId;
    try {
      //404
      var response =
      await bookClient.get("/post/review/best-by-book",queryParameters: querys);
      var data = response.data;
      BookHotReview bookHotReview = BookHotReview.fromJson(data);
      return bookHotReview;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取书籍详情书评列表
   *
   * @param book  bookId
   * @param sort  updated(默认排序)
   * created(最新发布)
   * helpful(最有用的)
   * comment-count(最多评论)
   * @param start 0
   * @param limit 20
   * @return
   */
  Future<BookHotReview> getBookDetailReviewList(String bookId,int start) async {
    Map<String, dynamic> querys = Map();
    querys["book"] = bookId;
    querys["sort"] = "updated";
    querys["start"] = start;
    querys["limit"] = 30;
    try {
      //404
      var response =
      await bookClient.get("/post/review/by-book",queryParameters: querys);
      var data = response.data;
      BookHotReview bookHotReview = BookHotReview.fromJson(data);
      return bookHotReview;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取书籍详情讨论列表
   *
   * @param book  bookId
   * @param sort  updated(默认排序)
   * created(最新发布)
   * comment-count(最多评论)
   * @param type  normal
   * vote
   * @param start 0
   * @param limit 20
   * @return
   */
  Future<Discussions> getBookDetailDisscussionList(String bookId,int start) async {
    Map<String, dynamic> querys = Map();
    querys["book"] = bookId;
    querys["sort"] = "updated";
    querys["type"] = "normal,vote";
    querys["start"] = start;
    querys["limit"] = 30;
    try {
      //404
      var response =
      await bookClient.get("/post/by-book",queryParameters: querys);
      var data = response.data;
      Discussions bookCommunity = Discussions.fromJson(data);
      return bookCommunity;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  Future<BookRecommends> getBookRecommendList(String bookId) async {
    Map<String, dynamic> querys = Map();
    querys["limit"] = "5";
    try {
      //404
      var response =
      await bookClient.get("/book-list/$bookId/recommend",queryParameters: querys);
      var data = response.data;
      BookRecommends bookRecommends = BookRecommends.fromJson(data);
      return bookRecommends;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取书单详情
   *
   * @return
   */
  Future<BookRecommendsDetail> getRecommendBookListDetail(String bookId) async {
    try {
      //404
      var response =
      await bookClient.get("/book-list/$bookId");
      var data = response.data;
      BookRecommendsDetail bookRecommendsDetail = BookRecommendsDetail.fromJson(data);
      return bookRecommendsDetail;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 按分类获取书籍列表
   *
   * @param gender male、female
   * @param type   hot(热门)、new(新书)、reputation(好评)、over(完结)
   * @param major  玄幻
   * @param minor  东方玄幻、异界大陆、异界争霸、远古神话
   * @param limit  50
   * @return
   */
  Future<BookCategorys> getBooksByCats(String gender,String type,String major,int start) async {
    Map<String, dynamic> querys = Map();
    querys["gender"] = gender;
    querys["type"] = type;
    querys["major"] = major;
    querys["minor"] = "";
    querys["start"] = start;
    querys["limit"] = 30;
    try {
      //404
      var response =
      await bookClient.get("/book/by-categories",queryParameters: querys);
      var data = response.data;
      BookCategorys bookCategorys = BookCategorys.fromJson(data);
      return bookCategorys;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取书荒区帖子详情
   *
   * @param helpId->_id
   * @return
   */
  Future<BookHelpDetail> getBookHelpDetail(String helpId) async {
    try {
      //404
      var response =
      await bookClient.get("/post/help/$helpId");
      var data = response.data;
      BookHelpDetail bookHelpDetail = BookHelpDetail.fromJson(data);
      return bookHelpDetail;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取神评论列表(综合讨论区、书评区、书荒区皆为同一接口)
   *
   * @param disscussionId->_id
   * @return
   */
  Future<CommentList> getBestComments(String disscussionId) async {
    try {
      //404
      var response =
      await bookClient.get("/post/$disscussionId/comment/best");
      var data = response.data;
      CommentList commentList = CommentList.fromJson(data);
      return commentList;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取书评区、书荒区帖子详情内的评论列表
   *
   * @param bookReviewId->_id
   * @param start             0
   * @param limit             30
   * @return
   */
  Future<CommentList> getBookReviewComments(String disscussionId) async {
    Map<String, dynamic> querys = Map();
    querys["start"] = 0;
    querys["limit"] = 50;
    try {
      //404
      var response =
      await bookClient.get("/post/review/$disscussionId/comment",queryParameters: querys);
      var data = response.data;
      CommentList commentList = CommentList.fromJson(data);
      return commentList;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取单一排行榜
   * 周榜：rankingId->_id
   * 月榜：rankingId->monthRank
   * 总榜：rankingId->totalRank
   *
   * @return
   */
  Future<RankDetail> getRankingList(String rankingId) async {
    try {
      //404
      var response =
      await bookClient.get("/ranking/$rankingId");
      var data = response.data;
      RankDetail rankDetail = RankDetail.fromJson(data);
      return rankDetail;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 关键字自动补全
   *
   * @param query
   * @return
   */
  Future<AutoComplete> autoComplete(String query) async {
    Map<String, dynamic> querys = Map();
    querys["query"] = query;
    try {
      //404
      var response =
      await bookClient.get("/book/auto-complete",queryParameters: querys);
      var data = response.data;
      AutoComplete autoComplete = AutoComplete.fromJson(data);
      return autoComplete;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  Future<HotKeyWord> getHotWord() async {
    try {
      //404
      var response =
      await bookClient.get("/book/hot-word");
      var data = response.data;
      HotKeyWord hotKeyWord = HotKeyWord.fromJson(data);
      return hotKeyWord;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 书籍查询
   *
   * @param query
   * @return
   */
  Future<BookSearchResult> searchBooks(String query) async {
    Map<String, dynamic> querys = Map();
    querys["query"] = query;
    try {
      //404
      var response =
      await bookClient.get("/book/fuzzy-search",queryParameters: querys);
      var data = response.data;
      BookSearchResult bookSearchResult = BookSearchResult.fromJson(data);
      return bookSearchResult;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  Future<ChapterBody> getChapterBody(String chapterLink) async {
    try {
      Dio boolClient = new Dio();
      var url =
          "http://chapter2.zhuishushenqi.com/chapter/" + encode(chapterLink);
      //404
      var response = await boolClient.get(url);
      var data = response.data;
      ChapterBody chapterBody = ChapterBody.fromJson(data);
      return chapterBody;
    } on DioError catch (e) {
      printError(e);
    }
  }

  Future downloadChapter(EventBus eventBus,String bookId, List<Chapters> chapters,
      int currentChapter, int size) async {
    Dio boolClient = new Dio();

    for (int i = 0; i < size; i++) {
      var chapter = chapters[currentChapter + i + 1];
      Map<int,File> fileMap = await getChapterFile(bookId, currentChapter + i + 1);
      if (fileMap == null||fileMap.containsKey(1)) {
        print("continue:${currentChapter + i + 1}");
        eventBus.fire(new ChapterEvent("${chapter.title}:已缓存"));
        continue;
      }
      var file = fileMap[0];
      var link = chapter.link;
      var url = "http://chapter2.zhuishushenqi.com/chapter/" + encode(link);
      var response = await boolClient.get(url);
      var data = response.data;
      ChapterBody chapterBody = ChapterBody.fromJson(data);
      await file.writeAsStringSync(chapter.title+"|"+chapterBody.chapter.body);
      eventBus.fire(new ChapterEvent("正在缓存：${chapter.title}"));
    }
    eventBus.fire(new ChapterEvent("缓存完成!"));
  }

  Future<String> loadChapterFile(String bookId, int currentChapter) async {
    Map<int,File> fileMap = await getChapterFile(bookId, currentChapter);
    if (fileMap == null||fileMap.containsKey(0)) {
      return "";
    }
    var file = fileMap[1];
    if(file==null){
      return "";
    }
    var chapter = await file.readAsString();
//    debugPrint(chapter);
    return chapter;
  }

  Future<Map<int,File>> getChapterFile(String bookId, int currentChapter) async {
    Map<int,File> fileMap= new Map();
    String chapterPath = await getChapterPath(bookId, currentChapter);
    var file = new File(chapterPath);
    try {
      bool exists = await file.exists();
      if (!exists) {
        file = await file.create();
        fileMap[0]=file;
      }else if(await file.length()>50){
        fileMap[1]=file;
      }
      return fileMap;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getChapterPath(String bookId, int chapter) async {
    var loaclPath = await localPath();
    if (loaclPath != "") {
      var directory =
          new Directory("$loaclPath/book/$bookId${Platform.pathSeparator}");
      directory.createSync(recursive: true);
      var path = directory.path;
      print("path:$path");
      print("chapterpath:$path$chapter.txt");
      return "$path$chapter.txt";
    } else {
      return "";
    }
  }

  Future<String> localPath() async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print('文档目录: ' + appDocPath);
      return appDocPath;
    } catch (err) {
      print(err);
      return "";
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

  String encode(String encode) {
    if (encode == null) return "";

    try {
      return Uri.encodeQueryComponent(encode);
    } catch (e) {
      print(e.message);
    }
  }
  String decode(String encode) {
    if (encode == null) return "";

    try {
      return Uri.decodeComponent(encode);
    } catch (e) {
      print(e.message);
    }
  }
}
