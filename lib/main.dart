import 'package:flutter/material.dart';
import 'package:varun_hbd/widgets/bgm.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundMusic().init();
  runApp(VarunBirthdayApp());
}

class VarunBirthdayApp extends StatelessWidget {
  const VarunBirthdayApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Varun's Birthday",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
      ),
      home: const SplashScreen(),
    );
  }
}