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

  late final List<Offset> points;
  late final RainbowPathPainter _pathPainter;

  final List<Color> levelColors = [
    Color(0xFF0EA5A4),
    Color(0xFF22C55E),
    Color(0xFF3B82F6),
    Color(0xFF14B8A6),
    Color(0xFF10B981),
    Color(0xFF38BDF8),
    Color(0xFF2DD4BF),
    Color(0xFF60A5FA),
    Color(0xFF34D399),
    Color(0xFF0EA5E9),
  ];

  @override
  void initState() {
    super.initState();
    _currentLevelIndex = widget.userProgress.storyModeLevel - 1;

    const int levelCount = 10;
    const double yStart = 0.9;
    const double yEnd = 0.1;
    final double step = (yStart - yEnd) / (levelCount - 1);
    points = List.generate(levelCount, (i) {
      final double y = yStart - (i * step);
      final double x = i.isEven ? 0.25 : 0.75;
      return Offset(x, y);
    });

    _pathPainter = RainbowPathPainter(points: points);
    
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

  void _showLockedLevelMessage() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Complete the previous level to unlock this one.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
              Color(0xFF0B1220),
              Color(0xFF0F172A),
              Color(0xFF111827),
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
                        color: const Color(0xFF0B1220),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            blurRadius: 22,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_up, color: Color(0xFFE5E7EB), size: 22),
                          SizedBox(width: 10),
                          Text(
                            "Story Mode",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE5E7EB),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Level Map
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double mapWidth = constraints.maxWidth;
                    final double mapHeight = constraints.maxHeight * 2;

                    return InteractiveViewer(
                      constrained: false,
                      panEnabled: true,
                      scaleEnabled: false,
                      boundaryMargin: const EdgeInsets.all(200),
                      child: SizedBox(
                        width: mapWidth,
                        height: mapHeight,
                        child: Stack(
                          children: [
                            // Decorative clouds
                            RepaintBoundary(
                              child: _buildDecorativeClouds(BoxConstraints(
                                maxWidth: mapWidth,
                                maxHeight: mapHeight,
                              )),
                            ),

                            // The Curved Path
                            RepaintBoundary(
                              child: CustomPaint(
                                size: Size(mapWidth, mapHeight),
                                painter: _pathPainter,
                              ),
                            ),

                            // Level Nodes
                            ...List.generate(points.length, (index) {
                              return Positioned(
                                left: points[index].dx * mapWidth - 35,
                                top: points[index].dy * mapHeight - 35,
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
                                  left: pos.dx * mapWidth - 30,
                                  top: pos.dy * mapHeight - 70 - jumpHeight,
                                  child: _buildCharacter(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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

    final Color base = isUnlocked ? levelColor : const Color(0xFF374151);
    final Color highlight = isUnlocked ? const Color(0xFFE5E7EB) : const Color(0xFF9CA3AF);

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
        } else if (!isUnlocked) {
          _showLockedLevelMessage();
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
                  color: base.withOpacity(0.18),
                ),
              ),
            
            // Level node
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.4, -0.6),
                  radius: 1.2,
                  colors: [
                    base.withOpacity(0.95),
                    base.withOpacity(0.75),
                    const Color(0xFF0B1220),
                  ],
                ),
                border: Border.all(
                  color: highlight.withOpacity(0.2),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000),
                    blurRadius: isCurrent ? 22 : 14,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: base.withOpacity(isUnlocked ? 0.18 : 0.10),
                    blurRadius: isCurrent ? 26 : 16,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: const Color(0xFFE5E7EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (!isUnlocked)
                    const Icon(Icons.lock, size: 16, color: Color(0xFF9CA3AF)),
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
            color: const Color(0xFF0EA5A4),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0EA5A4).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: const Color(0xFFE5E7EB),
            size: 25,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: Icon(
            _isJumping ? Icons.arrow_upward : Icons.arrow_downward,
            color: const Color(0xFF0EA5A4),
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
              color: const Color(0xFF94A3B8).withOpacity(0.08),
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
              color: const Color(0xFF94A3B8).withOpacity(0.06),
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
              color: const Color(0xFF94A3B8).withOpacity(0.05),
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
      ..color = const Color(0xFF60A5FA).withOpacity(0.25)
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