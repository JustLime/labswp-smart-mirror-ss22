import 'package:app/introduction_screen.dart';
import 'package:flutter/material.dart';

// Main controller class for running the app
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IntroductionScreen(),
    );
  }
}
