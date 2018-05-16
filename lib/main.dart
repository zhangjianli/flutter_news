import 'package:flutter/material.dart';
import 'package:flutter_news/model/news.dart';
import 'package:flutter_news/request/request.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeadLines',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeadLinePage(title: 'HeadLines'),
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
      body: FutureBuilder<NewsList>(
        future: NewsApi.getHeadLines(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return snapshot.hasData
              ? HeadLineList(newsList: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class HeadLineList extends StatelessWidget {
  final NewsList newsList;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  HeadLineList({Key key, this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: newsList.articles.length,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebviewScaffold(
                              url: '${newsList.articles[index].url}',
                              appBar: AppBar(title: Text("News Detail")),
                            )));
              },
              title: Text('${newsList.articles[index].title}'),
              subtitle: Text('${newsList.articles[index].author}'),
              leading: Image.network('${newsList.articles[index].urlToImage}'));
        });
  }
}
