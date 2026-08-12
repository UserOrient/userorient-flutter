# [UserOrient](https://userorient.com)

**Feature voting board for Flutter apps.**

Let your users vote on what to build next. Collect feedback, prioritize your roadmap, ship what matters.

<p align="center">
  <img src="https://raw.githubusercontent.com/UserOrient/userorient-flutter/refs/heads/main/assets/cover.png" alt="UserOrient Cover" width="100%"/>
</p>

## 🚀 Install

```yaml
dependencies:
  userorient_flutter: <latest-version>
```

---

## ⚙️ Configure

Call once at startup. Only `apiKey` is required.

```dart
import 'package:userorient_flutter/userorient_flutter.dart';

void main() {
  UserOrient.configure(
    // From the dashboard: https://app.userorient.com
    apiKey: 'YOUR_API_KEY',

    // Colors the primary button and the voted state.
    accentColor: Colors.blue,

    // Used in dark mode. Falls back to accentColor.
    darkAccentColor: Colors.lightBlueAccent,

    // Board language. Defaults to English.
    language: Language.en,

    // Asks for an email on submit.
    //   required     — must be entered before submitting
    //   optional     — can be skipped (default)
    //   notCollected — step is skipped entirely
    collectEmail: CollectionMode.optional,

    // Phone model, OS version and your app version.
    collectMetadata: CollectionMode.optional,
  );

  runApp(MyApp());
}
```

You can't change the background or other colors — the board picks those itself so text always stays readable. It does use your app's font.

---

## 👤 Identify

Tell us who the user is, so their votes are still there next time.

```dart
UserOrient.identify(
  // Your own user ID. We make one up if you skip it.
  id: '123456',

  // Display name shown on their comments.
  name: 'Kamran Bekirov',

  // Used for follow-ups on their suggestions.
  email: 'kamran@userorient.com',

  phoneNumber: '+994501234567',

  // Lets you see which votes came from paying customers.
  isPaying: true,

  // Anything else you want to save about them.
  extra: {'plan': 'pro', 'seats': 4},
);
```

Every field is optional. Skip them all and the user stays anonymous, but their votes are still remembered.

```dart
// Forgets the user, so the next person doesn't get their votes.
await UserOrient.logout();
```

---

## 📋 Open the board

```dart
// The only screen you open. Users suggest features from inside the board,
// so they see what's already there before adding a duplicate.
UserOrient.openBoard(context);
```

Slides up as a sheet on phones, in from the side on web and desktop.

---

## 🌍 Language

`az` `de` `en` `es` `fr` `it` `tr` `ru` `ar` `uk` `zh`

```dart
// Turns a locale string into a Language. Unknown ones become English.
Language.fromCode('en-US'); // Language.en
```

---

## ⬆️ Upgrading to 3.0.0

The old methods still work for now, but they're removed in 4.0.0.

```dart
setTheme(light: ..., dark: ...)                →  configure(accentColor: ..., darkAccentColor: ...)
setLanguage(lang)                              →  configure(language: ...)
setDataCollection(...)                         →  configure(collectEmail: ..., collectMetadata: ...)
setUser(uniqueIdentifier: ..., fullName: ...)  →  identify(id: ..., name: ...)
clearCache()                                   →  logout()
openForm(context)                              →  openBoard(context)
```

`backgroundColor` is gone. It let you set a background the rest of the board couldn't match, so things stopped being readable.

---

## 📬 Contact

- Email: [kamran@userorient.com](mailto:kamran@userorient.com)
- Twitter: [@userorient](https://twitter.com/userorient)
