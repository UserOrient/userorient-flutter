import 'package:flutter/material.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.configure(
    apiKey: '41d77113-8c2c-42e0-a882-8e7bd8cceb29',
    languageCode: 'az',
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
                UserOrient.setUser(
                    // uniqueIdentifier: '123123',
                    // fullName: 'Kamran',
                    // phoneNumber: '+994501234567',
                    // email: 'kamran@userorient.com',
                    // language: 'az',
                    // extra: {
                    //   'is_premium': true,
                    //   'is_azerbaijani': true,
                    //   'online_session_count': 17,
                    //   'subscription_date': '2021-09-01',
                    // },
                    );

                UserOrient.openBoard(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text(
                'Logout',
              ),
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
