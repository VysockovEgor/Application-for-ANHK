import 'package:flutter/material.dart';
import 'package:anhk/design/colors.dart';
import 'package:anhk/design/images.dart';
import 'package:anhk/pages/profile/profile_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design/colors.dart';
import '../../../design/images.dart'; // Импортируйте здесь, если нужно
import 'package:anhk/pages/profile/profile_page.dart';

class AchievmentsPage extends StatelessWidget {
  const AchievmentsPage({Key? key}) : super(key: key);

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
                    color: dark_blue,
                  ),
                  // Нижняя закругленная часть белого цвета
                  Positioned(
                    bottom: -8,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        color: background_color,
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
                        color: Colors.white,  // Белая стрелочка
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Пример достижения
                    AchievementItem(
                      image: 'assets/achievement_image_1.png', // Путь к изображению
                      title: 'Достижение 1',
                    ),
                    const SizedBox(height: 10),
                    AchievementItem(
                      image: 'assets/achievement_image_2.png', // Путь к изображению
                      title: 'Достижение 2',
                    ),
                    const SizedBox(height: 10),
                    AchievementItem(
                      image: 'assets/achievement_image_3.png', // Путь к изображению
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
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

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
            offset: Offset(0, 3),
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
            fit: BoxFit.contain, // Используем BoxFit.contain для корректного отображения
          ),
          const SizedBox(width: 10),
          // Название достижения
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
