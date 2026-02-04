import 'package:flutter/material.dart';
import 'dart:ui' as ui;
// import 'dart:math' as flutter_math; // Unused
import '../../models/user_progress.dart';

// --- Shake Animation Widget ---
// --- Shake Animation Widget ---
// Removed unused ShakeWidget and SimpleShakeWidget implementations. 
// Using ShakeItem below.

class ShakeItem extends StatefulWidget {
  final Widget child;
  const ShakeItem({super.key, required this.child});
  
  @override
  ShakeItemState createState() => ShakeItemState();
}

class ShakeItemState extends State<ShakeItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }
  
  void shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

class _StoryScenario {
  final int levelId;
  final String title;
  final String prompt;
  final double income;
  final double rent;
  final double minSavingsPercent;
  final double minEmergencyAmount;
  final List<String> jarNames;

  _StoryScenario({
    required this.levelId,
    required this.title,
    required this.prompt,
    required this.income,
    required this.rent,
    required this.minSavingsPercent,
    required this.minEmergencyAmount,
    List<String>? jarNames,
  }) : jarNames = jarNames ?? const ["Savings", "Emergency Fund", "Household"];
}

final List<_StoryScenario> _storyScenarios = [
  // PHASE 1: BEGINNER LEVEL (Levels 1-20)
  // Active Scenarios (1-10)
  _StoryScenario(
    levelId: 1,
    title: 'First Paycheck Budget',
    prompt: 'You just got your first salary. Cover essentials, build a safety net, and start saving.',
    income: 30000,
    rent: 12000,
    minSavingsPercent: 0.10,
    minEmergencyAmount: 500,
  ),
  _StoryScenario(
    levelId: 2,
    title: 'Unexpected Medical Expense',
    prompt: 'You had a minor medical bill last month. Prioritize emergency funds while still saving something.',
    income: 32000,
    rent: 13000,
    minSavingsPercent: 0.08,
    minEmergencyAmount: 2000,
  ),
  _StoryScenario(
    levelId: 3,
    title: 'EMI Month',
    prompt: 'You have an EMI + bills. Do not zero out emergency funds, and keep saving consistently.',
    income: 35000,
    rent: 15000,
    minSavingsPercent: 0.10,
    minEmergencyAmount: 1500,
  ),
  _StoryScenario(
    levelId: 4,
    title: 'Family Function',
    prompt: 'There is a family function coming up. Plan household spending without sacrificing savings discipline.',
    income: 38000,
    rent: 16000,
    minSavingsPercent: 0.12,
    minEmergencyAmount: 2000,
  ),
  _StoryScenario(
    levelId: 5,
    title: 'Goal: New Phone',
    prompt: 'You want a new phone. Save meaningfully but keep emergency money intact.',
    income: 42000,
    rent: 17000,
    minSavingsPercent: 0.15,
    minEmergencyAmount: 2500,
  ),
  _StoryScenario(
    levelId: 6,
    title: 'Job Switch Buffer',
    prompt: 'You might switch jobs. Build a stronger emergency buffer while continuing savings.',
    income: 45000,
    rent: 18000,
    minSavingsPercent: 0.12,
    minEmergencyAmount: 5000,
  ),
  _StoryScenario(
    levelId: 7,
    title: 'Supporting Parents',
    prompt: 'You need to support parents this month. Balance household needs with emergency + savings.',
    income: 40000,
    rent: 15000,
    minSavingsPercent: 0.10,
    minEmergencyAmount: 3000,
  ),
  _StoryScenario(
    levelId: 8,
    title: 'High Utility Bills',
    prompt: 'Utility bills spiked. Cover essentials but do not skip emergency funding.',
    income: 36000,
    rent: 14000,
    minSavingsPercent: 0.08,
    minEmergencyAmount: 2000,
  ),
  _StoryScenario(
    levelId: 9,
    title: 'Savings Challenge',
    prompt: 'Try to hit a strong savings target while keeping emergency money healthy.',
    income: 50000,
    rent: 20000,
    minSavingsPercent: 0.20,
    minEmergencyAmount: 5000,
  ),
  _StoryScenario(
    levelId: 10,
    title: 'Financial Stability',
    prompt: 'Demonstrate a stable plan: save, fund emergency, and allocate the rest thoughtfully.',
    income: 55000,
    rent: 22000,
    minSavingsPercent: 0.18,
    minEmergencyAmount: 7000,
  ),
  
  // Placeholder Scenarios (11-20)
  _StoryScenario(levelId: 11, title: 'Budget Practice 11', prompt: 'Continue building your budgeting skills.', income: 48000, rent: 19000, minSavingsPercent: 0.12, minEmergencyAmount: 4000),
  _StoryScenario(levelId: 12, title: 'Budget Practice 12', prompt: 'Keep refining your financial planning.', income: 49000, rent: 19500, minSavingsPercent: 0.13, minEmergencyAmount: 4500),
  _StoryScenario(levelId: 13, title: 'Budget Practice 13', prompt: 'Master the basics of money management.', income: 50000, rent: 20000, minSavingsPercent: 0.14, minEmergencyAmount: 5000),
  _StoryScenario(levelId: 14, title: 'Budget Practice 14', prompt: 'Balance your financial priorities wisely.', income: 51000, rent: 20500, minSavingsPercent: 0.14, minEmergencyAmount: 5500),
  _StoryScenario(levelId: 15, title: 'Budget Practice 15', prompt: 'Strengthen your emergency fund strategy.', income: 52000, rent: 21000, minSavingsPercent: 0.15, minEmergencyAmount: 6000),
  _StoryScenario(levelId: 16, title: 'Budget Practice 16', prompt: 'Optimize your savings allocation.', income: 53000, rent: 21500, minSavingsPercent: 0.15, minEmergencyAmount: 6500),
  _StoryScenario(levelId: 17, title: 'Budget Practice 17', prompt: 'Prepare for advanced financial scenarios.', income: 54000, rent: 22000, minSavingsPercent: 0.16, minEmergencyAmount: 7000),
  _StoryScenario(levelId: 18, title: 'Budget Practice 18', prompt: 'Fine-tune your budgeting approach.', income: 55000, rent: 22500, minSavingsPercent: 0.16, minEmergencyAmount: 7500),
  _StoryScenario(levelId: 19, title: 'Budget Practice 19', prompt: 'Almost ready for advanced challenges!', income: 56000, rent: 23000, minSavingsPercent: 0.17, minEmergencyAmount: 8000),
  _StoryScenario(levelId: 20, title: 'Phase 1 Finale', prompt: 'Complete this level to unlock Advanced challenges!', income: 58000, rent: 24000, minSavingsPercent: 0.18, minEmergencyAmount: 8500),
  
  // PHASE 2: ADVANCED LEVEL (Levels 21-40)
  // Active Scenarios (21-30) - Complex with 5+ jars
  _StoryScenario(
    levelId: 21,
    title: 'Investment Journey Begins',
    prompt: 'Start investing while managing debt. Allocate wisely across all financial priorities.',
    income: 65000,
    rent: 25000,
    minSavingsPercent: 0.15,
    minEmergencyAmount: 10000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"],
  ),
  _StoryScenario(
    levelId: 22,
    title: 'Debt Snowball Strategy',
    prompt: 'Pay down high-interest debt aggressively while maintaining emergency funds.',
    income: 68000,
    rent: 26000,
    minSavingsPercent: 0.12,
    minEmergencyAmount: 12000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"],
  ),
  _StoryScenario(
    levelId: 23,
    title: 'Inflation Protection',
    prompt: 'Prices are rising. Increase emergency buffer and invest to beat inflation.',
    income: 70000,
    rent: 28000,
    minSavingsPercent: 0.18,
    minEmergencyAmount: 15000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"],
  ),
  _StoryScenario(
    levelId: 24,
    title: 'Retirement Planning Start',
    prompt: 'Begin long-term retirement savings while managing current obligations.',
    income: 75000,
    rent: 30000,
    minSavingsPercent: 0.20,
    minEmergencyAmount: 18000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  _StoryScenario(
    levelId: 25,
    title: 'Multiple Financial Goals',
    prompt: 'Balance short-term needs with long-term wealth building.',
    income: 80000,
    rent: 32000,
    minSavingsPercent: 0.18,
    minEmergencyAmount: 20000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  _StoryScenario(
    levelId: 26,
    title: 'High Income, High Responsibility',
    prompt: 'With higher income comes greater planning complexity. Optimize every rupee.',
    income: 85000,
    rent: 34000,
    minSavingsPercent: 0.20,
    minEmergencyAmount: 22000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  _StoryScenario(
    levelId: 27,
    title: 'Tax Planning Integration',
    prompt: 'Maximize tax-saving investments while meeting all financial targets.',
    income: 90000,
    rent: 36000,
    minSavingsPercent: 0.22,
    minEmergencyAmount: 25000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  _StoryScenario(
    levelId: 28,
    title: 'Wealth Accumulation Phase',
    prompt: 'Focus on building substantial wealth across multiple asset classes.',
    income: 95000,
    rent: 38000,
    minSavingsPercent: 0.25,
    minEmergencyAmount: 28000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  _StoryScenario(
    levelId: 29,
    title: 'Financial Independence Path',
    prompt: 'You are on the path to financial freedom. Make every allocation count.',
    income: 98000,
    rent: 39000,
    minSavingsPercent: 0.28,
    minEmergencyAmount: 30000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  _StoryScenario(
    levelId: 30,
    title: 'Master Budgeter',
    prompt: 'Demonstrate mastery of complex financial planning with multiple priorities.',
    income: 100000,
    rent: 40000,
    minSavingsPercent: 0.30,
    minEmergencyAmount: 35000,
    jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"],
  ),
  
  // Placeholder Scenarios (31-40)
  _StoryScenario(levelId: 31, title: 'Advanced Practice 31', prompt: 'Continue mastering advanced budgeting.', income: 102000, rent: 41000, minSavingsPercent: 0.25, minEmergencyAmount: 32000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 32, title: 'Advanced Practice 32', prompt: 'Refine your wealth-building strategy.', income: 104000, rent: 42000, minSavingsPercent: 0.26, minEmergencyAmount: 33000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 33, title: 'Advanced Practice 33', prompt: 'Optimize complex financial scenarios.', income: 106000, rent: 43000, minSavingsPercent: 0.27, minEmergencyAmount: 34000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 34, title: 'Advanced Practice 34', prompt: 'Balance multiple investment priorities.', income: 108000, rent: 44000, minSavingsPercent: 0.28, minEmergencyAmount: 35000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 35, title: 'Advanced Practice 35', prompt: 'Strengthen your financial foundation.', income: 110000, rent: 45000, minSavingsPercent: 0.29, minEmergencyAmount: 36000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 36, title: 'Advanced Practice 36', prompt: 'Maximize wealth accumulation potential.', income: 112000, rent: 46000, minSavingsPercent: 0.30, minEmergencyAmount: 37000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 37, title: 'Advanced Practice 37', prompt: 'Approach financial mastery.', income: 114000, rent: 47000, minSavingsPercent: 0.31, minEmergencyAmount: 38000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 38, title: 'Advanced Practice 38', prompt: 'Nearly at the peak of financial planning.', income: 116000, rent: 48000, minSavingsPercent: 0.32, minEmergencyAmount: 39000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 39, title: 'Advanced Practice 39', prompt: 'One step away from ultimate mastery!', income: 118000, rent: 49000, minSavingsPercent: 0.33, minEmergencyAmount: 40000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment"]),
  _StoryScenario(levelId: 40, title: 'Ultimate Financial Master', prompt: 'Congratulations! Prove your complete mastery of financial planning.', income: 120000, rent: 50000, minSavingsPercent: 0.35, minEmergencyAmount: 45000, jarNames: ["Savings", "Emergency Fund", "Household", "Investment", "Debt Payment", "Retirement"]),
];


class StoryScreen extends StatefulWidget {
  final UserProgress userProgress;
  final int levelId;
  const StoryScreen({super.key, required this.userProgress, this.levelId = 1});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> with TickerProviderStateMixin {
  late AnimationController _characterController;
  late Animation<double> _characterAnimation;

  late final _StoryScenario _scenario;
  late final double totalIncome;
  late final double rentFixed;

  Map<String, double> jars = {};
  
  // Shake keys
  final Map<String, GlobalKey<ShakeItemState>> _shakeKeys = {};

  @override
  void initState() {
    super.initState();
    _scenario = _storyScenarios.firstWhere(
      (s) => s.levelId == widget.levelId,
      orElse: () => _storyScenarios.first,
    );
    totalIncome = _scenario.income;
    rentFixed = _scenario.rent;
    
    // Initialize jars dynamically based on scenario
    for (String jarName in _scenario.jarNames) {
      jars[jarName] = 0;
      _shakeKeys[jarName] = GlobalKey<ShakeItemState>();
    }
    
    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _characterAnimation = CurvedAnimation(
      parent: _characterController,
      curve: Curves.easeInOut,
    );
    _characterController.repeat(reverse: true);
  }


  @override
  void dispose() {
    _characterController.dispose();
    super.dispose();
  }

  double get remainingToAllot => totalIncome - rentFixed - jars.values.fold(0, (a, b) => a + b);

  bool get _isBestDecision {
    final double savings = jars["Savings"] ?? 0;
    final double emergency = jars["Emergency Fund"] ?? 0;
    final double minSavingsAmount = totalIncome * _scenario.minSavingsPercent;
    return remainingToAllot == 0 && savings >= minSavingsAmount && emergency >= _scenario.minEmergencyAmount;
  }

  void _resetAllocations() {
    setState(() {
      jars.updateAll((key, value) => 0);
    });
  }

  void _showAmountDialog(String jarName) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add to $jarName"),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter amount", prefixText: "₹"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(_controller.text) ?? 0;
              if (amount <= remainingToAllot) {
                setState(() => jars[jarName] = jars[jarName]! + amount);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Not enough money left!"))
                );
                // Trigger shake for this jar if possible, or general feedback
                // Since the dialog is open, we can't easily shake the jar behind it visibly.
                // But user requested "If the user violates a budget rule... make that specific Jar widget shake".
                // This usually happens after they try to submit.
                // We'll close dialog and shake.
                Navigator.pop(context);
                _shakeKeys[jarName]?.currentState?.shake();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _handleDrop(String jarName) {
    _showAmountDialog(jarName);
  }

  Color _getDarkerColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      (color.red * 0.7).round(),
      (color.green * 0.7).round(),
      (color.blue * 0.7).round(),
    );
  }

  void _showFinalAdvice() {
    String advice = "";
    double savings = jars["Savings"]!;
    double emergency = jars["Emergency Fund"]!;

    final double minSavingsAmount = totalIncome * _scenario.minSavingsPercent;

    if (savings < minSavingsAmount) {
      advice = "Savings target missed. Aim for at least ₹${minSavingsAmount.toInt()} this level.";
    } else if (emergency < _scenario.minEmergencyAmount) {
      advice = "Emergency fund is too low. Keep at least ₹${_scenario.minEmergencyAmount.toInt()} for safety.";
    } else {
      advice = "Excellent planning. You met the targets for savings and emergency funds.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Smart Advisor Response"),
        content: Text(advice),
        actions: _isBestDecision
            ? [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: const Text("Complete Level"),
                )
              ]
            : [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Try Again"),
                )
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF111827)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(), // Completely disable scroll physics
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFE5E7EB)),
                      ),
                      Text(
                        "Level ${widget.levelId}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Reset allocations',
                        onPressed: _resetAllocations,
                        icon: const Icon(Icons.restart_alt, color: Color(0xFFE5E7EB)),
                      ),
                    ],
                  ),
                ),

                // Animated Character
                _buildAnimatedCharacter(),

                // Money Bundle
                _buildMoneyBundle(),

                // Income Summary
                _buildIncomeSummary(),

                // Kitchen Counter with Jars
                _buildKitchenCounter(),

                // Complete Button
                if (remainingToAllot == 0)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _showFinalAdvice,
                      child: const Text(
                        "See Planning Feedback",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                const SizedBox(height: 50), // Extra padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCharacter() {
    return AnimatedBuilder(
      animation: _characterAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // Animated Character
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                     BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                     )
                  ]
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/guide_character.jpg',
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                    errorBuilder: (c, e, s) => Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF334155),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFFE5E7EB),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Speech Bubble
              Expanded(
                child: CustomPaint(
                   painter: BubbleTailPainter(color: const Color(0xFF0B1220)),
                   child: Container(
                    margin: const EdgeInsets.only(left: 10), // Space for tail
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1220),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _scenario.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _scenario.prompt,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Income: ₹${totalIncome.toInt()}  |  Rent: ₹${rentFixed.toInt()}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMoneyBundle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Money Available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Tap jars below to allocate: ₹${remainingToAllot.toInt()}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildIncomeSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Left to Allot:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5E7EB),
            ),
          ),
          Text(
            "₹${remainingToAllot.toInt()}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF34D399),
            ),
          ),
        ],
      ),
    );
  }
  
  
  Widget _buildKitchenCounter() {
    // Define jar colors
    final Map<String, Color> jarColors = {
      "Savings": const Color(0xFF60A5FA),
      "Emergency Fund": const Color(0xFFF59E0B),
      "Household": const Color(0xFF34D399),
      "Investment": const Color(0xFF8B5CF6),
      "Debt Payment": const Color(0xFFEF4444),
      "Retirement": const Color(0xFF10B981),
    };
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Counter Top
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF111827),
                  Color(0xFF0B1220),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(), // Disable horizontal scroll physics
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rent Jar (Fixed)
                  _buildCounterJar("Rent", rentFixed, const Color(0xFF6B7280), isFixed: true),
                  const SizedBox(width: 10),
                  
                  // Interactive Jars - Dynamic based on scenario
                  ...jars.keys.map((jarName) {
                    final displayName = jarName.length > 10 ? jarName.substring(0, 10) : jarName;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildCounterJar(
                        displayName,
                        jars[jarName]!,
                        jarColors[jarName] ?? const Color(0xFF60A5FA),
                        isFixed: false,
                        fullName: jarName,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // Counter Front
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCounterJar(String name, double amount, Color color, {required bool isFixed, String? fullName}) {
    final jarName = fullName ?? name;
    
    return GestureDetector(
      onTap: isFixed ? null : () => _showAmountDialog(jarName),
      child: Column(
        children: [
          // Jar
          ShakeItem(
            key: _shakeKeys[jarName],
            child: Container(
              width: 70,
              height: 100, // Slightly taller
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                   // Glass Jar Body
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.1), // Glass tint
                       borderRadius: const BorderRadius.only(
                         topLeft: Radius.circular(10),
                         topRight: Radius.circular(10),
                         bottomLeft: Radius.circular(12),
                         bottomRight: Radius.circular(12),
                       ),
                       border: Border.all(
                         color: Colors.white.withOpacity(0.3),
                         width: 1.5,
                       ),
                     ),
                     child: ClipRRect(
                       borderRadius: const BorderRadius.only(
                         topLeft: Radius.circular(8),
                         topRight: Radius.circular(8),
                         bottomLeft: Radius.circular(10),
                         bottomRight: Radius.circular(10),
                       ),
                       child: Stack(
                         alignment: Alignment.bottomCenter,
                         children: [
                           // Backdrop Blur
                           BackdropFilter(
                             filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                             child: Container(color: Colors.transparent),
                           ),
                           
                           // Liquid Fill
                           LayoutBuilder(
                             builder: (ctx, constraints) {
                               double fillPercent = 0.0;
                               if (isFixed) {
                                 fillPercent = 0.8; // Fixed rent usually full-ish
                               } else {
                                  // Arbitrary visual cap at 15000 for visuals
                                  fillPercent = (amount / 15000).clamp(0.0, 1.0);
                               }
                               
                               return AnimatedContainer(
                                 duration: const Duration(milliseconds: 800),
                                 curve: Curves.easeOutQuart,
                                 height: constraints.maxHeight * fillPercent,
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                   color: color.withOpacity(0.8),
                                   borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                                 ),
                               );
                             },
                           ),
                           
                           // Icon & Text overlay
                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                                Icon(
                                  isFixed ? Icons.lock : Icons.savings,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(height: 5),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                   
                   // Lid
                   Positioned(
                     top: 0,
                     child: Container(
                        width: 76,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isFixed ? Colors.grey.shade700 : _getDarkerColor(color),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white30),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))
                          ]
                        ),
                     ),
                   ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            "₹${amount.toInt()}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  final Color color;
  BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Draw a triangle on the left side
    path.moveTo(0, 20);
    path.lineTo(-10, 30);
    path.lineTo(0, 40);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
