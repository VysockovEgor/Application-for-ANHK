import 'package:flutter/material.dart';

import '../design/colors.dart';

class CustomAccordion extends StatefulWidget {
  final String title;
  final String content;

  const CustomAccordion({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  _CustomAccordionState createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // скругленные углы
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Заголовочная часть
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Europe",
                      ),
                    ),
                  ),
                  // Желтый/серый круг с плюсом/минусом
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Заголовок
                ],
              ),
            ),
          ),
          // Подзаголовочный текст, который появляется при нажатии
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.content,
                style: const TextStyle(
                    fontSize: 18, fontFamily: "Europe", color: greyText),
              ),
            ),
        ],
      ),
    );
  }
}
