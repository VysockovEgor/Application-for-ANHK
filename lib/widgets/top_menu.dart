import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  final String userName;
  final int userLevel;
  final int points;
  final bool showBackButton;
  final bool showLogo;

  const TopMenu({
    super.key,
    required this.userName,
    required this.userLevel,
    required this.points,
    this.showBackButton = false,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1720),
      padding: const EdgeInsets.only(top: 29, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Левая часть: кнопка назад или логотип
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          else if (showLogo)
            Image.asset(
              'assets/images/logo.png', // Убедись, что файл существует
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, color: Colors.white),
            )
          else
            const SizedBox(width: 40), // чтобы сохранить выравнивание

          // Центр: имя и уровень
          Expanded(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFDDDDDD),
                      child: Icon(Icons.person),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFCC00)),
                      ),
                      child: Text(
                        'Уровень $userLevel',
                        style: const TextStyle(
                          color: Color(0xFFFFCC00),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Правая часть: баллы
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCC00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/points_icon.png',
                  width: 27,
                  height: 27,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.star, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  points.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
