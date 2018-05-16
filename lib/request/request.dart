import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_news/model/news.dart';
//import 'package:flutter/foundation.dart';

class NewsApi {

  static const String baseUrl = "https://newsapi.org/v2/";

  static const String headLine = "top-headlines";

  static const String everything = "everything";

  static const String queryKey = "q";

  static const String apiKey = "efaf5fb66d104385ad40c73d4fd4acb1";

  static const String categoryKey = "category";

  static Future<NewsList> getHeadLines ({String category}) async {
    final response = await http.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=efaf5fb66d104385ad40c73d4fd4acb1");

    return NewsList.fromJson(json.decode(response.body));

  }



}