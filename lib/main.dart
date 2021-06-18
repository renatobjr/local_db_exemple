import 'package:flutter/material.dart';
import 'package:local_db_exemple/screens/form_user.dart';
import 'package:local_db_exemple/screens/home.dart';
import 'package:local_db_exemple/screens/splash_screen.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      routes: {
        Home.route: (_) => const Home(),
        FormUser.route: (_) => FormUser()
      },
    );
  }
}
