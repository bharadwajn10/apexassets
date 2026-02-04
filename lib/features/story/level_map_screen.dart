import 'package:flutter/material.dart';
import '../../models/user_progress.dart';
import 'story_screen.dart';
import 'dart:math' as math;

class LevelMapScreen extends StatefulWidget {
  final UserProgress userProgress;
  const LevelMapScreen({super.key, required this.userProgress});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> with TickerProviderStateMixin {
  static const int PHASE_1_END = 20;
  static const int TOTAL_LEVELS = 40;

  // Horizontal layout params
  final double _itemWidth = 260.0; // spacing horizontally per item
  final double _horizontalPadding = 28.0; // side padding for the scrollable content

  final ScrollController _scrollController = ScrollController();

  // Scroll offset used by painter to align path in screen coords
  double _scrollOffset = 0.0;

  // triple-tap debug unlock state
  int _level20TapCount = 0;
  DateTime? _lastTapTime;

  final List<Color> phase1Colors = [
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

  final List<Color> phase2Colors = [
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
    Color(0xFFC084FC),
    Color(0xFF9333EA),
    Color(0xFF7C3AED),
    Color(0xFF6366F1),
    Color(0xFF4F46E5),
    Color(0xFF4338CA),
    Color(0xFF3730A3),
    Color(0xFF312E81),
  ];

  bool get isPhase2Unlocked =>
      widget.userProgress.isPhase2Unlocked || widget.userProgress.storyModeLevel > PHASE_1_END;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    // Scroll to current level after layout
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentLevel());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // New mapping: index 0 => level 1 (leftmost). index 19 => level 20. index 20 => barrier.
  // index 21 => level 21 ... index 40 => level 40 (rightmost).
  int _levelForIndex(int index) {
    if (index < 20) return index + 1; // 1..20
    if (index == 20) return -1; // barrier
    return index; // 21..40
  }

  int _indexForLevel(int level) {
    if (level <= 20) return level - 1; // level 1 -> index 0
    return level; // level 21 -> index 21
  }

  void _scrollToCurrentLevel() {
    if (!_scrollController.hasClients) return;
    final index = _indexForLevel(widget.userProgress.storyModeLevel);
    final screenWidth = MediaQuery.of(context).size.width;
    double offset = index * _itemWidth - screenWidth / 2 + (_itemWidth / 2);
    if (offset < 0) offset = 0;
    final max = _scrollController.position.hasContentDimensions ? _scrollController.position.maxScrollExtent : double.infinity;
    if (offset > max) offset = max;
    _scrollController.animateTo(offset, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
  }

  void _handleLevel20Tap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _level20TapCount = 0;
    }
    _level20TapCount++;
    _lastTapTime = now;
    if (_level20TapCount >= 3 && !isPhase2Unlocked) {
      setState(() {
        widget.userProgress.isPhase2Unlocked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('🎉 Advanced Phase Unlocked! (debug)'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void _showLockedLevelMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Complete the previous level to unlock this one.'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showPhase2LockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Complete Level 20 to unlock Advanced Phase!'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xFF8B5CF6),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = TOTAL_LEVELS + 1; // 41
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Road painter draws over the whole viewport using scrollOffset so the path matches nodes' screen positions
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BackgroundPathPainter.horizontal(
                        itemCount: itemCount,
                        itemWidth: _itemWidth,
                        horizontalPadding: _horizontalPadding,
                        scrollOffset: _scrollOffset,
                        viewportSize: size,
                        levelForIndex: _levelForIndex,
                      ),
                    ),
                  ),

                  // Horizontal list of nodes
                  ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 24),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == 20) {
                        return SizedBox(width: _itemWidth, child: _buildPhaseBarrier());
                      } else {
                        final int level = _levelForIndex(index);
                        return SizedBox(width: _itemWidth, child: _buildLevelItemHorizontal(level, index));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
          const Text("Story Mode", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPhaseBarrier() {
    if (isPhase2Unlocked) {
      return Center(child: Text("Phase 2 Unlocked", style: TextStyle(color: Colors.white70)));
    }

    return Center(
      child: Container(
        width: _itemWidth * 0.85,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.lock, size: 36, color: Colors.white70),
            SizedBox(height: 8),
            Text("Complete Phase 1 to unlock Phase 2",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelItemHorizontal(int level, int index) {
    final bool isPhase2 = level > PHASE_1_END;
    bool isLocked = level > widget.userProgress.storyModeLevel;
    if (isPhase2 && !isPhase2Unlocked) isLocked = true;
    final bool isCurrent = level == widget.userProgress.storyModeLevel;

    final Color baseColor =
        isPhase2 ? phase2Colors[(level - (PHASE_1_END + 1)) % phase2Colors.length] : phase1Colors[(level - 1) % phase1Colors.length];

    // Node vertical placement: alternate top/bottom for zig-zag and avoid overlap
    final bool top = index % 2 == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // tile background
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Node column
          Positioned(
            top: top ? 14 : null,
            bottom: top ? null : 14,
            child: GestureDetector(
              onTap: () => _onNodeTap(level, isLocked, isPhase2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (top) ...[
                    _nodeWidget(level, baseColor, isLocked, isCurrent),
                    const SizedBox(height: 8),
                    _nodeLabel(level),
                  ] else ...[
                    _nodeLabel(level),
                    const SizedBox(height: 8),
                    _nodeWidget(level, baseColor, isLocked, isCurrent),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nodeWidget(int level, Color color, bool isLocked, bool isCurrent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: isCurrent ? 18 : 10)],
            border: Border.all(color: Colors.white.withOpacity(isLocked ? 0.12 : 0.6), width: 3),
          ),
          child: Center(
            child: Text(
              "$level",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
        ),
        if (isLocked)
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.6)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, color: Colors.white, size: 20),
                  const SizedBox(height: 6),
                  Text(
                    _lockedNodeMessage(level),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _nodeLabel(int level) {
    return Container(
      width: 120,
      alignment: Alignment.center,
      child: const Text(
        "Tap to play",
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  void _onNodeTap(int level, bool isLocked, bool isPhase2) {
    if (level == 20) _handleLevel20Tap();

    if (isLocked) {
      if (isPhase2 && !isPhase2Unlocked) {
        _showPhase2LockedMessage();
      } else {
        _showLockedLevelMessage();
      }
      return;
    }

    _openStoryScreen(level);
  }

  Future<void> _openStoryScreen(int level) async {
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
        if (level == 20) widget.userProgress.isPhase2Unlocked = true;
        widget.userProgress.storyModeLevel = level + 1;
        if (widget.userProgress.storyModeLevel > widget.userProgress.highestLevelReached) {
          widget.userProgress.highestLevelReached = widget.userProgress.storyModeLevel;
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentLevel());
    }
  }

  String _lockedNodeMessage(int level) {
    if (level > PHASE_1_END && !isPhase2Unlocked) return "Complete\nPhase 1";
    return "Complete\nprevious";
  }
}

/// Painter that draws a continuous horizontal curvy road connecting nodes.
/// The painter uses the current scroll offset to compute the node screen X coordinate.
class _BackgroundPathPainter extends CustomPainter {
  final int itemCount;
  final double itemWidth;
  final double horizontalPadding;
  final double scrollOffset;
  final Size viewportSize;
  final int Function(int index) levelForIndex;

  _BackgroundPathPainter.horizontal({
    required this.itemCount,
    required this.itemWidth,
    required this.horizontalPadding,
    required this.scrollOffset,
    required this.viewportSize,
    required this.levelForIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = viewportSize.width;
    final double h = viewportSize.height;

    // vertical midline and amplitude for the wave
    final double midY = h * 0.5;
    final double amplitude = h * 0.20; // how tall the hills are

    // collect centers (skip barrier index 20)
    final List<Offset> centers = [];
    final List<int> indices = [];

    for (int i = 0; i < itemCount; i++) {
      if (i == 20) continue;
      final level = levelForIndex(i);
      if (level < 0) continue;

      final double contentX = horizontalPadding + i * itemWidth + itemWidth / 2;
      final double screenX = contentX - scrollOffset;

      // create smoothly varying vertical position using sine so nodes follow a wavy road
      final double phase = i * 0.6;
      final double y = midY + math.sin(phase) * amplitude * ((i % 2 == 0) ? -0.45 : 0.45);

      centers.add(Offset(screenX, y));
      indices.add(i);
    }

    if (centers.length < 2) return;

    // draws a soft shadow under the road
    final Paint shadow = Paint()
      ..color = Colors.black.withOpacity(0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36
      ..strokeCap = StrokeCap.round;

    final Paint road = Paint()
      ..color = const Color(0xFFf6d78a).withOpacity(0.98)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final Paint highlight = Paint()
      ..color = Colors.white.withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    path.moveTo(centers.first.dx, centers.first.dy);

    for (int i = 1; i < centers.length; i++) {
      final p0 = centers[i - 1];
      final p1 = centers[i];

      final double dx = (p1.dx - p0.dx).abs();
      final double controlX = dx * 0.45 + 40;

      final double phase = (p0.dx + p1.dx) / 220.0;
      final double wave = math.sin(phase + i * 0.3) * 28.0;

      final Offset c1 = Offset(p0.dx + controlX, p0.dy + (p1.dy - p0.dy) * 0.25 - wave);
      final Offset c2 = Offset(p1.dx - controlX, p1.dy - (p1.dy - p0.dy) * 0.25 + wave);

      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, shadow);
    canvas.drawPath(path, road);
    canvas.drawPath(path, highlight);

    // small dots at centers
    final Paint dot = Paint()..color = Colors.black.withOpacity(0.12);
    for (final c in centers) {
      canvas.drawCircle(c, 5.0, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPathPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset || oldDelegate.viewportSize != viewportSize;
  }
}