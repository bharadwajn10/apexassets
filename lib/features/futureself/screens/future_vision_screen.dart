import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/future_self_provider.dart';

class FutureVisionScreen extends StatelessWidget {
  const FutureVisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final future = context.watch<FutureSelfProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Your Future Self")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: future.avatar?.color,
                ),
                const SizedBox(width: 10),
                Text(
                  future.avatar?.name ?? "",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _bar("Budgeting", future.budgeting),
            _bar("Discipline", future.discipline),
            _bar("Consistency", future.consistency),

            const SizedBox(height: 30),

            Text(
              "Letter from Future You",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(future.futureLetter),
          ],
        ),
      ),
    );
  }

  Widget _bar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        LinearProgressIndicator(value: value),
        const SizedBox(height: 10),
      ],
    );
  }
}
