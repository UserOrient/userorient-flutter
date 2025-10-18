import 'package:flutter/material.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.configure(apiKey: 'YOUR-API-KEY', languageCode: 'en');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonalIcon(
              icon: const Icon(Icons.feedback_outlined),
              label: const Text('Suggest features'),
              onPressed: () {
                UserOrient.setUser(
                  uniqueIdentifier: '123123',
                  fullName: 'Kamran Bekirov',
                  phoneNumber: '+994501234567',
                  email: 'kamran@userorient.com',
                  language: 'en',
                  extra: {'is_premium': true},
                );

                UserOrient.openBoard(context);
              },
            ),
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.withValues(alpha: .1),
              ),
              icon: const Icon(Icons.logout_outlined),
              label: const Text('Logout'),
              onPressed: () {
                UserOrient.clearCache();
              },
            ),
          ],
        ),
      ),
    );
  }
}
