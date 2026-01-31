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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F172A),
              Color(0xFF111827),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B1220),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF000000),
                                blurRadius: 22,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.trending_up, color: Color(0xFFE5E7EB), size: 22),
                              SizedBox(width: 10),
                              Text(
                                "Rokka Mestru",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFE5E7EB),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Namaste!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                  const Text(
                    "Step into your financial journey.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  _MenuButton(
                    title: "Story Mode",
                    subtitle: "Learn through real-life choices",
                    icon: Icons.map,
                    color: const Color(0xFF0EA5A4),
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
                    color: const Color(0xFF3B82F6),
                    onTap: () {
                      // Future Implementation
                    },
                  ),
                  
                  _MenuButton(
                    title: "My Progress",
                    subtitle: "Badges & Certificates",
                    icon: Icons.emoji_events,
                    color: const Color(0xFF22C55E),
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
          ),
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1220),
                Color(0xFF0F172A),
                Color(0xFF111827),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFE5E7EB)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1220),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF000000),
                              blurRadius: 22,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.emoji_events, color: Color(0xFFE5E7EB), size: 22),
                            SizedBox(width: 10),
                            Text(
                              "My Achievements",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE5E7EB),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const TabBar(
                  indicatorColor: Color(0xFFE5E7EB),
                  labelColor: Color(0xFFE5E7EB),
                  unselectedLabelColor: Color(0xFF9CA3AF),
                  tabs: [
                    Tab(text: "Badges", icon: Icon(Icons.verified)),
                    Tab(text: "Skills", icon: Icon(Icons.analytics)),
                    Tab(text: "Awards", icon: Icon(Icons.card_membership)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildBadgeTab(),
                      _buildLevelTab(), 
                      _buildCertificateTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeTab() {
    // Determine locked status for demo purposes
    final bool hasBudgetBadge = userProgress.badges.contains("budget_master");
    final bool hasSavingsBadge = userProgress.badges.contains("savings_hero");
    final bool hasInvestmentBadge = userProgress.badges.contains("investor_pro");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildBadgeItem("Budget Master", "Complete 5 budget levels", hasBudgetBadge, Icons.monetization_on),
          const SizedBox(height: 15),
          _buildBadgeItem("Savings Hero", "Save ₹1 Lakh total", hasSavingsBadge, Icons.savings),
          const SizedBox(height: 15),
          _buildBadgeItem("Investor Pro", "Unlock Phase 2", hasInvestmentBadge, Icons.trending_up, isLocked: true), // Force locked for demo
          const SizedBox(height: 15),
          _buildBadgeItem("Debt Destroyer", "Pay off all debts", false, Icons.money_off, isLocked: true),
          const SizedBox(height: 15),
          _buildBadgeItem("Wealth Wizard", "Reach Level 40", false, Icons.diamond, isLocked: true),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String title, String criteria, bool isUnlocked, IconData icon, {bool isLocked = false}) {
    final locked = isLocked || !isUnlocked;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: locked ? Colors.grey.withOpacity(0.3) : const Color(0xFFFCD34D).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: locked ? Colors.black.withOpacity(0.5) : const Color(0xFFFCD34D).withOpacity(0.2),
            ),
            child: Icon(
              locked ? Icons.lock : icon,
              color: locked ? Colors.grey : const Color(0xFFFCD34D),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: locked ? Colors.grey : const Color(0xFFE5E7EB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  criteria,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          if (locked)
            const Icon(Icons.lock_outline, color: Colors.grey, size: 20)
          else
            const Icon(Icons.check_circle, color: Color(0xFFFCD34D), size: 24),
        ],
      ),
    );
  }

  Widget _buildLevelTab() {
    return RepaintBoundary(
      child: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            "Skill Mastery",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 20),
          _StatBar(label: "Budgeting Skills", currentLevel: userProgress.budgetingLevel, icon: Icons.account_balance_wallet, color: const Color(0xFF22C55E)),
          _StatBar(label: "Digital Finance", currentLevel: userProgress.digitalFinanceLevel, icon: Icons.qr_code_2, color: const Color(0xFF3B82F6)),
          _StatBar(label: "Fraud Awareness", currentLevel: userProgress.fraudAwarenessLevel, icon: Icons.shield, color: const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _buildCertificateTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_membership, size: 80, color: Color(0xFF9CA3AF)),
          SizedBox(height: 10),
          Text(
            "Reach max level to unlock your NCFE Certificate!",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.4, -0.6),
                      radius: 1.2,
                      colors: [
                        color.withOpacity(0.95),
                        color.withOpacity(0.75),
                        const Color(0xFF0B1220),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: const Color(0xFFE5E7EB), size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF9CA3AF),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE5E7EB),
                ),
              ),
              const Spacer(),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFF374151),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}