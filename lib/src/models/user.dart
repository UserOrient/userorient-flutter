class User {
  final String? id;
  final String? uniqueIdentifier;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? language;
  final bool? isPaying;
  final Map<String, dynamic>? extra;

  const User({
    this.id,
    this.uniqueIdentifier,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.language,
    this.isPaying,
    this.extra,
  });

  bool get isAnonymous => uniqueIdentifier == null;

  const User.anonymous()
      : id = null,
        uniqueIdentifier = null,
        fullName = null,
        email = null,
        phoneNumber = null,
        language = null,
        isPaying = null,
        extra = null;

  User copyWith({
    String? id,
    String? uniqueIdentifier,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? language,
    bool? isPaying,
    Map<String, dynamic>? extra,
  }) {
    return User(
      id: id ?? this.id,
      uniqueIdentifier: uniqueIdentifier ?? this.uniqueIdentifier,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      language: language ?? this.language,
      isPaying: isPaying ?? this.isPaying,
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toJson(String? id) {
    final Map<String, dynamic> extra = {
      if (isPaying != null) 'isPaying': isPaying,
    };

    return {
      'id': id,
      'userId': id,
      'uniqueIdentifier': uniqueIdentifier,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'language': language,
      'extra': extra,
    };
  }
}
