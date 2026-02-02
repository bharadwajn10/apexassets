import 'life_indicator.dart';
import 'warning_level.dart';

class FutureState {
  final int probability;
  final WarningLevel warning;
  final List<LifeIndicator> indicators;

  FutureState({
    required this.probability,
    required this.warning,
    required this.indicators,
  });
}
