class Project {
  final String? id;
  final bool? onPaidPlan;

  Project({
    required this.id,
    required this.onPaidPlan,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      onPaidPlan: json['onPaidPlan'],
    );
  }
}
