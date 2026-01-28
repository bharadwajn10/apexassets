import 'package:flutter/material.dart';
import '../../models/user_progress.dart';
import 'story_screen.dart';

class LevelMapScreen extends StatefulWidget {
  final UserProgress userProgress;
  const LevelMapScreen({super.key, required this.userProgress});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  int _currentLevelIndex = 0;
  int _targetLevelIndex = 0;

  final List<Offset> points = [
    const Offset(0.5, 0.85), // Lvl 1
    const Offset(0.2, 0.65), // Lvl 2
    const Offset(0.8, 0.45), // Lvl 3
    const Offset(0.4, 0.25), // Lvl 4
    const Offset(0.5, 0.10), // Lvl 5
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _moveCharacter(int toIndex) {
    _controller.forward(from: 0.0).then((_) {
      setState(() {
        _currentLevelIndex = toIndex;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Mode"), 
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 1. The Curved Path
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: PathPainter(points: points),
              ),
              
              // 2. Level Nodes
              ...List.generate(points.length, (index) {
                return Positioned(
                  left: points[index].dx * constraints.maxWidth - 30,
                  top: points[index].dy * constraints.maxHeight - 30,
                  child: _buildLevelNode(index),
                );
              }),

              // 3. The Animated Character
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Use Lerp to find position between current and target
                  final pos = Offset.lerp(
                    points[_currentLevelIndex],
                    points[_targetLevelIndex],
                    _animation.value,
                  )!;

                  return Positioned(
                    left: pos.dx * constraints.maxWidth - 25,
                    top: pos.dy * constraints.maxHeight - 70,
                    child: const Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.directions_walk, color: Colors.white),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.teal),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLevelNode(int index) {
    bool isCompleted = index <= _currentLevelIndex;

    return GestureDetector(
      onTap: () async {
        if (index == _currentLevelIndex) {
          final bool? isSuccess = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => StoryScreen(
                userProgress: widget.userProgress, // Fixed variable name
                levelId: index + 1,
              ),
            ),
          );
          
          if (isSuccess == true && _currentLevelIndex < points.length - 1) {
            setState(() {
              _targetLevelIndex = _currentLevelIndex + 1;
            });
            _moveCharacter(_targetLevelIndex);
          }
        }
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: isCompleted ? Colors.orange : Colors.grey.shade400,
        child: Text("${index + 1}", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// --- THE MISSING PAINTER CLASS ---

class PathPainter extends CustomPainter {
  final List<Offset> points;
  PathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx * size.width, points[0].dy * size.height);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}