import 'package:show_time_for_flutter/net/net_utils.dart';
import 'package:show_time_for_flutter/modul/picture/beauty.dart';
import 'package:show_time_for_flutter/modul/picture/welfare.dart';
import 'package:dio/dio.dart';

/**
 * @author zcp
 * @date 2019/4/29
 * @Description
 */
class PictureServices {
  NetUtils pictureUtils;
  Dio pictureClient;
  Dio wefaleClient;

  PictureServices() {
    pictureUtils = NetUtils();
    pictureClient = pictureUtils.getBeaturePicutureBaseClient();
    wefaleClient = pictureUtils.getWefalePicutureBaseClient();
  }
  /**
   * 获取美女图片
   * API获取途径http://www.jb51.net/article/61266.htm
   * eg: http://image.baidu.com/data/imgs?sort=0&pn=0&rn=20&col=美女&tag=全部&tag3=&p=channel&from=1
   * 通过分析，推断并验证了其中字段的含义，col表示频道，tag表示的是全部的美女，也可以是其他Tag，pn表示从第几张图片开始，rn表示获取多少张
   * @param page 页码
   * @return
   */
  Future<BeautyPhoto> getBeautyPhoto(int start,int size,String col,String tag) async {
    Map<String, dynamic> querys = Map();
    querys["sort"] = "0";
    querys["pn"] = start;
    querys["rn"] = size;
    querys["col"] = col;
    querys["tag"] = tag;
    querys["tag3"] = "";
    querys["p"] = "channel";
    querys["from"] = 1;
    try {
      //404
      var response = await pictureClient.get("/imgs",queryParameters: querys);
      BeautyPhoto beautyPhoto = BeautyPhoto.fromJson(response.data);
      return beautyPhoto;
    } on DioError catch (e) {
      printError(e);
      return null;
    }
  }
  /**
   * 获取福利图片
   * eg: http://gank.io/api/data/福利/10/1
   *
   * @param page 页码
   * @return
   */
  Future<Welfare> getWelfarePhoto(int page) async {
    try {
      //404
      var response = await wefaleClient.get("/api/data/福利/10/$page");
      Welfare welfare = Welfare.fromJson(response.data);
      return welfare;
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
