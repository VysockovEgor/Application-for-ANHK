import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tasks_page/tasks_page.dart';
import '../questions/questions_page.dart';
import '../profile/profile_page.dart';
import '../../design/colors.dart';
import '../../design/images.dart';
import 'sections/links/links_section.dart';
import 'sections/address/address_section.dart';
import 'sections/about/about_section.dart';
import 'sections/access/access_section.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  final int initialIndex;
  const MainApp({super.key, this.initialIndex = 0});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  Widget? _currentSection;
  bool _showBackButton = false;

  final List<MenuItem> menuItems = [
    MenuItem('Ссылки', attach, route: '/links'),
    MenuItem('Адрес', location, route: '/address'),
    MenuItem('О нас', people, route: '/about'),
    MenuItem('Пропускной режим', mask_group, route: '/access'),
    MenuItem('Баллы', gift, route: '/points'),
    MenuItem('Инструкции', gift, route: '/instructions'),
    MenuItem('Документы', gift, route: '/documents'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentSection = null;
      _showBackButton = false;
    });
  }

  void _navigateToSection(Widget section) {
    setState(() {
      _currentSection = section;
      _showBackButton = true;
    });
  }

  void _navigateBack() {
    setState(() {
      _currentSection = null;
      _showBackButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      _buildMainContent(),
      const TasksPage(),
      const QuestionsPage(),
      const ProfilePage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/links': (context) => const LinksSection(),
        '/address': (context) => const AddressSection(),
        '/about': (context) => const AboutSection(),
        '/access': (context) => const AccessSection(),
        '/points': (context) => const PlaceholderPage(title: 'Баллы'),
        '/instructions': (context) =>
            const PlaceholderPage(title: 'Инструкции'),
        '/documents': (context) => const PlaceholderPage(title: 'Документы'),
      },
      home: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          height: 70,
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.white,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: _SelectedIcon(icon: Icons.home),
              label: 'Главная',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_outlined),
              selectedIcon: _SelectedIcon(icon: Icons.task),
              label: 'Задачи',
            ),
            NavigationDestination(
              icon: Icon(Icons.question_answer),
              selectedIcon: _SelectedIcon(icon: Icons.question_answer),
              label: 'Вопросы',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: _SelectedIcon(icon: Icons.account_circle),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: darkBlue,
                child: _showBackButton
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: _navigateBack,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Колонка 1 - Аватар и уровень
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: user.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Уровень 1",
                                  style: TextStyle(
                                    color: yellow,
                                    fontFamily: "Europe",
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            // Колонка 2 - Имя
                            const Text(
                              "Даниил",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Europe",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Колонка 3 - Баллы
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: gift,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "100",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Europe",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Positioned(
                bottom: -8,
                left: 0,
                right: 0,
                child: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content
          Expanded(
            child: _currentSection ??
                Column(
                  children: [
                    // Меню (2/3 экрана)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  // Первый ряд (стандартная высота)
                                  SizedBox(
                                    height: 100,
                                    child: _buildRow(
                                        context, menuItems.sublist(0, 3)),
                                  ),
                                  const SizedBox(height: 16),
                                  // Второй ряд (увеличенная высота)
                                  SizedBox(
                                    height: 120,
                                    child: _buildRow(
                                        context, menuItems.sublist(3, 5)),
                                  ),
                                  const SizedBox(height: 16),
                                  // Третий ряд (увеличенная высота)
                                  SizedBox(
                                    height: 120,
                                    child: _buildRow(
                                        context, menuItems.sublist(5, 7)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Изображение внизу
                            Image.asset(
                              'assets/images/sunset_factory.png',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<MenuItem> items) {
    return Row(
      mainAxisAlignment: items.length == 3
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceEvenly,
      children: items.map((item) {
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                if (item.route != null) {
                  switch (item.route) {
                    case '/links':
                      _navigateToSection(const LinksSection());
                      break;
                    case '/address':
                      _navigateToSection(const AddressSection());
                      break;
                    case '/about':
                      _navigateToSection(const AboutSection());
                      break;
                    case '/access':
                      _navigateToSection(const AccessSection());
                      break;
                    default:
                      Navigator.of(context).pushNamed(item.route!);
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Текст сверху с фиксированным размером
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: "Europe",
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(), // Пространство между текстом и иконкой
                      // Иконка внизу справа
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: item.iconImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MenuItem {
  final String title;
  final Image iconImage;
  final String? route;

  const MenuItem(this.title, this.iconImage, {this.route});
}

class _SelectedIcon extends StatelessWidget {
  final IconData icon;
  const _SelectedIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: yellow,
      child: Icon(icon, color: Colors.white),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text(
          'Страница в разработке: $title',
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Europe',
          ),
        ),
      ),
    );
  }
}
