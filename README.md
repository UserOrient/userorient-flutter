# UserOrient SDK for Flutter

## 🚀 Introduction

Discover what your users really want and stop building wrong features. 

UserOrient is a feature request board that helps you collect feedback from your users and prioritize what to build next.

## 🤓 Getting Started

### 🔓 Join closed-beta

Right now, UserOrient is in closed-beta. If you want to join, for which I would be very grateful, please fill out this [form](https://scolpshz3d6.typeform.com/to/EXb0XM52) and I will get back to you as soon as possible.

Supposing you have been accepted, you will receive an API key which you will use to configure UserOrient. 

### ⛓️ Add the dependency

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  userorient_flutter: ^0.0.3
```

### 📱 Add to your app

Initialize UserOrient before using it:


```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
  );
```

### 🎬 Show the board

Now you can show the board by calling the `showBoard` method. Before that, call `setUser` method with the user's details.

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