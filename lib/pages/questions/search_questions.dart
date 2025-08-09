import 'dart:convert';
import 'package:flutter/material.dart';
import '../../templates/accordion.dart';

class SearchQuestions extends StatefulWidget {
  const SearchQuestions({super.key});

  @override
  State<SearchQuestions> createState() => _SearchQuestionsState();
}

class _SearchQuestionsState extends State<SearchQuestions> {
  final TextEditingController _searchController = TextEditingController();

  // Тестовый JSON с реальными вопросами
  final String testJson = '''
  [
    {"title": "Как восстановить пароль?", "content": "Чтобы восстановить пароль, нажмите 'Забыли пароль?' на экране входа и следуйте инструкциям."},
    {"title": "Как изменить адрес доставки?", "content": "Вы можете изменить адрес доставки в разделе 'Мои заказы' перед оформлением нового заказа."},
    {"title": "Как отменить заказ?", "content": "Перейдите в 'Мои заказы', выберите нужный заказ и нажмите 'Отменить'."},
    {"title": "Как связаться с поддержкой?", "content": "Вы можете написать в чат поддержки в приложении или позвонить на горячую линию."},
    {"title": "Какие способы оплаты доступны?", "content": "Вы можете оплатить заказ картой, через Apple Pay, Google Pay или наличными при получении."}
  ]
  ''';

  late List<dynamic> allQuestions;
  List<dynamic> filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    allQuestions = jsonDecode(testJson);
    filteredQuestions = allQuestions; // По умолчанию показываем все вопросы

    _searchController.addListener(() {
      setState(() {
        String query = _searchController.text.toLowerCase();
        filteredQuestions = allQuestions
            .where((q) => q['title'].toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Фильтры",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text("Категория"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text("Дата"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text("Популярное"),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Закрыть"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Поиск...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.filter_list, size: 30),
                onPressed: () => _showFilters(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Вывод списка найденных вопросов
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: filteredQuestions
                    .map((q) => CustomAccordion(
                          title: q['title'],
                          content: q['content'],
                        ))
                    .toList(),
              ),
            ),
          ),

          if (filteredQuestions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Ничего не найдено",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
