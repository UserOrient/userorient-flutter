# [UserOrient](https://userorient.com)

**Feature voting board for Flutter apps.**

Let your users vote on what to build next. Collect feedback, prioritize your roadmap, ship what matters.

<p align="center">
  <img src="https://raw.githubusercontent.com/UserOrient/userorient-flutter/refs/heads/main/assets/cover.png" alt="UserOrient Cover" width="100%"/>
</p>

## Getting Started

### 1. Install

```yaml
dependencies:
  userorient_flutter: <latest-version>
```

### 2. Configure

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
    languageCode: 'en',
  );

  runApp(MyApp());
}
```

Get your API key from the [UserOrient dashboard](https://app.userorient.com).

### 3. Identify the user

Call `setUser` before opening any views. Pass a `uniqueIdentifier` so votes persist across installs — this can be an email, phone number, or your own ID. If omitted, UserOrient generates one automatically.

```dart
UserOrient.setUser(
  uniqueIdentifier: '123456',
  fullName: 'Kamran Bekirov',
  email: 'kamran@userorient.com',
);
```

All fields are optional. Pass whatever you have:

| Field | Description |
|---|---|
| `uniqueIdentifier` | Your internal user ID |
| `fullName` | Display name |
| `email` | Email address |
| `phoneNumber` | Phone number |
| `language` | User's language code |
| `isPaying` | Whether this is a paying customer ([learn more](#paying-users)) |
| `extra` | Any additional key-value data |

### 4. Open the board

```dart
UserOrient.openBoard(context);
```

That's it. Three lines of setup, one line to launch.

> Call `setUser` before each board launch to keep user info fresh.

---

## Data Collection

Control what data the SDK collects when a user submits feedback. Pass a `DataCollection` to `configure()`:

```dart
UserOrient.configure(
  apiKey: 'YOUR_API_KEY',
  languageCode: 'en',
  dataCollection: DataCollection(
    email: CollectionMode.required,
    metadata: CollectionMode.optional,
  ),
);
```

Each field accepts a `CollectionMode`:

| Mode | Email behavior | Metadata behavior |
|---|---|---|
| `required` | User must enter an email before submitting | Always collected |
| `optional` | User can skip the email step *(default)* | Collected if available *(default)* |
| `notCollected` | Email step is skipped entirely | Not collected |

**Metadata** includes device info (model, OS version) and app info (version, build number) — useful for debugging and context.

---

## Paying Users

Mark paying customers so you can filter their votes in the dashboard:

```dart
UserOrient.setUser(
  uniqueIdentifier: '123456',
  isPaying: true,
);
```

This lets you:
- See what paying users want most
- Prioritize features that drive revenue
- Make decisions based on your most valuable users

---

## Theming

Match the board to your app's design:

```dart
UserOrient.setTheme(
  light: UserOrientColors(
    backgroundColor: Colors.white,
    accentColor: Colors.blue,
  ),
  dark: UserOrientColors(
    backgroundColor: Color(0xff1D1D1D),
    accentColor: Colors.blue,
  ),
);
```

| Property | Description |
|---|---|
| `backgroundColor` | Board background color |
| `accentColor` | Buttons, active tabs, voted state (text color adjusts automatically) |

Font family is inherited from your app's `ThemeData`.

---

## Localization

The SDK supports 11 languages out of the box. Pass the language code to `configure()`:

`en` `az` `de` `es` `fr` `it` `tr` `ru` `ar` `uk` `zh`

---

## Logging Out

Clear cached data when a user logs out:

```dart
await UserOrient.clearCache();
```

---

## Contact

- Email: [kamran@userorient.com](mailto:kamran@userorient.com)
- Twitter: [@userorient](https://twitter.com/userorient)
