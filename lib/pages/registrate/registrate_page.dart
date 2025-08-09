import 'package:anhk/pages/registrate/excel_page.dart';
import 'package:anhk/pages/registrate/email_page.dart';
import 'package:flutter/material.dart';
import '../../design/colors.dart';

class Registrate extends StatelessWidget {
  const Registrate({super.key});

  void _navigate(BuildContext context, bool search) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => search ? const ThroughExcel() : const ThroughEmail(),
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
                  color: darkBlue,
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
            // Размещаем кнопки по центру экрана
            Expanded(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        textStyle:
                            const TextStyle(fontSize: 16, fontFamily: 'Europe'),
                        minimumSize: const Size(
                            double.infinity, 50), // Фиксированный размер кнопок
                      ),
                      child: const Text('Через Excel'),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        textStyle:
                            const TextStyle(fontSize: 16, fontFamily: 'Europe'),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Через Email'),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
