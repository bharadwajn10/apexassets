import 'package:flutter/material.dart';

import 'features/home/home_screen.dart';
import 'features/futureself/screens/future_entry_screen.dart';
import 'features/futureself/screens/future_vision_screen.dart';
import 'models/user_progress.dart';

Map<String, WidgetBuilder> appRoutes(UserProgress progress) {
  return {
    '/': (context) => HomeScreen(globalProgress: progress),

    '/future-entry': (context) => FutureEntryScreen(progress: progress),

    '/future-vision': (context) => const FutureVisionScreen(),
  };
}
