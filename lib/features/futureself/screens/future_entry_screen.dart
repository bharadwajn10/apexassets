import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_progress.dart';
import '../services/future_self_provider.dart';

class FutureEntryScreen extends StatefulWidget {
  final UserProgress progress;
  const FutureEntryScreen({super.key, required this.progress});

  @override
  State<FutureEntryScreen> createState() => _FutureEntryScreenState();
}

class _FutureEntryScreenState extends State<FutureEntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FutureSelfProvider>().syncFromProgress(widget.progress);
    });
  }

  @override
  Widget build(BuildContext context) {
    final future = context.watch<FutureSelfProvider>();

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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderPill(
                  icon: Icons.auto_graph,
                  title: "Future Vision",
                ),
                const SizedBox(height: 24),
                const Text(
                  "What if money had a face...",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE5E7EB),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Meet your future self and see how today's choices shape your life.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 24),
                _FeatureCard(
                  title: "Future Self Snapshot",
                  subtitle: "Live stats based on your journey",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatPill(
                        label: "Stability",
                        value: future.wealthStability,
                        color: const Color(0xFF22C55E),
                      ),
                      _StatPill(
                        label: "Stress",
                        value: future.stressLevel,
                        color: const Color(0xFFF97316),
                      ),
                      _StatPill(
                        label: "Awareness",
                        value: future.riskAwareness,
                        color: const Color(0xFF3B82F6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _FeatureCard(
                  title: "Daily Check-In",
                  subtitle: "30 seconds. One decision.",
                  child: Column(
                    children: [
                      const Text(
                        "Did you make a small smart money move today?",
                        style: TextStyle(
                          color: Color(0xFFE5E7EB),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              label: "I saved",
                              color: const Color(0xFF22C55E),
                              onTap: () => _checkIn(
                                context,
                                safeChoice: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionButton(
                              label: "I splurged",
                              color: const Color(0xFFEF4444),
                              onTap: () => _checkIn(
                                context,
                                safeChoice: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _ActionButton(
                  label: "Meet My Future Self",
                  color: const Color(0xFF3B82F6),
                  onTap: () {
                    Navigator.pushNamed(context, "/avatar");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkIn(BuildContext context, {required bool safeChoice}) {
    context.read<FutureSelfProvider>().applyDailyCheckIn(
          safeChoice: safeChoice,
        );

    final message = safeChoice
        ? "Future You smiles. Stability is rising."
        : "Future You looks concerned. Stress is rising.";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String title;

  const _HeaderPill({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFE5E7EB), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE5E7EB),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${(value * 100).toInt()}%",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.95), color.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE5E7EB),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
