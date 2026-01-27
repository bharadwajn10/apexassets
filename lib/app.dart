import 'package:flutter/material.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financial Literacy App',
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
