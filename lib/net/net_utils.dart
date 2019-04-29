import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:show_time_for_flutter/net/api.dart';
import 'dart:io';
import 'dart:convert';

var httpClient = new HttpClient();

class NetUtils {
  NetUtils();

  Dio getNewsBaseClient() {
    Map<String, dynamic> heeaders = new Map();
    heeaders["User-Agent"] =
        " Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11";
    BaseOptions options = new BaseOptions(
      baseUrl: Api.NEWS_HOST,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      headers: heeaders,
      method: "GET",
    );
    Dio newsClient = new Dio(options);
    return newsClient;
  }
  Dio getMusicBaseClient() {
    Map<String, dynamic> heeaders = new Map();
    heeaders["user-agent"] =
        "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:0.9.4)";
    BaseOptions options = new BaseOptions(
      baseUrl: Api.BASE_MUSIC_URL,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      headers: heeaders,
      method: "GET",
    );
    Dio musicClient = new Dio(options);
    return musicClient;
  }
  Dio getBookBaseClient() {
    BaseOptions options = new BaseOptions(
      baseUrl: Api.BASE_BOOKE_URL,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      method: "GET",
    );
    Dio boolClient = new Dio(options);
    return boolClient;
  }
  Dio getVideoBaseClient() {
    Map<String, dynamic> heeaders = new Map();
    heeaders["X-Channel-Code"] ="official";
    heeaders["X-Client-Agent"] ="Xiaomi";
    heeaders["X-Client-Hash"] ="2f3d6ffkda95dlz2fhju8d3s6dfges3t";
    heeaders["X-Client-ID"] ="123456789123456";
    heeaders["X-Client-Version"] ="5.4.7";
    heeaders["X-Long-Token"] ="";
    heeaders["X-Platform-Type"] ="0";
    heeaders["X-Platform-Version"] ="5.0";
    heeaders["X-User-ID"] ="";
    BaseOptions options = new BaseOptions(
      baseUrl: Api.BASE_KANKAN_VIDEO_URL,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      headers: heeaders,
    );
    Dio boolClient = new Dio(options);
    return boolClient;
  }
  Dio getBeaturePicutureBaseClient() {
    BaseOptions options = new BaseOptions(
      baseUrl: Api.BEAUTY_PICYURE_URL,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      method: "GET",
    );
    Dio boolClient = new Dio(options);
    return boolClient;
  }
  Dio getWefalePicutureBaseClient() {
    BaseOptions options = new BaseOptions(
      baseUrl: Api.WELF_CROSS_URL,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      method: "GET",
    );
    Dio boolClient = new Dio(options);
    return boolClient;
  }

}
