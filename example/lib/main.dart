import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Call once, before the board is ever opened. Only `apiKey` is required.
  UserOrient.configure(
    apiKey: '4138274d-e8fb-4222-8daf-62a730875590',

    // Tints the primary button and the voted state. Text on top of it is
    // derived automatically, so it stays legible whatever you pass.
    accentColor: const Color(0xff2A2A2A),
    darkAccentColor: const Color(0xffFAFAFA),

    // Or Language.fromCode('en-US'). Unsupported codes fall back to English.
    language: Language.en,

    // required     — must be entered before submitting
    // optional     — can be skipped (default)
    // notCollected — step is skipped entirely
    collectEmail: CollectionMode.optional,

    // Device model, OS version, app version and build number.
    collectMetadata: CollectionMode.optional,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The board inherits the host app's font family from ThemeData, and
    // follows its brightness. Everything else it draws itself.
    final TextTheme textTheme = GoogleFonts.googleSansFlexTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(brightness: Brightness.light, textTheme: textTheme),
      darkTheme: ThemeData(brightness: Brightness.dark, textTheme: textTheme),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignedIn = false;

  /// Call whenever you know who the user is — at sign-in, or at startup if
  /// you already have them. Every field is optional; with none of them the
  /// user is anonymous but still keeps a stable identity, so votes persist.
  void _signIn() {
    UserOrient.identify(
      id: '123123',
      name: 'Kamran Bekirov',
      email: 'kamran@userorient.com',
      phoneNumber: '+994501234567',
      isPaying: true,
      extra: {'plan': 'pro', 'seats': 4},
    );

    setState(() => _isSignedIn = true);
  }

  /// Drops the cached user so the next person does not inherit their votes.
  Future<void> _signOut() async {
    await UserOrient.logout();

    if (mounted) setState(() => _isSignedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isSignedIn ? 'Signed in as Kamran' : 'Anonymous',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // The only entry point. The suggestion form is reached from
            // inside the board, so people see what exists before duplicating.
            FilledButton.tonalIcon(
              icon: const Icon(Icons.feedback_outlined),
              label: const Text('Open board'),
              onPressed: () => UserOrient.openBoard(context),
            ),
            const SizedBox(height: 8),
            if (_isSignedIn)
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.red.withValues(alpha: .1),
                ),
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Sign out'),
                onPressed: _signOut,
              )
            else
              FilledButton.tonalIcon(
                icon: const Icon(Icons.person_outline),
                label: const Text('Sign in'),
                onPressed: _signIn,
              ),
          ],
        ),
      ),
    );
  }
}
