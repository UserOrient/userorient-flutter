import 'package:flutter/material.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.configure(apiKey: 'YOUR_API_KEY', languageCode: 'en');

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
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text('Feature requests'),
              subtitle: const Text('View and vote on feature requests'),
              onTap: () {
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
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () {
                UserOrient.clearCache();
              },
            ),
          ],
        ),
      ),
    );
  }
}
