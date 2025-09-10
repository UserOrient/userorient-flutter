import 'package:userorient_flutter/src/models/label.dart';

class Feature {
  final String id;
  final String status;
  final String projectId;
  final String ownerType;
  final String? ownerFirstName;
  final String? ownerLastName;
  final int voteCount;
  final DateTime? createdAt;
  final bool voted;
  final Map<String, dynamic> title;
  final Map<String, dynamic> description;
  final List<Label>? labels;
  final int? commentsCount;

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
      labels: [],
      commentsCount: 0,
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
    required this.labels,
    required this.commentsCount,
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
    List<Label>? labels,
    int? commentsCount,
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
      labels: labels ?? this.labels,
      commentsCount: commentsCount ?? this.commentsCount,
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
      createdAt:
          json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      voted: json['voted'],
      title: json['title'],
      description: json['description'],
      labels: json['labels'] != null
          ? List<Label>.from(json['labels'].map((x) => Label.fromJson(x)))
          : [],
      commentsCount: json['commentsCount'],
    );
  }
}
