class User {
  final String? uniqueIdentifier;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? language;
  final bool? isPaying;
  final Map<String, dynamic>? extra;

  const User({
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
      : uniqueIdentifier = null,
        fullName = null,
        email = null,
        phoneNumber = null,
        language = null,
        isPaying = null,
        extra = null;

  Map<String, dynamic> toJson(String? id) {
    final Map<String, dynamic> extra = {
      if (isPaying != null) 'isPaying': isPaying,
    };

    return {
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
