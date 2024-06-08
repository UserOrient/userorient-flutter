class Project {
  final String? id;
  final String? name;
  final String? logoUrl;
  final String? color;

  Project({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.color,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      color: json['color'],
    );
  }
}
