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
            const Text(
              "Namaste!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text("Step into your financial journey."),
            const SizedBox(height: 30),
            
            _MenuButton(
              title: "Story Mode",
              subtitle: "Learn through real-life choices",
              icon: Icons.map,
              color: Colors.orange.shade700,
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => LevelMapScreen(userProgress: widget.globalProgress)
                )
              ),
            ),
            
            _MenuButton(
              title: "Future Vision",
              subtitle: "Talk to your future self",
              icon: Icons.auto_graph,
              color: Colors.purple.shade700,
              onTap: () {
                // Future Implementation
              },
            ),
            
            _MenuButton(
              title: "My Progress",
              subtitle: "Badges & Certificates",
              icon: Icons.emoji_events,
              color: Colors.blue.shade700,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userProgress: widget.globalProgress)
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

class ProfileScreen extends StatelessWidget {
  final UserProgress userProgress;
  const ProfileScreen({super.key, required this.userProgress});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
            _buildLevelTab(), 
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
        const Text("Skill Mastery", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _StatBar(label: "Budgeting Skills", currentLevel: userProgress.budgetingLevel, icon: Icons.account_balance_wallet, color: Colors.green),
        _StatBar(label: "Digital Finance", currentLevel: userProgress.digitalFinanceLevel, icon: Icons.qr_code_2, color: Colors.blue),
        _StatBar(label: "Fraud Awareness", currentLevel: userProgress.fraudAwarenessLevel, icon: Icons.shield, color: Colors.redAccent),
      ],
    );
  }

  Widget _buildCertificateTab() {
    return const Center(child: Text("Reach max level to unlock your NCFE Certificate!"));
  }
}

// --- HELPERS (UI COMPONENTS) ---

class _MenuButton extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        leading: CircleAvatar(backgroundColor: color, radius: 25, child: Icon(icon, color: Colors.white, size: 30)),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int currentLevel;
  final IconData icon;
  final Color color;

  const _StatBar({required this.label, required this.currentLevel, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
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
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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