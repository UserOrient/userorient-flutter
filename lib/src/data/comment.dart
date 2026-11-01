class Comment {
  final String? id;
  final String? content;
  final String? ownerFullName;
  final DateTime? createdAt;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.content,
    required this.ownerFullName,
    required this.createdAt,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      ownerFullName: json['ownerFullName'],
      createdAt:
          json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((reply) => Comment.fromJson(reply))
              .toList()
          : [],
    );
  }
}
