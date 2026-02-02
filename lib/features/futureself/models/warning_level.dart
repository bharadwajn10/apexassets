enum WarningLevel {
  safe,
  caution,
  critical,
}

extension WarningText on WarningLevel {
  String get text {
    switch (this) {
      case WarningLevel.safe:
        return "You are on a stable path.";
      case WarningLevel.caution:
        return "Be careful. Patterns are forming.";
      case WarningLevel.critical:
        return "Future at serious risk!";
    }
  }
}
