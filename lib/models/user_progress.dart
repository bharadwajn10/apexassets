class UserProgress {
  int budgetingLevel;
  int digitalFinanceLevel;
  int fraudAwarenessLevel;
  int storyModeLevel;
  List<String> badges;

  UserProgress({
    this.budgetingLevel = 1,
    this.digitalFinanceLevel = 1,
    this.fraudAwarenessLevel = 1,
    this.storyModeLevel = 1,
    List<String>? badges,
  }) : badges = badges ?? [];
}
