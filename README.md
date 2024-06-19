# UserOrient SDK for Flutter

## 🚀 Introduction

Discover what your users really want and stop building wrong features. 

UserOrient is a feature request board that helps you collect feedback from your users and prioritize what to build next.

## 🤓 Getting Started

### 🔓 Join closed-beta

<a href="https://scolpshz3d6.typeform.com/to/EXb0XM52" target="_blank"><img src="https://userorient.com/logos/cover.jpg" alt="UserOrient" width="100%"/></a>

Right now, UserOrient is in closed-beta. If you want to join, for which I would be very grateful, please fill out this [form](https://scolpshz3d6.typeform.com/to/EXb0XM52) and I will get back to you as soon as possible.

Supposing you have been accepted, you will receive an API key which you will use to configure UserOrient. 

### ⛓️ Add the dependency

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  userorient_flutter: ^0.0.3
```

### 📱 Add to your app

Before using, configure UserOrient with your API key:


```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
  );
```

### 🎬 Show the board

Now you can show the board by calling `UserOrient.showBoard(context)`:

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void showBoard() {
  // Call before every launch of the board
  UserOrient.setUser(
    // Any unique identifier for the user
    uniqueIdentifier: '123456',

    // User information
    fullName: 'John Doe',
    email: 'bighead@bighetti.me',
    phoneNumber: '+1234567890',
    language: 'en',

    // Extra dynamic information about the user
    extra: {
      'age': 30,
      'isPremium': true,
    }
  }

  // Show the board
  UserOrient.showBoard(context);
}
```

We recommend calling `UserOrient.setUser` before every launch of the board to ensure the user information is up-to-date.

## 📝 User identification

UserOrient takes a unique identifier (`uniqueIdentifier`) for each user. This identifier can be anything that uniquely identifies the user, such as an email address, phone number, or a custom ID. When not provided, UserOrient will generate a random identifier for the user.

## 📧 Contact

If you have any questions, feel free to reach out to us at [support@userorient.com](mailto:support@userorient.com) or on live chat at [userorient.com](https://userorient.com).