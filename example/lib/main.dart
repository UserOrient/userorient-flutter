import 'package:flutter/material.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.configure(
    user: const User(
      uniqueIdentifier: '123456',
      fullName: 'Nelson',
      email: 'nelson@bighetti.cc',
      phoneNumber: '+234 123 456 7890',
      language: 'en',
      extra: {
        'is_premium': true,
        'subscription_date': '2021-09-01',
      },
    ),
    apiKey: 'a679c29a-671a-4297-8cd8-5297a02527ae',
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
            FilledButton.tonal(
              child: const Text(
                'Open Features Board',
              ),
              onPressed: () {
                UserOrient.openBoard(context);
              },
            ),
            const SizedBox(height: 8.0),
            FilledButton.tonal(
              child: const Text(
                'Open Feedback Form',
              ),
              onPressed: () {
                UserOrient.openForm(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
