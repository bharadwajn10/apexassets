import 'package:flutter/material.dart';
import 'models/user_progress.dart';
import 'features/home/home_screen.dart'; // Import the new home file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lead Logic: Initialize the shared state here
    final UserProgress globalProgress = UserProgress(
      budgetingLevel: 1,
      digitalFinanceLevel: 1,
      fraudAwarenessLevel: 1,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rokka Mestru',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      // Pass the state down to the home screen
      home: HomeScreen(globalProgress: globalProgress),
    );
  }
}