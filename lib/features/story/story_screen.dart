import 'package:flutter/material.dart';
import '../../models/user_progress.dart';

class StoryScreen extends StatefulWidget {
  final UserProgress userProgress;
  final int levelId;
  const StoryScreen({super.key, required this.userProgress, this.levelId = 1});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final double totalIncome = 30000;
  final double rentFixed = 12000;
  
  Map<String, double> jars = {
    "Savings": 0,
    "Emergency Fund": 0,
    "Household": 0,
  };

  double get remainingToAllot => totalIncome - rentFixed - jars.values.fold(0, (a, b) => a + b);

  void _showAmountDialog(String jarName) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Allot to $jarName"),
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
            child: const Text("Confirm"),
          ),
        ],
      ),
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
      appBar: AppBar(title: const Text("Rokka Mestru: Budgeting"), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Character Card
            _buildCharacterCard(),
            const SizedBox(height: 20),
            
            // Income Summary
            _buildIncomeSummary(),
            const SizedBox(height: 20),

            // Fixed Cost Jar (Rent)
            _buildJarTile("Rent (Fixed)", rentFixed, Colors.grey, isFixed: true),

            // Interactive Jars
            ...jars.keys.map((name) => _buildJarTile(name, jars[name]!, Colors.teal, isFixed: false)),

            const SizedBox(height: 30),
            
            if (remainingToAllot == 0)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
                onPressed: _showFinalAdvice,
                child: const Text("See Planning Feedback", style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(15)),
      child: const Row(
        children: [
          CircleAvatar(radius: 30, child: Icon(Icons.person)),
          SizedBox(width: 15),
          Expanded(child: Text("I earned ₹30,000 this month. Help me plan so I don't run out of money!", style: TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildIncomeSummary() {
    return Card(
      color: Colors.teal.shade700,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Left to Allot:", style: TextStyle(color: Colors.white, fontSize: 18)),
            Text("₹${remainingToAllot.toInt()}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildJarTile(String name, double amount, Color color, {required bool isFixed}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(isFixed ? Icons.lock : Icons.account_balance_wallet, color: color),
        title: Text(name),
        subtitle: Text("₹${amount.toInt()}"),
        trailing: isFixed 
            ? null 
            : IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal),
                onPressed: () => _showAmountDialog(name),
              ),
      ),
    );
  }
}