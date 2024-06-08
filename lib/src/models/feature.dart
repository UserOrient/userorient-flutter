class Feature {
  final String id;
  final String status;
  final String projectId;
  final String ownerType;
  final String? ownerFirstName;
  final String? ownerLastName;
  final int voteCount;
  final DateTime createdAt;
  final bool voted;
  final Map<String, dynamic> title;
  final Map<String, dynamic> description;

  String titleForLocale(String? locale) {
    return title[locale] ?? title['en'] ?? 'N/A';
  }

  String descriptionForLocale(String? locale) {
    return description[locale] ?? description['en'] ?? 'N/A';
  }

  bool get isSkeleton => id == 'skeleton';

  factory Feature.skeleton() {
    return Feature(
      id: 'skeleton',
      status: 'skeleton',
      projectId: 'skeleton',
      ownerType: 'skeleton',
      ownerFirstName: 'skeleton',
      ownerLastName: 'skeleton',
      voteCount: 0,
      createdAt: DateTime.now(),
      voted: false,
      title: {},
      description: {},
    );
  }

  Feature({
    required this.id,
    required this.status,
    required this.projectId,
    required this.ownerType,
    this.ownerFirstName,
    this.ownerLastName,
    required this.voteCount,
    required this.createdAt,
    required this.voted,
    required this.title,
    required this.description,
  });

  Feature copyWith({
    String? id,
    String? status,
    String? projectId,
    String? ownerType,
    String? ownerFirstName,
    String? ownerLastName,
    int? voteCount,
    DateTime? createdAt,
    bool? voted,
    Map<String, String?>? title,
    Map<String, String?>? description,
  }) {
    return Feature(
      id: id ?? this.id,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
      ownerType: ownerType ?? this.ownerType,
      ownerFirstName: ownerFirstName ?? this.ownerFirstName,
      ownerLastName: ownerLastName ?? this.ownerLastName,
      voteCount: voteCount ?? this.voteCount,
      createdAt: createdAt ?? this.createdAt,
      voted: voted ?? this.voted,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      status: json['status'],
      projectId: json['projectId'],
      ownerType: json['ownerType'],
      ownerFirstName: json['ownerFirstName'],
      ownerLastName: json['ownerLastName'],
      voteCount: json['voteCount'],
      createdAt: DateTime.parse(json['createdAt']),
      voted: json['voted'],
      title: json['title'],
      description: json['description'],
    );
  }
}
