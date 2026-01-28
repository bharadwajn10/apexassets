import 'package:flutter/material.dart';
import '../../models/user_progress.dart';
import 'story_screen.dart';

class LevelMapScreen extends StatefulWidget {
  final UserProgress userProgress;
  const LevelMapScreen({super.key, required this.userProgress});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  // Coordinates for the "Candy Crush" path nodes
  final List<Offset> points = [
    const Offset(0.5, 0.85), 
    const Offset(0.2, 0.65), 
    const Offset(0.8, 0.45), 
    const Offset(0.4, 0.25), 
    const Offset(0.5, 0.10), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Future Vision"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: PathPainter(points: points),
              ),
              ...List.generate(points.length, (index) {
                return Positioned(
                  left: points[index].dx * constraints.maxWidth - 30,
                  top: points[index].dy * constraints.maxHeight - 30,
                  child: _buildLevelNode(index + 1),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLevelNode(int level) {
    // Only level 1 is unlocked for the demo
    bool isUnlocked = level <= 1; 

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isUnlocked) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryScreen(
                    userProgress: widget.userProgress,
                    levelId: level,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Complete previous levels first!")),
              );
            }
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: isUnlocked ? Colors.orange : Colors.grey.shade400,
            child: Icon(
              isUnlocked ? Icons.play_arrow : Icons.lock,
              color: Colors.white,
            ),
          ),
        ),
        Text("Lvl $level", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> points;
  PathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(points[0].dx * size.width, points[0].dy * size.height);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}