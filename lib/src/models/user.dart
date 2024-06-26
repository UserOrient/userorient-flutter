class User {
  final String? uniqueIdentifier;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? language;
  final Map<String, dynamic>? extra;

  const User({
    this.uniqueIdentifier,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.language,
    this.extra,
  });

  bool get isAnonymous => uniqueIdentifier == null;

  const User.anonymous()
      : uniqueIdentifier = null,
        fullName = null,
        email = null,
        phoneNumber = null,
        language = null,
        extra = null;

  Map<String, dynamic> toJson(String? id) {
    return {
      'id': id,
      'uniqueIdentifier': uniqueIdentifier,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'language': language,
      'extra': extra,
    };
  }
}
