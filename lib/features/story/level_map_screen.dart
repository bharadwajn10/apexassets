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
  static const int PHASE_1_END = 20;
  static const int PHASE_2_START = 21;
  static const int TOTAL_LEVELS = 40;
  
  late AnimationController _unlockController;

  final ScrollController _scrollController = ScrollController();
  
  // Triple-tap unlock state
  int _level20TapCount = 0;
  DateTime? _lastTapTime;

  final List<Color> phase1Colors = [
    Color(0xFF0EA5A4), Color(0xFF22C55E), Color(0xFF3B82F6), Color(0xFF14B8A6), 
    Color(0xFF10B981), Color(0xFF38BDF8), Color(0xFF2DD4BF), Color(0xFF60A5FA),
    Color(0xFF34D399), Color(0xFF0EA5E9),
  ];
  
  final List<Color> phase2Colors = [
    Color(0xFF8B5CF6), Color(0xFFA78BFA), Color(0xFFC084FC), Color(0xFF9333EA),
    Color(0xFF7C3AED), Color(0xFF6366F1), Color(0xFF4F46E5), Color(0xFF4338CA),
    Color(0xFF3730A3), Color(0xFF312E81),
  ];

  int get currentPhase => widget.userProgress.storyModeLevel <= PHASE_1_END ? 1 : 2;
  bool get isPhase2Unlocked => widget.userProgress.isPhase2Unlocked || widget.userProgress.storyModeLevel > PHASE_1_END;

  @override
  void initState() {
    super.initState();
    _unlockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  void _scrollToCurrentLevel() {
    if (!_scrollController.hasClients) return;
    
    // Calculate position: Levels are built reversed (40 down to 1).
    // So Level 1 is at the bottom.
    // Index 0 in ListView is Level 40.
    // Index 39 is Level 1.
    // We want to scroll so the current level is visible.
    
    // Logic: 
    // Item 0 = Level 40
    // Item 19 = Level 21
    // Item 20 = Barrier
    // Item 21 = Level 20
    // Item 40 = Level 1
    
    // Map LevelID to Index:
    // If Level > 20: Index = 40 - Level
    // If Level <= 20: Index = 40 - Level + 1 (because of barrier)
    
    // Actually, let's just use the item height roughly.
    // But better: use a key or calculate offset.
    // Item height is ~200.
    
    int index;
    if (widget.userProgress.storyModeLevel > 20) {
      index = 40 - widget.userProgress.storyModeLevel;
    } else {
      index = 40 - widget.userProgress.storyModeLevel + 1;
    }
    
    // Scroll to center it
    double offset = index * 200.0 - MediaQuery.of(context).size.height / 2 + 100; // 100 is half item height
    if (offset < 0) offset = 0;
    if (offset > _scrollController.position.maxScrollExtent) offset = _scrollController.position.maxScrollExtent;
    
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _showLockedLevelMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete the previous level to unlock this one.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _showPhase2LockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete Level 20 to unlock Advanced Phase!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }
  
  void _handleLevel20Tap() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) > Duration(seconds: 2)) {
      _level20TapCount = 0;
    }
    _level20TapCount++;
    _lastTapTime = now;
    
    if (_level20TapCount >= 3 && !isPhase2Unlocked) {
      _triggerPhase2Unlock();
    }
  }
  
  void _triggerPhase2Unlock() {
    setState(() {
      widget.userProgress.isPhase2Unlocked = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Advanced Phase Unlocked! (Debug Mode)'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  @override
  void dispose() {
    _unlockController.dispose();
    _scrollController.dispose();
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
              Color(0xFF0B1220), Color(0xFF0F172A), Color(0xFF111827),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  // Items: 
                  // 0..19 (Levels 40 down to 21) => 20 items
                  // 20    (Barrier)              => 1 item
                  // 21..40 (Levels 20 down to 1) => 20 items
                  // Total = 41 items
                  itemCount: TOTAL_LEVELS + 1,
                  itemBuilder: (context, index) {
                    // Logic to determine what to build
                    if (index < 20) {
                      // Phase 2 Levels (40 -> 21)
                      int level = 40 - index;
                      return _buildLevelItem(level, index);
                    } else if (index == 20) {
                      // Barrier
                      return _buildPhaseBarrier();
                    } else {
                      // Phase 1 Levels (20 -> 1)
                      int level = 20 - (index - 21);
                      return _buildLevelItem(level, index);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Color(0xFFE5E7EB)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1220),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
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
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPhaseBarrier() {
    if (isPhase2Unlocked) return const SizedBox(height: 50); // Just spacing if unlocked
    
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cloud Backgrounds
          Positioned(left: -20, top: 20, child: _buildCloud(150, 70, 0.2)),
          Positioned(right: -30, bottom: 40, child: _buildCloud(180, 80, 0.15)),
          Positioned(left: 80, bottom: 10, child: _buildCloud(120, 60, 0.1)),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 40, color: Colors.white70),
                SizedBox(height: 10),
                Text(
                  "Complete phase 1 to unlock Phase 2",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "🔒",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCloud(double width, double height, double opacity) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(opacity * 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelItem(int level, int index) {
    // Positioning
    // Even levels on Left, Odd on Right (or vice versa to create ZigZag)
    // Actually, let's make it simpler: alternating.
    // Level 1: Left. Level 2: Right.
    bool isLeft = level % 2 != 0;
    
    // Logic for State
    bool isPhase2 = level > 20;
    bool isLocked = isPhase2 ? (!isPhase2Unlocked || level > widget.userProgress.storyModeLevel) : (level > widget.userProgress.storyModeLevel);
    
    // Current Level Indicator
    bool isCurrent = level == widget.userProgress.storyModeLevel;
    
    // Colors
    Color baseColor = isPhase2 
        ? phase2Colors[(level - 21) % phase2Colors.length]
        : phase1Colors[(level - 1) % phase1Colors.length];
        
    if (isLocked) {
      baseColor = Colors.grey.shade800;
    }

    return SizedBox(
      height: 180, // Increased spacing
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Path Line logic
          // Make sure this is drawn behind
          Positioned.fill(
            child: CustomPaint(
              painter: _LevelPathPainter(
                isLeft: isLeft, 
                isLast: level == 1, // Stop line at level 1
                isFirst: level == 40,
                color: isLocked ? Colors.white10 : baseColor.withOpacity(0.3)
              ),
            ),
          ),
          
          // The Node
          Align(
            alignment: isLeft ? const Alignment(-0.5, 0) : const Alignment(0.5, 0),
            child: GestureDetector(
              onTap: () => _handleLevelTap(level, isLocked, isPhase2),
              child: _buildNodeCircle(level, baseColor, isLocked, isCurrent),
            ),
          ),
          
          // Character (if current)
          if (isCurrent)
            Align(
              alignment: isLeft ? const Alignment(-0.5, -0.6) : const Alignment(0.5, -0.6),
              child: _buildCharacterBadge(isPhase2),
            ),
        ],
      ),
    );
  }
  
  Widget _buildNodeCircle(int level, Color color, bool isLocked, bool isCurrent) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: isCurrent ? 25 : 15,
            spreadRadius: isCurrent ? 5 : 2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(isLocked ? 0.1 : 0.5),
          width: 3,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "$level",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          if (isLocked)
            Opacity(
              opacity: 0.3,
              child: const Icon(Icons.lock, color: Colors.white, size: 32),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterBadge(bool isPhase2) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - value)), // Bounce in
          child: Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.black, size: 20),
            ),
          ),
        );
      },
    );
  }

  void _handleLevelTap(int level, bool isLocked, bool isPhase2) async {
    // Triple tap for Level 20 debug
    if (level == 20) {
      _handleLevel20Tap();
    }
    
    if (isLocked) {
      if (isPhase2 && !isPhase2Unlocked) {
        _showPhase2LockedMessage();
      } else {
        _showLockedLevelMessage();
      }
      return;
    }
    
    // Use the StoryScreen
    final bool? isSuccess = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => StoryScreen(
          userProgress: widget.userProgress,
          levelId: level,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (isSuccess == true && widget.userProgress.storyModeLevel == level && level < TOTAL_LEVELS) {
      setState(() {
        if (level == 20) {
          widget.userProgress.isPhase2Unlocked = true;
          // _showUnlockAnimation for phase 2
        }
        widget.userProgress.storyModeLevel = level + 1;
        if (widget.userProgress.storyModeLevel > widget.userProgress.highestLevelReached) {
          widget.userProgress.highestLevelReached = widget.userProgress.storyModeLevel;
        }
      });
      // Scroll to new level
       WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentLevel();
      });
    }
  }
}

