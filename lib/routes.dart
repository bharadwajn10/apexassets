import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/story/story_screen.dart';
import 'features/budgeting/budget_screen.dart';
import 'features/profile/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/story': (context) => const StoryScreen(),
  '/budget': (context) => const BudgetScreen(),
  '/profile': (context) => const ProfileScreen(),
};
