import 'package:flutter/material.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.configure(
    apiKey: 'e7979359-bd33-467e-8eba-19cba2079e90',
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
