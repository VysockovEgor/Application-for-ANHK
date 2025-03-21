import 'package:anhk/pages/questions/private_questions.dart';
import 'package:anhk/pages/questions/search_questions.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';
import '../../design/images.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  void _navigate(BuildContext context, bool search) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => search ? const SearchQuestions() : const PrivateQuestions(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя часть с синим фоном и логотипом
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 70,
                  width: double.infinity,
                  color: dark_blue,
                ),
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
              ],
            ),
            // Размещаем кнопки по центру экрана
            Expanded(
              child: Center(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Центрируем содержимое
                    children: [
                      ElevatedButton(
                        onPressed: () => _navigate(context, true),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: black,
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          textStyle: const TextStyle(fontSize: 16, fontFamily: 'Europe'),
                          minimumSize: const Size(double.infinity, 50), // Фиксированный размер кнопок
                        ),
                        child: const Text('Часто задаваемые вопросы'),
                      ),
                      const SizedBox(height: 50), // Отступ между кнопками
                      ElevatedButton(
                        onPressed: () => _navigate(context, false),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: black,
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          textStyle: const TextStyle(fontSize: 16, fontFamily: 'Europe'),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Личные и уникальные вопросы'),
                      ),
                    ],
                  ),
                  )

              ),
            ),
          ],
        ),
      ),
    );
  }
}
