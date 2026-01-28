import 'package:flutter/material.dart';
import '../../models/user_progress.dart';

class StoryScreen extends StatefulWidget {
  final UserProgress userProgress;
  final int levelId;

  const StoryScreen({
    super.key,
    required this.userProgress,
    this.levelId = 1,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentScenarioIndex = 0;
  String? consequenceMessage;

  // The "Dictionary" of scenarios based on the Woman Track (Budget, Fraud, UPI)
  final List<Scenario> scenarios = [
    Scenario(
      title: "The First Paycheck",
      description: "You just received your first paycheck of ₹25,000. Your friend invites you to an expensive dinner that costs ₹3,000. What do you do?",
      choices: [
        Choice(
          text: "Go to dinner, you deserve it!",
          consequence: "You had fun, but your savings took a hit. Budgeting skills need work.",
          field: 'budgetingLevel',
          change: -1,
        ),
        Choice(
          text: "Suggest a cheaper alternative",
          consequence: "Smart choice! You enjoyed time with friends while staying on budget.",
          field: 'budgetingLevel',
          change: 1,
        ),
      ],
    ),
    Scenario(
      title: "The Suspicious Link",
      description: "You receive an SMS saying you've won ₹50,000 in a lottery. It asks you to click a link and enter your bank details. What do you do?",
      choices: [
        Choice(
          text: "Click the link - free money!",
          consequence: "This was a phishing scam! Never share bank details via unknown links.",
          field: 'fraudAwarenessLevel',
          change: -1,
        ),
        Choice(
          text: "Ignore and delete the message",
          consequence: "Excellent! You recognized a classic phishing attempt.",
          field: 'fraudAwarenessLevel',
          change: 1,
        ),
      ],
    ),
    Scenario(
      title: "The UPI QR Code",
      description: "A vendor asks you to scan a QR code to 'receive' a cashback of ₹500. It asks for your UPI PIN. What do you do?",
      choices: [
        Choice(
          text: "Enter PIN to receive the money",
          consequence: "Wait! You only enter your PIN to SEND money, never to receive it. You lost ₹500.",
          field: 'digitalFinanceLevel',
          change: -1,
        ),
        Choice(
          text: "Refuse and report the vendor",
          consequence: "Perfect! You understand that receiving money never requires a PIN.",
          field: 'digitalFinanceLevel',
          change: 2,
        ),
      ],
    ),
  ];

  void makeChoice(Choice choice) {
    setState(() {
      // Logic strictly follows the field names in your UserProgress model
      switch (choice.field) {
        case 'budgetingLevel':
          widget.userProgress.budgetingLevel += choice.change;
          break;
        case 'digitalFinanceLevel':
          widget.userProgress.digitalFinanceLevel += choice.change;
          break;
        case 'fraudAwarenessLevel':
          widget.userProgress.fraudAwarenessLevel += choice.change;
          break;
      }
      consequenceMessage = choice.consequence;
    });
  }

  void handleNavigation() {
    if (currentScenarioIndex < scenarios.length - 1) {
      setState(() {
        currentScenarioIndex++;
        consequenceMessage = null;
      });
    } else {
      // Level complete: Pop back to the Level Map
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Level Complete! Progress Saved to Profile."),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scenario = scenarios[currentScenarioIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.levelId}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress visual
              LinearProgressIndicator(
                value: (currentScenarioIndex + 1) / scenarios.length,
                backgroundColor: Colors.grey.shade200,
                color: Colors.teal,
              ),
              const SizedBox(height: 24),
              Text(
                scenario.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                scenario.description,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              
              // Decisions
              if (consequenceMessage == null)
                ...scenario.choices.map((choice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () => makeChoice(choice),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.teal.shade50,
                          side: const BorderSide(color: Colors.teal),
                        ),
                        child: Text(
                          choice.text,
                          style: const TextStyle(fontSize: 16, color: Colors.teal),
                        ),
                      ),
                    ))
              
              // Consequence and Next Action
              else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        consequenceMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: handleNavigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    currentScenarioIndex < scenarios.length - 1
                        ? "CONTINUE"
                        : "FINISH LEVEL",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Data structures kept at bottom for readability
class Scenario {
  final String title;
  final String description;
  final List<Choice> choices;
  Scenario({required this.title, required this.description, required this.choices});
}

class Choice {
  final String text;
  final String consequence;
  final String field;
  final int change;
  Choice({required this.text, required this.consequence, required this.field, required this.change});
}