import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news/model/news.dart';
import 'package:flutter_news/request/request.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_news/widget/loading_footer.dart';
import 'package:flutter_news/widget/news_item.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Headlines',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeadLinePage(title: 'Headlines'),
    );
  }
}

class HeadLinePage extends StatelessWidget {
  final String title;

  HeadLinePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: HeadLineList());
  }
}

class HeadLineList extends StatefulWidget {
  @override
  _HeadLineListState createState() => new _HeadLineListState();
}

class _HeadLineListState extends State<HeadLineList> {
  static const int IDLE = 0;
  static const int LOADING = 1;
  static const int ERROR = 3;
  static const int EMPTY = 4;

  int _pageCount = 0;

  int _status = IDLE;
  String _message;

  int _footerStatus = LoadingFooter.IDLE;
  double _lastOffset = 0.0;

  String _category;

  List<News> _articles;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  Completer<Null> _completer;

  ScrollController _controller;

  Future _getNews() async {
    _pageCount = 0;
    NewsList news = await NewsApi.getHeadLines();
    _articles = news?.articles;
    if (_completer != null) {
      _completer.complete();
      _completer = null;
    }
    setState(() {
      if ("ok".compareTo(news?.status) != 0) {
        _status = ERROR;
        _message = news?.message;
      } else if (_articles?.isEmpty ?? false) {
        _status = EMPTY;
      } else {
        _pageCount++;
        _status = IDLE;
      }
    });
  }

  Future<Null> _onRefresh() {
    _completer = new Completer<Null>();
    _getNews();
    return _completer.future;
  }

  Future loadMore() async {
    setState(() {
      _footerStatus = LoadingFooter.LOADING;
    });
    NewsList news = await NewsApi.getHeadLines(page: _pageCount);
    setState(() {
      if (news?.articles?.isNotEmpty ?? false) {
        _pageCount++;
      }
      _articles.addAll(news?.articles);
      _footerStatus = LoadingFooter.IDLE;
    });
  }

  @override
  void initState() {
    super.initState();
    _status = LOADING;
    _controller = ScrollController();
    _controller.addListener(() {
      if (_footerStatus == LoadingFooter.IDLE &&
          _controller.offset > _lastOffset &&
          _controller.position.maxScrollExtent - _controller.offset < 100) {
        loadMore();
      }
      _lastOffset = _controller.offset;
    });
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case IDLE:
        return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
                itemCount: _articles.length + 1,
                itemBuilder: (context, index) {
                  if (index == _articles.length) {
                    return LoadingFooter(
                        retry: () {
                          loadMore();
                        },
                        state: _footerStatus);
                  } else {
                    return NewsItem(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebviewScaffold(
                                        url: '${_articles[index].url}',
                                        appBar:
                                            AppBar(title: Text("News Detail")),
                                      )));
                        },
                        news: _articles[index]);
                  }
                },
                controller: _controller));
        break;
      case LOADING:
        return Center(child: CircularProgressIndicator());
        break;
      case ERROR:
        return Center(
            child: Text(_message ??
                "Something is wrong, you might need reboot your device."));
        break;
      case EMPTY:
        return Center(child: Text("No news is good news!"));
        break;
      default:
        return Center(child: Text("Emm..."));
        break;
    }
  }
}
