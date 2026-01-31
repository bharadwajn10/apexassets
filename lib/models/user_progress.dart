class UserProgress {
  int budgetingLevel;
  int digitalFinanceLevel;
  int fraudAwarenessLevel;
  int storyModeLevel;
  int highestLevelReached;
  bool isPhase2Unlocked;
  List<String> badges;

  UserProgress({
    this.budgetingLevel = 1,
    this.digitalFinanceLevel = 1,
    this.fraudAwarenessLevel = 1,
    this.storyModeLevel = 1,
    this.highestLevelReached = 1,
    this.isPhase2Unlocked = false,
    List<String>? badges,
  }) : badges = badges ?? [];
}
