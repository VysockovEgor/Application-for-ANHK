import 'package:anhk/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:anhk/design/colors.dart';
import 'package:anhk/pages/main_page/main_page.dart';
import 'package:anhk/pages/tasks_page/tasks_page.dart';
import 'package:anhk/pages/questions/questions_page.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  // Основные страницы, доступные через меню
  final List<Widget> _menuPages = const [
    MainPage(),
    TasksPage(),
    QuestionsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    // Переход внутри вложенного Navigator:
    _navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => _menuPages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          // Начальная страница соответствует выбранной вкладке меню
          return MaterialPageRoute(builder: (_) => _menuPages[_selectedIndex]);
        },
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: CircleAvatar(
              backgroundColor: yellow,
              child: Icon(Icons.home, color: Colors.white),
            ),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: CircleAvatar(
              backgroundColor: yellow,
              child: Icon(Icons.task, color: Colors.white),
            ),
            label: 'Задачи',
          ),
          NavigationDestination(
            icon: Icon(Icons.question_answer),
            selectedIcon: CircleAvatar(
              backgroundColor: yellow,
              child: Icon(Icons.question_answer, color: Colors.white),
            ),
            label: 'Вопросы',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: CircleAvatar(
              backgroundColor: yellow,
              child: Icon(Icons.account_circle, color: Colors.white),
            ),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
