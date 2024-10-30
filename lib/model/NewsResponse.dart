class NewsArticle {
  final String title;
  final String link;
  final String date;
  final String source;
  final String? imageUrl;
  final String position;

  NewsArticle({
    required this.title,
    required this.link,
    required this.date,
    required this.source,
    this.imageUrl,
    required this.position,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      link: json['link'],
      date: json['date'],
      source: json['source'],
      imageUrl: json['imageUrl'],
      position: json['position'],
    );
  }
}