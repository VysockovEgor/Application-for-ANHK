import 'package:anhk/pages/main_page/menu_page.dart';
import 'package:anhk/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:anhk/design/colors.dart';
import 'package:anhk/pages/authorisation_page/authorisation_page.dart';
import 'package:anhk/pages/main_page/main_page.dart';
import 'package:anhk/pages/tasks_page/tasks_page.dart';
import 'package:anhk/pages/questions/questions_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Роснефть',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: background_color,
      ),
      home: const MainScreen(),
    );
  }
}



