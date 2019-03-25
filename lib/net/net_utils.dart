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
    Dio newsClient = new Dio(options);
    return newsClient;
  }
}
