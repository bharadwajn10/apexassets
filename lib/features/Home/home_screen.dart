import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/story'),
              child: const Text('Story Mode'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/budget'),
              child: const Text('Budgeting'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
