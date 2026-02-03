import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home/home_screen.dart';
import 'features/futureself/screens/future_entry_screen.dart';
import 'features/futureself/screens/avatar_creation_screen.dart';
import 'features/futureself/screens/future_vision_screen.dart';
import 'features/futureself/services/future_self_provider.dart';
import 'models/user_progress.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FutureSelfProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProgress = UserProgress(
      budgetingLevel: 1,
      digitalFinanceLevel: 1,
      fraudAwarenessLevel: 1,
      storyModeLevel: 1,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rokka Mestru',

      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),

      initialRoute: '/',

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(globalProgress: userProgress),
            );

          case '/future-entry':
            final progress = settings.arguments is UserProgress
                ? settings.arguments as UserProgress
                : userProgress;
            return MaterialPageRoute(
              builder: (_) => FutureEntryScreen(progress: progress),
            );

          case '/avatar':
            return MaterialPageRoute(
              builder: (_) => const AvatarCreationScreen(),
            );

          case '/future-vision':
            return MaterialPageRoute(
              builder: (_) => const FutureVisionScreen(),
            );

          default:
            return null;
        }
      },
    );
  }
}
