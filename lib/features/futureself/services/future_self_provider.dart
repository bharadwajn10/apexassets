import 'package:flutter/material.dart';
import '../models/avatar_model.dart';

class FutureSelfProvider extends ChangeNotifier {
  AvatarModel? avatar;

  double budgeting = 0.0;
  double discipline = 0.0;
  double consistency = 0.0;

  void createAvatar(AvatarModel model) {
    avatar = model;
    notifyListeners();
  }

  void updatePerformance({
    required double budget,
    required double disciplineScore,
    required double consistencyScore,
  }) {
    budgeting = budget;
    discipline = disciplineScore;
    consistency = consistencyScore;
    notifyListeners();
  }

  double get successProbability =>
      (budgeting + discipline + consistency) / 3;

  String get futureLetter {
    if (successProbability >= 0.75) {
      return "I’m proud of you. You stayed disciplined when it mattered.";
    } else if (successProbability >= 0.4) {
      return "You struggled, but you didn’t quit. That’s why I exist.";
    } else {
      return "You ignored the signs. But even now, you can change.";
    }
  }
}
