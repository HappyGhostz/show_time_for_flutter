import 'package:show_time_for_flutter/net/net_utils.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:show_time_for_flutter/modul/news_info.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:show_time_for_flutter/modul/photos.dart';
import 'dart:convert';
import 'package:show_time_for_flutter/modul/news_detail.dart';
import 'package:show_time_for_flutter/modul/special_info.dart';
import 'package:show_time_for_flutter/modul/photos_detail.dart';


class NewsServiceApi {
  final String HEAD_LINE_NEWS = "T1348647909107";
  NetUtils newsUtils;
  Dio newsClient;

  NewsServiceApi() {
    newsUtils = NetUtils();
    newsClient = newsUtils.getNewsBaseClient();
  }
  //获取新闻列表
  Future<NewsInfo> getnewsList(String id, int startPage) async {
    String type;
    if (id == HEAD_LINE_NEWS) {
      type = "headline";
    } else {
      type = "list";
    }
    try {
      //404
      var response =
          await newsClient.get("/nc/article/$type/$id/$startPage-20.html");
      NewsInfo newsInfo = NewsInfo.fromJson(id, response.data);
      return newsInfo;
    } on DioError catch (e) {
      printError(e);
    }
  }


  //解析出图集URL
  Future<PhotoSet> getPhotos(String id) async {
    var photoResponse = await newsClient.get(
        "http://news.163.com/photoview/$id.html",
        options: Options(responseType: ResponseType.bytes));
    String decodePhoto = gbk.decode(photoResponse.data);
    List<String> htmls = decodePhoto
        .split('<textarea name="gallery-data" style="display:none;">');
    var html = htmls[1];
    List<String> photos = html.split('</textarea>');
    var photo = photos[0];
    var photoJson = jsonDecode(photo);
    PhotoSet photoSet = PhotoSet.fromJson(photoJson);
    return photoSet;
  }
  //获取专题内容
  Future<SpecialNews> getSpecialNews(String specialId)async{
    try {
      //404
      var response =
      await newsClient.get("/nc/special/$specialId.html");
      SpecialNews newsInfo = SpecialNews.fromJson(specialId, response.data);
      return newsInfo;
    } on DioError catch (e) {
      printError(e);
    }
  }
  //获取图集内容
  Future<PhotoSetInfo> getPhotosNews(String photosId)async{
    try {
      //404
      var response =
      await newsClient.get("/photo/api/set/$photosId.json");
      PhotoSetInfo photoSetInfo = PhotoSetInfo.fromJson( response.data);
      return photoSetInfo;
    } on DioError catch (e) {
      printError(e);
    }
  }
  //获取新闻详情
  Future<NewsDetail> getNewsDetail(String id) async {
    try {
      //404
      var response =
      await newsClient.get("/nc/article/$id/full.html");
      NewsDetail newsInfo = NewsDetail.fromJson(id, response.data);
      return newsInfo;
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
