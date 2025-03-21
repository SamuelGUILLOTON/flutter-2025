import 'package:flutter/material.dart';
import 'package:quiz/welcome_screen.dart';
import 'package:quiz/question_screen.dart';
import 'package:quiz/score_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/Welcome',
      routes: {
        '/Welcome': (context) => const WelcomeScreen(),
        '/Quiz': (context) => const QuestionScreen(),
        '/Score': (context) => const ScoreScreen(),
      },
    );
  }
}