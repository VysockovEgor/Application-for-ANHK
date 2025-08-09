import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../design/colors.dart';
// Импортируйте здесь, если нужно
// Импортируйте страницу ProfilePage

class SuccesPage extends StatelessWidget {
  const SuccesPage({super.key});

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
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.isFirst || route.settings.name == 'profile',
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Центрируем содержимое с картинкой и текстом
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.all(16), // Отступы внутри контейнера
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Центрирование по вертикали
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Центрирование по горизонтали
                    children: [
                      // Текст под картинкой
                      const Text(
                        "Ваш пароль успешно изменен!",
                        style: TextStyle(
                          fontFamily: 'Europe',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Черный цвет текста
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Добавление изображения с галочкой (icon_yes)
                      SvgPicture.asset(
                        'assets/images/healthicons_yes.svg', // Путь к изображению
                        width: 150, // Устанавливаем фиксированную ширину
                        height: 150, // Устанавливаем фиксированную высоту
                        fit: BoxFit
                            .contain, // Используем BoxFit.contain для корректного отображения
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
