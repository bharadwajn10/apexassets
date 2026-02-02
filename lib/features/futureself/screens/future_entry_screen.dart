import 'package:flutter/material.dart';

class FutureEntryScreen extends StatelessWidget {
  const FutureEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Future Vision")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/avatar');
          },
          child: const Text("Meet My Future Self"),
        ),
      ),
    );
  }
}
