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
  Color skinTone = const Color(0xFFD9A784);
  String hairStyle = "Wave";
  bool glasses = false;
  String outfit = "Casual";
  Color accentColor = const Color(0xFF3B82F6);

  final List<Color> skinTones = const [
    Color(0xFFFFD7C2),
    Color(0xFFF0B99A),
    Color(0xFFD9A784),
    Color(0xFFB9805A),
    Color(0xFF8A5A3B),
  ];

  final List<String> hairStyles = const [
    "Short",
    "Curly",
    "Wave",
    "Bun",
  ];

  final List<String> outfits = const [
    "Casual",
    "Campus",
    "Formal",
    "Street",
  ];

  final List<Color> accentPalette = const [
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFF0EA5A4),
    Color(0xFFEF4444),
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
                      "Create Your Avatar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _AvatarPreview(
                  name: nameController.text.trim().isEmpty
                      ? "You"
                      : nameController.text.trim(),
                  skinTone: skinTone,
                  hairStyle: hairStyle,
                  glasses: glasses,
                  outfit: outfit,
                  accentColor: accentColor,
                ),
                const SizedBox(height: 20),
                _SectionLabel(title: "Your Name"),
                TextField(
                  controller: nameController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Color(0xFFE5E7EB)),
                  decoration: InputDecoration(
                    hintText: "Type your name",
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFF0B1220),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _SectionLabel(title: "Gender"),
                Wrap(
                  spacing: 10,
                  children: ["Female", "Male", "Non-binary"].map((value) {
                    final isSelected = gender == value;
                    return ChoiceChip(
                      label: Text(value),
                      selected: isSelected,
                      backgroundColor: const Color(0xFF1F2937),
                      selectedColor: accentColor.withOpacity(0.4),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFFE5E7EB) : const Color(0xFF9CA3AF),
                      ),
                      onSelected: (_) => setState(() => gender = value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                _SectionLabel(title: "Skin Tone"),
                Wrap(
                  spacing: 12,
                  children: skinTones.map((tone) {
                    final isSelected = skinTone == tone;
                    return GestureDetector(
                      onTap: () => setState(() => skinTone = tone),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tone,
                          border: Border.all(
                            color: isSelected ? accentColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                _SectionLabel(title: "Hair Style"),
                Wrap(
                  spacing: 10,
                  children: hairStyles.map((style) {
                    final isSelected = hairStyle == style;
                    return ChoiceChip(
                      label: Text(style),
                      selected: isSelected,
                      backgroundColor: const Color(0xFF1F2937),
                      selectedColor: accentColor.withOpacity(0.4),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFFE5E7EB) : const Color(0xFF9CA3AF),
                      ),
                      onSelected: (_) => setState(() => hairStyle = style),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                _SectionLabel(title: "Outfit"),
                Wrap(
                  spacing: 10,
                  children: outfits.map((style) {
                    final isSelected = outfit == style;
                    return ChoiceChip(
                      label: Text(style),
                      selected: isSelected,
                      backgroundColor: const Color(0xFF1F2937),
                      selectedColor: accentColor.withOpacity(0.4),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFFE5E7EB) : const Color(0xFF9CA3AF),
                      ),
                      onSelected: (_) => setState(() => outfit = style),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                _SectionLabel(title: "Accessories"),
                SwitchListTile(
                  value: glasses,
                  onChanged: (value) => setState(() => glasses = value),
                  activeThumbColor: accentColor,
                  title: const Text(
                    "Glasses",
                    style: TextStyle(color: Color(0xFFE5E7EB)),
                  ),
                  subtitle: const Text(
                    "Adds a smart, focused vibe",
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                  ),
                ),
                const SizedBox(height: 18),
                _SectionLabel(title: "Accent Color"),
                Wrap(
                  spacing: 12,
                  children: accentPalette.map((tone) {
                    final isSelected = accentColor == tone;
                    return GestureDetector(
                      onTap: () => setState(() => accentColor = tone),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tone,
                          border: Border.all(
                            color: isSelected ? const Color(0xFFE5E7EB) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                _PrimaryButton(
                  label: "Continue",
                  color: accentColor,
                  onTap: () {
                    final name = nameController.text.trim().isEmpty
                        ? "Player"
                        : nameController.text.trim();
                    context.read<FutureSelfProvider>().createAvatar(
                          AvatarModel(
                            name: name,
                            gender: gender,
                            skinTone: skinTone,
                            hairStyle: hairStyle,
                            glasses: glasses,
                            outfit: outfit,
                            accentColor: accentColor,
                          ),
                        );
                    Navigator.pushReplacementNamed(context, "/future-vision");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFE5E7EB),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
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
            padding: const EdgeInsets.symmetric(vertical: 16),
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

class _AvatarPreview extends StatelessWidget {
  final String name;
  final Color skinTone;
  final String hairStyle;
  final bool glasses;
  final String outfit;
  final Color accentColor;

  const _AvatarPreview({
    required this.name,
    required this.skinTone,
    required this.hairStyle,
    required this.glasses,
    required this.outfit,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: accentColor.withOpacity(0.2),
              ),
              CircleAvatar(
                radius: 34,
                backgroundColor: skinTone,
                child: Icon(
                  glasses ? Icons.remove_red_eye : Icons.face,
                  color: const Color(0xFF1F2937),
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 6),
                Text(
                  "$hairStyle hair • $outfit",
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  glasses ? "Glasses on" : "No glasses",
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
