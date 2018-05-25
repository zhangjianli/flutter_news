import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_news/model/news.dart';

class NewsApi {
  static Future<NewsList> getHeadLines(
      {String category: "general", int page: 0}) async {
    print("request $category - $page");
    final response = await http.get(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=efaf5fb66d104385ad40c73d4fd4acb1&page=$page&category=$category");

    return compute(parseResult, response.body);
  }

  static NewsList parseResult(String respond) {
    return NewsList.fromJson(json.decode(respond));
  }
}
