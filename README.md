# [UserOrient.com](https://userorient.com)

**Feature Voting Board for Flutter**

UserOrient is a feature voting board that helps you collect feedback from your users and prioritize your development roadmap in your Flutter projects.

<p align="center">
  <img src="https://raw.githubusercontent.com/UserOrient/userorient-flutter/refs/heads/main/assets/cover.png" alt="UserOrient Cover" width="100%"/>
</p>

## 🎯 Getting Started

Considering that you have already created a project on [UserOrient.com](https://app.userorient.com) and received an API key, follow these steps to integrate the SDK into your Flutter app.

### 📦 Add the dependency

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  userorient_flutter: <latest-version>
```

### ⚙️ Initialize the SDK

Initialize the SDK with your project's API key and preferred language:

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
    languageCode: 'en',
  );
```

### 🎨 Display the board

To show the UserOrient board, call `UserOrient.openBoard(context)`. Make sure to set user information first (see [User Identification](#user-identification) below):

```dart
UserOrient.openBoard(context);
```

## 👤 User Identification

Before displaying the board, set user information using `UserOrient.setUser()`. UserOrient requires a unique identifier (`uniqueIdentifier`) for each user. This can be an email address, phone number, or custom ID. If not provided, UserOrient will generate a random identifier.

```dart
UserOrient.setUser(
  uniqueIdentifier: '123456',
  fullName: 'Kamran Bekirov',
  email: 'kamran@userorient.com',
  phoneNumber: '+1234567890',
  language: 'en',
  isPaying: true,
  extra: {
    'age': 27,
    'gender': 'male',
  }
);
```

> **Note:** It's recommended to call `UserOrient.setUser` before each board launch to ensure up-to-date user information.

## 💰 Paying Users

Set the `isPaying` property to `true` for users who have a paid subscription or are paying customers. This enables powerful filtering in your UserOrient dashboard:

- **Filter by paying users**: Toggle "filter by paying users" in the dashboard to see votes specifically from paying customers
- **Prioritize features**: Understand which features matter most to your revenue-generating users
- **Better decision-making**: Make data-driven decisions by focusing on feedback from your most valuable users

See the `isPaying` property in the [User Identification](#user-identification) example above.

## 👋 Logging Out

When a user logs out of your app, call `UserOrient.clearCache()` to prevent potential issues:

```dart
await UserOrient.clearCache();
```

## 💬 Contact

For any questions or support, please reach out to us:

- Email: [kamran@userorient.com](mailto:kamran@userorient.com)
- Twitter: [@userorient](https://twitter.com/userorient)