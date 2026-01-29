import 'package:flutter/material.dart';
import '../../models/user_progress.dart';

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
  
  final double totalIncome = 30000;
  final double rentFixed = 12000;
  
  Map<String, double> jars = {
    "Savings": 0,
    "Emergency Fund": 0,
    "Household": 0,
  };
  
  @override
  void initState() {
    super.initState();
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
    // Create a darker version of the color
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

    if (savings < 3000) {
      advice = "You're living a bit dangerously! Try to save at least 10% (₹3,000) for your future goals.";
    } else if (emergency == 0) {
      advice = "What if the fridge breaks or someone gets sick? Always put a little in the Emergency Fund first.";
    } else {
      advice = "Excellent planning! You've balanced your present needs with your future security.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Smart Advisor Response"),
        content: Text(advice),
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.userProgress.budgetingLevel += 1; // Level Up!
              Navigator.pop(context); // Close Dialog
              Navigator.pop(context, true); // Return to Map
            },
            child: const Text("Complete Level"),
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
            colors: [Color(0xFFFFF0F5), Color(0xFFE6F3FF)],
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
                        icon: const Icon(Icons.arrow_back, color: Colors.pink),
                      ),
                      Text(
                        "Level ${widget.levelId}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
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
                    colors: [Colors.pink, Colors.purple],
                  ),
                ),
                child: const Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(width: 20),
              
              // Speech Bubble
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hi! I earned ₹30,000 this month.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Help me plan my budget! Drag the money to the jars.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
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
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Left to Allot:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            "₹${remainingToAllot.toInt()}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
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
                  Colors.brown.shade300,
                  Colors.brown.shade500,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rent Jar (Fixed)
                  _buildCounterJar("Rent", rentFixed, Colors.grey, isFixed: true),
                  
                  // Interactive Jars
                  _buildCounterJar("Savings", jars["Savings"]!, Colors.blue, isFixed: false),
                  _buildCounterJar("Emergency", jars["Emergency Fund"]!, Colors.red, isFixed: false),
                  _buildCounterJar("Household", jars["Household"]!, Colors.green, isFixed: false),
                ],
              ),
            ),
          ),
          
          // Counter Front
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.brown.shade600,
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
                color: Colors.white,
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
                  color: isFixed ? Colors.grey : color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}