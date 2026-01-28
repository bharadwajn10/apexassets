import 'package:flutter/material.dart';

// Ensure these paths match your folder structure exactly
import 'models/user_progress.dart'; 
import 'features/story/level_map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rokka Mestru',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Single source of truth for the woman-track session
  final UserProgress globalProgress = UserProgress(
    budgetingLevel: 1,
    digitalFinanceLevel: 1,
    fraudAwarenessLevel: 1,
  );

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
            const Text(
              "Namaste!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text("Step into your financial journey."),
            const SizedBox(height: 30),
            
            // 1. STORY MODE (The Level Map)
            _MenuButton(
              title: "Story Mode",
              subtitle: "Learn through real-life choices",
              icon: Icons.map,
              color: Colors.orange.shade700,
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => LevelMapScreen(userProgress: globalProgress)
                )
              ),
            ),
            
            // 2. FUTURE VISION (Saving/Talk to future self mode)
            _MenuButton(
              title: "Future Vision",
              subtitle: "Talk to your future self",
              icon: Icons.auto_graph,
              color: Colors.purple.shade700,
              onTap: () {
                // Future Implementation for Savings Simulator
              },
            ),
            
            // 3. PROFILE (Achievements & Badges)
            _MenuButton(
              title: "My Progress",
              subtitle: "Badges & Certificates",
              icon: Icons.emoji_events,
              color: Colors.blue.shade700,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userProgress: globalProgress)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PROFILE SCREEN WITH TABS ---

// --- PROFILE SCREEN WITH VISUAL BARS ---

class ProfileScreen extends StatelessWidget {
  final UserProgress userProgress;
  const ProfileScreen({super.key, required this.userProgress});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("My Achievements"),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Badges", icon: Icon(Icons.verified)),
              Tab(text: "Skills", icon: Icon(Icons.analytics)),
              Tab(text: "Awards", icon: Icon(Icons.card_membership)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBadgeTab(),
            _buildLevelTab(), // This now contains the progress bars
            _buildCertificateTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stars, size: 80, color: Colors.amber.shade400),
          const SizedBox(height: 10),
          Text("Badges unlocked: ${userProgress.badges.length}"),
          const Text("Complete more levels to earn more!"),
        ],
      ),
    );
  }

  Widget _buildLevelTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Skill Mastery",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // These use the specific fields from your dictionary
        _StatBar(
          label: "Budgeting Skills", 
          currentLevel: userProgress.budgetingLevel, 
          icon: Icons.account_balance_wallet,
          color: Colors.green,
        ),
        _StatBar(
          label: "Digital Finance", 
          currentLevel: userProgress.digitalFinanceLevel, 
          icon: Icons.qr_code_2,
          color: Colors.blue,
        ),
        _StatBar(
          label: "Fraud Awareness", 
          currentLevel: userProgress.fraudAwarenessLevel, 
          icon: Icons.shield,
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildCertificateTab() {
    return const Center(child: Text("Reach max level to unlock your NCFE Certificate!"));
  }
}

// --- NEW VISUAL PROGRESS BAR COMPONENT ---

class _StatBar extends StatelessWidget {
  final String label;
  final int currentLevel;
  final IconData icon;
  final Color color;

  const _StatBar({
    required this.label, 
    required this.currentLevel, 
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Assuming max level is 10 for the bar calculation
    double progress = (currentLevel / 10).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text("${(progress * 100).toInt()}%"),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
// --- HELPERS ---

class _MenuButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 25,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

