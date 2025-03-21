import 'package:anhk/pages/questions/questions_page.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';
import '../../design/images.dart';



class PrivateQuestions extends StatelessWidget {
  const PrivateQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Декодирование JSON
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              // Построение списка задач с порядковыми номерами
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuestionsPage()),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: arrow_back,
                    ),
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