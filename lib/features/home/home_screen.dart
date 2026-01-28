import 'package:flutter/material.dart';
import '../../models/user_progress.dart';
import '../story/level_map_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProgress globalProgress;
  const HomeScreen({super.key, required this.globalProgress});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rokka Mestru"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Namaste!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Step into your financial journey."),
            const SizedBox(height: 30),
            _MenuButton(
              title: "Story Mode",
              subtitle: "Learn through real-life choices",
              icon: Icons.map,
              color: Colors.orange.shade700,
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => LevelMapScreen(userProgress: widget.globalProgress))
              ),
            ),
            // ... (Keep the Future Vision and Profile _MenuButtons here)
          ],
        ),
      ),
    );
  }
}

// Move your _MenuButton, ProfileScreen, and _StatBar classes here too!