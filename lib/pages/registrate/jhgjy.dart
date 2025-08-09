import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'КЕНТ КЛАБ ТОПРП',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана
    double screenWidth = MediaQuery.of(context).size.width;

    // Устанавливаем количество элементов в ряду в зависимости от ширины экрана
    int crossAxisCount = (screenWidth / 140)
        .floor(); // Разделим ширину экрана на размер квадратика

    // Ограничиваем минимальное и максимальное количество элементов в ряду
    crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;
    crossAxisCount = crossAxisCount > 6 ? 6 : crossAxisCount;

    // Устанавливаем значение соотношения сторон для квадратов
    double childAspectRatio = 1.0; // Соотношение ширины и высоты квадрата
    if (screenWidth >= 1200) {
      childAspectRatio = 1.2; // На больших экранах квадраты будут чуть меньшими
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic GridView'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Увеличили отступы
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Всегда 2 столбца
            crossAxisSpacing: 12, // Расстояние между квадратами по горизонтали
            mainAxisSpacing: 12, // Расстояние между квадратами по вертикали
            childAspectRatio: childAspectRatio, // Соотношение ширины и высоты
          ),
          itemCount: 12, // Количество квадратов
          itemBuilder: (context, index) {
            return _buildSquareWithText();
          },
        ),
      ),
    );
  }

  Widget _buildSquareWithText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Контейнер квадрата
        Container(
          decoration: BoxDecoration(
            color: Colors.grey, // Цвет фона квадрата
            borderRadius: BorderRadius.circular(10), // Скругленные углы
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Цвет тени
                blurRadius: 10, // Размытие тени
                offset: const Offset(2, 2), // Смещение тени
              ),
            ],
          ),
          height: 120, // Установим высоту квадрата
          width: 120, // Установим ширину квадрата
        ),
        const SizedBox(height: 8), // Отступ между квадратом и текстом
        const Text(
          'Достижение',
          style: TextStyle(
            fontSize: 14, // Размер текста
            fontWeight: FontWeight.bold,
            overflow: TextOverflow
                .ellipsis, // Если текст не помещается, он будет сокращаться
          ),
        ),
      ],
    );
  }
}
