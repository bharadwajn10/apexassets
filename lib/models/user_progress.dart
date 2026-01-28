class UserProgress {
  int budgetingLevel;
  int digitalFinanceLevel;
  int fraudAwarenessLevel;
  List<String> badges;

  UserProgress({
    this.budgetingLevel = 1,
    this.digitalFinanceLevel = 1,
    this.fraudAwarenessLevel = 1,
    List<String>? badges,
  }) : badges = badges ?? [];
}
