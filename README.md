# [UserOrient.com](https://userorient.com)

**Feature Voting Board for Flutter**

UserOrient is a feature voting board that helps you collect feedback from your users and prioritize your development roadmap in your Flutter projects.

<p align="center">
  <img src="https://raw.githubusercontent.com/UserOrient/userorient-flutter/refs/heads/main/assets/cover.png" alt="UserOrient Cover" width="100%"/>
</p>

## Getting Started

Considering that you have already created a project on [UserOrient.com](https://userorient.com) and received an API key, follow these steps to integrate the SDK into your Flutter app.

### Add the dependency

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  userorient_flutter: <latest-version>
```

### Initialize the SDK

Initialize the SDK with your project's API key and preferred language:

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
    languageCode: 'en',
  );
```

### Display the board

To show the UserOrient board, call `UserOrient.showBoard(context)`:

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void showBoard() {
  // Set user information
  UserOrient.setUser(
    uniqueIdentifier: '123456',
    fullName: 'Kamran Bekirov',
    email: 'kamran@userorient.com',
    phoneNumber: '+1234567890',
    language: 'en',
    extra: {
      'age': 27,
      'is_premium': true,
    }
  );

  // Display the board
  UserOrient.openBoard(context);
}
```

> **Note:** It's recommended to call `UserOrient.setUser` before each board launch to ensure up-to-date user information.

## User Identification

UserOrient requires a unique identifier (`uniqueIdentifier`) for each user. This can be an email address, phone number, or custom ID. If not provided, UserOrient will generate a random identifier.

## Logging Out

When a user logs out of your app, call `UserOrient.clearCache()` to prevent potential issues:

```dart
await UserOrient.clearCache();
```

## Contact

For any questions or support, please reach out to us:

- Email: [support@userorient.com](mailto:support@userorient.com)
- Twitter: [@userorient](https://twitter.com/userorient)
- Live Chat: [userorient.com](https://userorient.com)

---

<p align="center">
  Made with 💙 by the UserOrient team
</p>
