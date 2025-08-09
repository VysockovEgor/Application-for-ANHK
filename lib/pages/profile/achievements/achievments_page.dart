import 'package:flutter/material.dart';
import 'package:anhk/design/colors.dart';
import 'package:anhk/pages/profile/profile_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Импортируйте здесь, если нужно

class AchievmentsPage extends StatelessWidget {
  const AchievmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Верхняя часть с синим фоном и кнопкой назад
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 125,
                    width: double.infinity,
                    color: darkBlue,
                  ),
                  // Нижняя закругленная часть белого цвета
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
                  // Кнопка назад
                  Positioned(
                    top: 25,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white, // Белая стрелочка
                      ),
                      iconSize: 32,
                      onPressed: () {
                        // Переход на страницу ProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Заголовок Достижения по центру
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Достижения',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Список достижений
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Пример достижения
                    AchievementItem(
                      image:
                          'assets/achievement_image_1.png', // Путь к изображению
                      title: 'Достижение 1',
                    ),
                    SizedBox(height: 10),
                    AchievementItem(
                      image:
                          'assets/achievement_image_2.png', // Путь к изображению
                      title: 'Достижение 2',
                    ),
                    SizedBox(height: 10),
                    AchievementItem(
                      image:
                          'assets/achievement_image_3.png', // Путь к изображению
                      title: 'Достижение 3',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementItem extends StatelessWidget {
  final String image;
  final String title;

  const AchievementItem({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Изображение слева
          SvgPicture.asset(
            'assets/images/achievement_icon.svg', // Путь к изображению
            width: 150, // Устанавливаем фиксированную ширину
            height: 150, // Устанавливаем фиксированную высоту
            fit: BoxFit
                .contain, // Используем BoxFit.contain для корректного отображения
          ),
          const SizedBox(width: 10),
          // Название достижения
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
