class Comment {
  final String? id;
  final String? content;
  final String? ownerFullName;
  final DateTime? createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.ownerFullName,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      ownerFullName: json['ownerFullName'],
      createdAt:
          json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    );
  }
}
