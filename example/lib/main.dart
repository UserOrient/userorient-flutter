import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/views/board_view.dart';
import 'package:userorient_flutter/src/views/form_view.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  UserOrient.configure(
    apiKey: 'YOUR_API_KEY',
    languageCode: 'en',
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserOrient.setUser();
    }); // addPostFrameCallback is called after the build method is called, so we can initialize UserOrien
    super.initState();
  }

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
                'Features Screen',
              ),
              subtitle: const Text(
                'View and vote on feature requests in a new Screen',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoardView(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text(
                'Features Sheet',
              ),
              subtitle: const Text(
                'View and vote on feature requests in a bottom Sheet',
              ),
              onTap: () {
                UserOrient.openBoard(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text(
                'Feature request Screen',
              ),
              subtitle: const Text(
                'Request a new feature in new screen',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormView(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text(
                'Feature request  in a Sheet',
              ),
              subtitle: const Text(
                'Request a new feature in a bottom Sheet',
              ),
              onTap: () {
                UserOrient.openForm(context);
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
