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
  int currentScenarioIndex = 0;
  String? consequenceMessage;
  bool levelComplete = false;

  // Track points earned in THIS session for the summary card
  int sessionBudget = 0;
  int sessionFraud = 0;
  int sessionDigital = 0;

  final List<Scenario> scenarios = [
    Scenario(
      title: "The Market Choice",
      description: "You see a beautiful saree for ₹2,000, but you only budgeted ₹500 for clothes this month. What do you do?",
      characterImage: "assets/images/sunita_thinking.png", 
      choices: [
        Choice(text: "Buy it anyway", consequence: "It's beautiful, but now you have less for groceries.", field: 'budgetingLevel', change: -1),
        Choice(text: "Save for next month", consequence: "Great discipline! Your savings are growing.", field: 'budgetingLevel', change: 2),
      ],
    ),
    Scenario(
      title: "The UPI Request",
      description: "Someone sends you a 'Collect Request' on UPI to 'refund' your money. They ask for your PIN.",
      characterImage: "assets/images/sunita_confused.png",
      choices: [
        Choice(text: "Enter PIN", consequence: "Wait! You only enter PIN to SEND money. You lost ₹100.", field: 'fraudAwarenessLevel', change: -2),
        Choice(text: "Decline Request", consequence: "Smart! You spotted a common UPI scam.", field: 'fraudAwarenessLevel', change: 2),
      ],
    ),
  ];

  void makeChoice(Choice choice) {
    setState(() {
      if (choice.field == 'budgetingLevel') {
        widget.userProgress.budgetingLevel += choice.change;
        sessionBudget += choice.change;
      } else if (choice.field == 'fraudAwarenessLevel') {
        widget.userProgress.fraudAwarenessLevel += choice.change;
        sessionFraud += choice.change;
      }
      consequenceMessage = choice.consequence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.levelId}"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: levelComplete ? _buildSummaryCard() : _buildScenarioUI(),
      ),
    );
  }

  Widget _buildScenarioUI() {
    final scenario = scenarios[currentScenarioIndex];
    return Column(
      children: [
        // Character Image Placeholder
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.teal.withOpacity(0.3)),
          ),
          child: const Center(child: Icon(Icons.person, size: 80, color: Colors.teal)), 
          // Replace Icon with Image.asset(scenario.characterImage) when you have assets
        ),
        const SizedBox(height: 20),
        Text(scenario.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(scenario.description, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        if (consequenceMessage == null)
          ...scenario.choices.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () => makeChoice(c),
              child: Text(c.text),
            ),
          ))
        else ...[
          Text(consequenceMessage!, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (currentScenarioIndex < scenarios.length - 1) {
                setState(() { currentScenarioIndex++; consequenceMessage = null; });
              } else {
                setState(() { levelComplete = true; });
              }
            },
            child: const Text("Continue"),
          )
        ]
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
              const Text("Level Complete!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              const SizedBox(height: 10),
              _summaryRow("Budgeting Skill", sessionBudget),
              _summaryRow("Fraud Awareness", sessionFraud),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Return to Map"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, int val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(val >= 0 ? "+$val" : "$val", 
               style: TextStyle(color: val >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Data Classes
class Scenario {
  final String title, description, characterImage;
  final List<Choice> choices;
  Scenario({required this.title, required this.description, required this.characterImage, required this.choices});
}

class Choice {
  final String text, consequence, field;
  final int change;
  Choice({required this.text, required this.consequence, required this.field, required this.change});
}