import 'package:show_time_for_flutter/net/net_utils.dart';
import 'package:dio/dio.dart';
import 'package:show_time_for_flutter/modul/video/video_list.dart';
import 'package:show_time_for_flutter/modul/video/video_detail.dart';

/**
 * @author zcp
 * @date 2019/4/27
 * @Description
 */
class VideoServices{
  NetUtils videoUtils;
  Dio videoClient;

  VideoServices() {
    videoUtils = NetUtils();
    videoClient = videoUtils.getVideoBaseClient();
  }
  /**
   * 头条
   */
  Future<Videos> getKankanVideoList() async {
    var timer = DateTime.now().millisecondsSinceEpoch/1000;
    var headers = videoClient.options.headers;
    headers["X-Serial-Num"]=timer.toString();
    Map<String, dynamic> querys = Map();
    querys["lastLikeIds"] = "1063871%2C1063985%2C1064069%2C1064123%2C1064078%2C1064186%2C1062372%2C1064164%2C1064081%2C1064176%2C1064070%2C1064019";
    try {
      //404
      var response = await videoClient.get("/home.jsp",queryParameters: querys);
      Videos videos = Videos.fromJson(response.data);
      return videos;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  //这里我实际抓取了一下Get也可以
  Future<Videos> getKankanVideoFromCate(int page,int start,String categoryId) async {
//    @Field("hotPageidx")page:Int,
//    @Field("start")start:Int,
//    @Field("categoryId")categoryId:String)
//    FormData formData = new FormData.from({
//      "hotPageidx": "wendux",
//      "start": start,
//      "categoryId": categoryId,
//    });
    var timer = DateTime.now().millisecondsSinceEpoch/1000;
    var headers = videoClient.options.headers;
    headers["X-Serial-Num"]=timer.toString();
    Map<String, dynamic> querys = Map();
    querys["hotPageidx"] = page;
    querys["start"] = start;
    querys["categoryId"] = categoryId;
    try {
      //404
      var response = await videoClient.get("/getCategoryConts.jsp",queryParameters: querys);
      Videos videos = Videos.fromJson(response.data);
      return videos;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }

  Future<VideoDetail> getVideoDetailInfo(String contId) async {
    var timer = DateTime.now().millisecondsSinceEpoch/1000;
    var headers = videoClient.options.headers;
    headers["X-Serial-Num"]=timer.toString();
    Map<String, dynamic> querys = Map();
    querys["contId"] = contId;
    try {
      //404
      var response = await videoClient.get("/content.jsp",queryParameters: querys);
      VideoDetail videoDetail = VideoDetail.fromJson(response.data);
      return videoDetail;
    } on DioError catch (e) {
      printError(e);
      return null;
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