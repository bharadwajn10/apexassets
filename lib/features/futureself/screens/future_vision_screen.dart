import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/future_self_provider.dart';

class FutureVisionScreen extends StatelessWidget {
  const FutureVisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final future = context.watch<FutureSelfProvider>();

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFE5E7EB)),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Your Future Self",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _AvatarHeader(
                    name: future.avatar?.name ?? "Future You",
                    accentColor: future.avatar?.accentColor ?? const Color(0xFF3B82F6),
                    skinTone: future.avatar?.skinTone ?? const Color(0xFFD9A784),
                    outfit: future.avatar?.outfit ?? "Casual",
                    glasses: future.avatar?.glasses ?? false,
                  ),
                  const SizedBox(height: 16),
                  _PrimaryButton(
                    label: future.avatar == null ? "Create Avatar" : "Update Avatar",
                    color: future.avatar?.accentColor ?? const Color(0xFF3B82F6),
                    onTap: () => Navigator.pushNamed(context, "/avatar"),
                  ),
                  const SizedBox(height: 20),
                  const TabBar(
                    indicatorColor: Color(0xFFE5E7EB),
                    labelColor: Color(0xFFE5E7EB),
                    unselectedLabelColor: Color(0xFF9CA3AF),
                    tabs: [
                      Tab(text: "Life Stats", icon: Icon(Icons.auto_graph)),
                      Tab(text: "Career", icon: Icon(Icons.timeline)),
                      Tab(text: "Identity", icon: Icon(Icons.person_outline)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 420,
                    child: TabBarView(
                      children: [
                        _LifeStatsTab(future: future),
                        _CareerTab(future: future),
                        _IdentityTab(future: future),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    title: "Letter From Future You",
                    subtitle: "A message shaped by your choices",
                    child: Text(
                      future.futureLetter,
                      style: const TextStyle(
                        color: Color(0xFFE5E7EB),
                        fontSize: 14,
                        height: 1.5,
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

class _AvatarHeader extends StatelessWidget {
  final String name;
  final Color accentColor;
  final Color skinTone;
  final String outfit;
  final bool glasses;

  const _AvatarHeader({
    required this.name,
    required this.accentColor,
    required this.skinTone,
    required this.outfit,
    required this.glasses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: accentColor.withOpacity(0.25),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: skinTone,
                child: Icon(
                  glasses ? Icons.remove_red_eye : Icons.face,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFE5E7EB),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Future outfit: $outfit",
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Future You",
              style: TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LifeStatsTab extends StatelessWidget {
  final FutureSelfProvider future;
  const _LifeStatsTab({required this.future});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatBar(
          label: "Wealth Stability",
          value: future.wealthStability,
          color: const Color(0xFF22C55E),
        ),
        _StatBar(
          label: "Stress Level",
          value: future.stressLevel,
          color: const Color(0xFFF97316),
        ),
        _StatBar(
          label: "Risk Awareness",
          value: future.riskAwareness,
          color: const Color(0xFF3B82F6),
        ),
        _StatBar(
          label: "Lifestyle Comfort",
          value: future.lifestyleComfort,
          color: const Color(0xFF0EA5A4),
        ),
      ],
    );
  }
}

class _CareerTab extends StatelessWidget {
  final FutureSelfProvider future;
  const _CareerTab({required this.future});

  @override
  Widget build(BuildContext context) {
    final stages = const [
      "Student",
      "Intern",
      "Employee",
      "Entrepreneur",
      "Investor",
    ];
    return Column(
      children: stages.map((stage) {
        final isActive = stage == future.careerStage;
        return _TimelineStep(
          label: stage,
          isActive: isActive,
        );
      }).toList(),
    );
  }
}

class _IdentityTab extends StatelessWidget {
  final FutureSelfProvider future;
  const _IdentityTab({required this.future});

  @override
  Widget build(BuildContext context) {
    final traits = [
      future.identityLabel,
      future.riskAwareness >= 0.6 ? "Fraud Aware" : "Needs Shield",
      future.wealthStability >= 0.6 ? "Consistent" : "Volatile",
      future.stressLevel <= 0.4 ? "Calm" : "Restless",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Financial Identity",
          style: TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: traits.map((label) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          title: "Persona Summary",
          subtitle: "Earned, not chosen",
          child: Text(
            "You are a ${future.identityLabel} with ${future.riskAwareness >= 0.6 ? "strong" : "growing"} awareness. Keep pushing.",
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TimelineStep({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1F2937) : const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF3B82F6) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF6B7280),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFE5E7EB) : const Color(0xFF9CA3AF),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "${(value * 100).toInt()}%",
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: const Color(0xFF374151),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.95), color.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
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
        borderRadius: BorderRadius.circular(18),
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
              color: Color(0xFFE5E7EB),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
