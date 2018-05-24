import 'package:json_annotation/json_annotation.dart';

part "news.g.dart";

@JsonSerializable()
class News extends Object with _$NewsSerializerMixin {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final Source source;

  News(this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.source);

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
}

@JsonSerializable()
class Source extends Object with _$SourceSerializerMixin {
  final String id;
  final String name;

  Source(this.id, this.name);

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}

@JsonSerializable()
class NewsList extends Object with _$NewsListSerializerMixin {

  final String status;
  final int totalResults;
  final List<News> articles;
  final code;
  final message;

  NewsList(this.status, this.totalResults, this.articles, this.code, this.message);

  factory NewsList.fromJson(Map<String, dynamic> json) => _$NewsListFromJson(json);

}



