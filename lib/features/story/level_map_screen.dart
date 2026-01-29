import 'package:flutter/material.dart';
import '../../models/user_progress.dart';
import 'story_screen.dart';

class LevelMapScreen extends StatefulWidget {
  final UserProgress userProgress;
  const LevelMapScreen({super.key, required this.userProgress});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> with TickerProviderStateMixin {
  late AnimationController _jumpController;
  late AnimationController _bounceController;
  late Animation<double> _jumpAnimation;
  late Animation<double> _bounceAnimation;
  
  int _currentLevelIndex = 0;
  int _targetLevelIndex = 0;
  bool _isJumping = false;

  final List<Offset> points = [
    const Offset(0.1, 0.85),  // Lvl 1
    const Offset(0.25, 0.75), // Lvl 2
    const Offset(0.15, 0.6),  // Lvl 3
    const Offset(0.35, 0.5),  // Lvl 4
    const Offset(0.2, 0.35),  // Lvl 5
    const Offset(0.45, 0.25), // Lvl 6
    const Offset(0.3, 0.15),  // Lvl 7
    const Offset(0.55, 0.1),  // Lvl 8
    const Offset(0.4, 0.05),  // Lvl 9
    const Offset(0.65, 0.02), // Lvl 10
  ];

  final List<Color> levelColors = [
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.indigo,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _currentLevelIndex = widget.userProgress.storyModeLevel - 1;
    
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _jumpAnimation = CurvedAnimation(
      parent: _jumpController, 
      curve: Curves.elasticOut,
    );
    
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    );
    
    _bounceController.repeat(reverse: true);
  }

  void _jumpToLevel(int toIndex) {
    if (_isJumping || toIndex >= points.length) return;
    
    setState(() {
      _isJumping = true;
      _targetLevelIndex = toIndex;
    });
    
    _jumpController.forward(from: 0.0).then((_) {
      setState(() {
        _currentLevelIndex = toIndex;
        _isJumping = false;
      });
      _jumpController.reset();
    });
  }

  @override
  void dispose() {
    _jumpController.dispose();
    _bounceController.dispose();
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
              Color(0xFFFFF6E5),
              Color(0xFFFFE5F1),
              Color(0xFFE5F3FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Cute Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Text(
                        "🌈 Story Adventure 🌈",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Level Map
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Decorative clouds
                        _buildDecorativeClouds(constraints),
                        
                        // The Curved Path
                        CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight),
                          painter: RainbowPathPainter(points: points),
                        ),
                        
                        // Level Nodes
                        ...List.generate(points.length, (index) {
                          return Positioned(
                            left: points[index].dx * constraints.maxWidth - 35,
                            top: points[index].dy * constraints.maxHeight - 35,
                            child: _buildLevelNode(index),
                          );
                        }),

                        // The Animated Character
                        AnimatedBuilder(
                          animation: Listenable.merge([_jumpAnimation, _bounceAnimation]),
                          builder: (context, child) {
                            final pos = _isJumping 
                                ? Offset.lerp(
                                    points[_currentLevelIndex],
                                    points[_targetLevelIndex],
                                    _jumpAnimation.value,
                                  )!
                                : points[_currentLevelIndex];
                            
                            final jumpHeight = _isJumping 
                                ? (1 - _jumpAnimation.value) * 150 
                                : _bounceAnimation.value * 20;

                            return Positioned(
                              left: pos.dx * constraints.maxWidth - 30,
                              top: pos.dy * constraints.maxHeight - 70 - jumpHeight,
                              child: _buildCharacter(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelNode(int index) {
    final isUnlocked = index <= widget.userProgress.storyModeLevel - 1;
    final isCurrent = index == _currentLevelIndex;
    final levelColor = levelColors[index % levelColors.length];

    return GestureDetector(
      onTap: () async {
        if (isUnlocked && index == _currentLevelIndex) {
          final bool? isSuccess = await Navigator.push<bool>(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => StoryScreen(
                userProgress: widget.userProgress,
                levelId: index + 1,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticOut,
                  )),
                  child: child,
                );
              },
            ),
          );
          
          if (isSuccess == true && _currentLevelIndex < points.length - 1) {
            setState(() {
              widget.userProgress.storyModeLevel = _currentLevelIndex + 2;
            });
            _jumpToLevel(_currentLevelIndex + 1);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect for current level
            if (isCurrent)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: levelColor.withOpacity(0.3),
                ),
              ),
            
            // Level node
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? levelColor : Colors.grey.shade300,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUnlocked 
                        ? levelColor.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.3),
                    blurRadius: isCurrent ? 20 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (!isUnlocked)
                    const Text(
                      "🔒",
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCharacter() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 25,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: Icon(
            _isJumping ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.orange,
            size: 15,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDecorativeClouds(BoxConstraints constraints) {
    return Stack(
      children: [
        Positioned(
          left: constraints.maxWidth * 0.1,
          top: constraints.maxHeight * 0.2,
          child: Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Positioned(
          left: constraints.maxWidth * 0.7,
          top: constraints.maxHeight * 0.3,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          left: constraints.maxWidth * 0.5,
          top: constraints.maxHeight * 0.6,
          child: Container(
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}

// --- THE MISSING PAINTER CLASS ---

class RainbowPathPainter extends CustomPainter {
  final List<Offset> points;
  RainbowPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx * size.width, points[0].dy * size.height);
      
      for (var j = 1; j < points.length; j++) {
        final prev = points[j - 1];
        final curr = points[j];
        final cp1x = prev.dx * size.width + (curr.dx * size.width - prev.dx * size.width) * 0.5;
        final cp1y = prev.dy * size.height - 30;
        final cp2x = prev.dx * size.width + (curr.dx * size.width - prev.dx * size.width) * 0.5;
        final cp2y = curr.dy * size.height - 30;
        
        path.cubicTo(
          cp1x, cp1y,
          cp2x, cp2y,
          curr.dx * size.width, curr.dy * size.height,
        );
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}