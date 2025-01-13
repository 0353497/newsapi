class Article {
  final String title;
  final String description;
  final String? imageUrl;
  final String? href;
  final String? content;
  const Article({
    required this.title,
    required this.description,
    this.imageUrl,
    this.href,
    this.content,
  });
}
