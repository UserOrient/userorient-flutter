import 'package:flutter/material.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.clearCache();

  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
  );

  UserOrient.setUser(
    fullName: 'Nelson',
    email: 'nelson@bighetti.cc',
    language: 'en',
    extra: {
      'is_premium': true,
      'subscription_date': '2021-09-01',
    },
  );

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
              leading: const Icon(Icons.feedback),
              title: const Text(
                'Feature requests',
              ),
              subtitle: const Text(
                'View and vote on feature requests',
              ),
              onTap: () {
                UserOrient.openBoard(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
