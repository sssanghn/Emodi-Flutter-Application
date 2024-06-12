class Post {
  final String title;
  final String content;
  final int likeCount;
  final String imageUrl;
  final String memberLoginId;
  final DateTime createdAt;
  final List<String> keywords;

  Post({
    required this.title,
    required this.content,
    required this.likeCount,
    required this.imageUrl,
    required this.memberLoginId,
    required this.createdAt,
    required this.keywords,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      content: json['content'],
      likeCount: json['likeCount'],
      imageUrl: json['imageUrl'],
      memberLoginId: json['memberLoginId'],
      createdAt: DateTime.parse(json['createdAt']),
      keywords: List<String>.from(json['keywordList'].map((k) => k['keywordTag'])),
    );
  }
}

class LoadPosts {
  final int totalPages;
  final int totalElements;
  final int size;
  final List<Post> content;
  final int number;
  final bool first;
  final bool last;

  LoadPosts({
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.content,
    required this.number,
    required this.first,
    required this.last,
  });

  factory LoadPosts.fromJson(Map<String, dynamic> json) {
    return LoadPosts(
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      size: json['size'],
      content: List<Post>.from(json['content'].map((item) => Post.fromJson(item))),
      number: json['number'],
      first: json['first'],
      last: json['last'],
    );
  }
}

class NewPost {
  final String title;
  final String content;
  final List<String> keyword;
  final String imageBytes;

  NewPost({
    required this.title,
    required this.content,
    required this.keyword,
    required this.imageBytes,
  });

  factory NewPost.fromJson(Map<String, dynamic> json) {
    return NewPost(
      title: json['title'],
      content: json['content'],
      keyword: List<String>.from(json['keyword']),
      imageBytes: json['imageBytes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'keyword': keyword,
      'imageBytes': imageBytes,
    };
  }
}