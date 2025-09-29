class Post {
  final String id;
  final String title;
  final String contentHtml;
  final String category;
  final String? imageUrl;
  final String? driveLink;
  final DateTime createdAt;
  final int views;

  Post({
    required this.id,
    required this.title,
    required this.contentHtml,
    required this.category,
    this.imageUrl,
    this.driveLink,
    required this.createdAt,
    this.views = 0,
  });

  factory Post.fromMap(String id, Map<String, dynamic> m) {
    return Post(
      id: id,
      title: m['title'] ?? '',
      contentHtml: m['contentHtml'] ?? '',
      category: m['category'] ?? '',
      imageUrl: m['imageUrl'],
      driveLink: m['driveLink'],
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      views: (m['views'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'contentHtml': contentHtml,
    'category': category,
    'imageUrl': imageUrl,
    'driveLink': driveLink,
    'createdAt': createdAt,
    'views': views,
  };
}
