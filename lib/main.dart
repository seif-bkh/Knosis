import 'package:flutter/material.dart';

void main() {
  runApp(const KnosisApp());
}

class KnosisApp extends StatelessWidget {
  const KnosisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knosis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F8C87)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('From words to worlds.'),
      ),
    );
  }
}
