import 'package:flutter/material.dart';
import '../models/avatar_model.dart';
import '../../../models/user_progress.dart';

class FutureSelfProvider extends ChangeNotifier {
  AvatarModel? avatar;

  double wealthStability = 0.35;
  double stressLevel = 0.65;
  double riskAwareness = 0.3;
  double lifestyleComfort = 0.4;

  void createAvatar(AvatarModel model) {
    avatar = model;
    notifyListeners();
  }

  void syncFromProgress(UserProgress progress) {
    wealthStability = (progress.budgetingLevel / 10).clamp(0.0, 1.0);
    riskAwareness =
        ((progress.digitalFinanceLevel + progress.fraudAwarenessLevel) / 20)
            .clamp(0.0, 1.0);
    lifestyleComfort =
        ((progress.storyModeLevel + progress.highestLevelReached) / 20)
            .clamp(0.0, 1.0);

    final resilience =
        (wealthStability * 0.45 + riskAwareness * 0.35 + lifestyleComfort * 0.2)
            .clamp(0.0, 1.0);
    stressLevel = (1.0 - resilience).clamp(0.0, 1.0);
    notifyListeners();
  }

  void applyDailyCheckIn({required bool safeChoice}) {
    wealthStability =
        (wealthStability + (safeChoice ? 0.03 : -0.03)).clamp(0.0, 1.0);
    riskAwareness =
        (riskAwareness + (safeChoice ? 0.02 : -0.01)).clamp(0.0, 1.0);
    lifestyleComfort =
        (lifestyleComfort + (safeChoice ? 0.02 : -0.02)).clamp(0.0, 1.0);
    stressLevel =
        (stressLevel + (safeChoice ? -0.04 : 0.06)).clamp(0.0, 1.0);
    notifyListeners();
  }

  double get stabilityScore =>
      (wealthStability + riskAwareness + lifestyleComfort) / 3;

  String get careerStage {
    final score = stabilityScore;
    if (score < 0.3) return "Student";
    if (score < 0.55) return "Intern";
    if (score < 0.75) return "Employee";
    if (score < 0.9) return "Entrepreneur";
    return "Investor";
  }

  String get identityLabel {
    if (stabilityScore >= 0.8 && riskAwareness >= 0.7) return "Wealth Builder";
    if (riskAwareness >= 0.65 && stressLevel < 0.4) return "Smart Saver";
    if (riskAwareness < 0.4 && lifestyleComfort >= 0.6) {
      return "Careless Spender";
    }
    if (riskAwareness >= 0.6 && wealthStability < 0.45) return "Risk Taker";
    return "Steady Climber";
  }

  String get futureLetter {
    if (stabilityScore >= 0.75 && stressLevel <= 0.35) {
      return "Thank you for choosing consistency. I sleep peacefully now.";
    }
    if (stabilityScore >= 0.45) {
      return "You stumbled, but you kept moving. That is why I still shine.";
    }
    return "You ignored the signs. But even now, you can change.";
  }
}
