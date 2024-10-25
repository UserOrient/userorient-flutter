class Label {
  final String id;
  final String color;
  final Map<String?, dynamic> name;

  const Label({
    required this.id,
    required this.color,
    required this.name,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      id: json['id'],
      color: json['color'],
      name: json['name'],
    );
  }

  bool get isCompleted => id == '07d82cf0-51ea-45d5-b274-59edb1b11a20';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Label && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
