import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/avatar_model.dart';
import '../services/future_self_provider.dart';

class AvatarCreationScreen extends StatefulWidget {
  const AvatarCreationScreen({super.key});

  @override
  State<AvatarCreationScreen> createState() => _AvatarCreationScreenState();
}

class _AvatarCreationScreenState extends State<AvatarCreationScreen> {
  final nameController = TextEditingController();
  String gender = "Female";
  Color selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Your Avatar")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundColor: selectedColor),
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),

            DropdownButton<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: "Female", child: Text("Female")),
                DropdownMenuItem(value: "Male", child: Text("Male")),
              ],
              onChanged: (v) => setState(() => gender = v!),
            ),

            Wrap(
              spacing: 10,
              children: [
                Colors.blue,
                Colors.green,
                Colors.purple,
                Colors.orange,
              ].map((c) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = c),
                  child: CircleAvatar(backgroundColor: c, radius: 15),
                );
              }).toList(),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                context.read<FutureSelfProvider>().createAvatar(
                      AvatarModel(
                        name: nameController.text,
                        gender: gender,
                        color: selectedColor,
                      ),
                    );
                Navigator.pushReplacementNamed(context, '/future-vision');
              },
              child: const Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}
