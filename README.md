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
  userorient_flutter: ^0.0.1
```

### 📱 Add to your app

Initialize UserOrient before using it:


```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();

    ...
    UserOrient.configure(
        apiKey: 'YOUR_API_KEY',

        // All fields are optional, use `User.anonymous()` if you don't have any user information
        user: User(
            // Any unique identifier for the user
            uniqueIdentifier: '123456',
            
            // Full name of the user
            fullName: 'John Doe',

            // Email of the user
            email: 'bighead@bighetti.me',

            // Phone number of the user
            phoneNumber: '+1234567890',

            // Language of the user, determines the language of the board
            language: 'en',

            // Extra information about the user, can be used for filtering
            extra: {
                'age': 30,
                'isPremium': true,
            }
        ),
    );
    ...
}
```

### 🎬 Show the board

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void showBoard() {
    UserOrient.showBoard(context);
}
```

### 📝 Receive feature requests

By default users will see a "Request feature" button on the board itself. Additionally, if you want to open that screen from your app without showing the board, you can do so:

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void requestFeature() {
    UserOrient.openForm(context);
}
```

Don't forget to call `UserOrient.configure` before using this method too.

