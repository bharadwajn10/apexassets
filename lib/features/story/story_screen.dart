import 'package:flutter/material.dart';
import '../../models/user_progress.dart';

class _StoryScenario {
  final int levelId;
  final String title;
  final String prompt;
  final double income;
  final double rent;
  final double minSavingsPercent;
  final double minEmergencyAmount;

  const _StoryScenario({
    required this.levelId,
    required this.title,
    required this.prompt,
    required this.income,
    required this.rent,
    required this.minSavingsPercent,
    required this.minEmergencyAmount,
  });
}

const List<_StoryScenario> _storyScenarios = [
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
    prompt: 'You have an EMI + bills. Don’t zero out emergency funds, and keep saving consistently.',
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
    prompt: 'Utility bills spiked. Cover essentials but don’t skip emergency funding.',
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

  Map<String, double> jars = {
    "Savings": 0,
    "Emergency Fund": 0,
    "Household": 0,
  };

  @override
  void initState() {
    super.initState();
    _scenario = _storyScenarios.firstWhere(
      (s) => s.levelId == widget.levelId,
      orElse: () => _storyScenarios.first,
    );
    totalIncome = _scenario.income;
    rentFixed = _scenario.rent;
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF334155), Color(0xFF0F172A)],
                  ),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFFE5E7EB),
                  size: 50,
                ),
              ),
              const SizedBox(width: 20),

              // Speech Bubble
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1220),
                    borderRadius: BorderRadius.circular(15),
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
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMoneyBundle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Draggable<String>(
        data: 'money',
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                      "Dragging",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${remainingToAllot.toInt()}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade400],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey, width: 2, style: BorderStyle.solid),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.grey.shade600,
                size: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Money Bundle",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Available: ₹${remainingToAllot.toInt()}",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        child: Container(
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
                    "Money Bundle",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Available: ₹${remainingToAllot.toInt()}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
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
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rent Jar (Fixed)
                  _buildCounterJar("Rent", rentFixed, const Color(0xFF6B7280), isFixed: true),
                  
                  // Interactive Jars
                  _buildCounterJar("Savings", jars["Savings"]!, const Color(0xFF60A5FA), isFixed: false),
                  _buildCounterJar("Emergency", jars["Emergency Fund"]!, const Color(0xFFF59E0B), isFixed: false),
                  _buildCounterJar("Household", jars["Household"]!, const Color(0xFF34D399), isFixed: false),
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
  
  Widget _buildCounterJar(String name, double amount, Color color, {required bool isFixed}) {
    return DragTarget<String>(
      onWillAccept: (data) => data == 'money' && !isFixed,
      onAccept: (data) => _handleDrop(name == "Emergency" ? "Emergency Fund" : name),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        
        return Column(
          children: [
            // Jar
            Container(
              width: 70,
              height: 90,
              decoration: BoxDecoration(
                color: isFixed ? Colors.grey.shade400 : color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: isHovered && !isFixed
                    ? Border.all(color: color, width: 3)
                    : null,
                boxShadow: isHovered && !isFixed
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  // Jar Lid
                  Container(
                    width: 80,
                    height: 15,
                    decoration: BoxDecoration(
                      color: isFixed ? Colors.grey.shade600 : _getDarkerColor(color),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                  
                  // Jar Body
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFixed ? Icons.lock : Icons.savings,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "₹${amount.toInt()}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Jar Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1220),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isFixed ? const Color(0xFF9CA3AF) : const Color(0xFFE5E7EB),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}