class _LevelPathPainter extends CustomPainter {
  final bool isLeft;
  final bool isLast;
  final bool isFirst;
  final Color color;
  
  _LevelPathPainter({required this.isLeft, required this.isLast, required this.isFirst, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (isLast) return; // No line going down from level 1
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
      
      // We need to draw a line connecting THIS level center to the NEXT level center (which is above, in the list).
      // Wait, ListView renders top to bottom.
      // Index 0 (Level 40) is at the top.
      // The line should go to the next item in the list (Level 39).
      // So draw from current center to bottom center?
      // No, let's draw connections relative to cell.
      
      // Let's assume standard height = 180.
      // Current center: (0.25 * w, h/2) or (0.75 * w, h/2)
      // Next level (below in UI) is opposite side.
      
      final w = size.width;
      final h = size.height;
      
      final startX = isLeft ? 0.25 * w : 0.75 * w;
      final startY = h / 2;
      
      final endX = isLeft ? 0.75 * w : 0.25 * w; // Opposite
      final endY = h + h / 2; // Center of next cell
      
      // But we can just draw half the path? 
      // It's easier to just draw a line to the bottom/top.
      
      // Let's draw a line from bottom of this node to top of next node.
      final path = Path();
      path.moveTo(startX, startY + 40); // Bottom of circle
      path.cubicTo(
        startX, h, // ctrl1
        endX, h,   // ctrl2
        endX, h + (h/2) - 40 // Top of next circle
      );
      
      // Since we clip, this might cut off. 
      // Better approach: Draw simple dashed lines or use a background stack for the whole list.
      // But for list items, we can draw a line to the bottom edge.
      
      path.reset();
      path.moveTo(startX, h/2);
      path.lineTo(endX, h * 1.5);
      
      canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}