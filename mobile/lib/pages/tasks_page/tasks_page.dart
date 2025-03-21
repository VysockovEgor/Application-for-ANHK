import 'dart:convert';
import 'package:anhk/pages/tasks_page/editor/task_edit.dart';
import 'package:anhk/pages/tasks_page/task_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design/colors.dart';
import '../../design/dimensions.dart';
import 'editor/new_task.dart';
import 'task_item.dart';
import '../authorisation_page/providers.dart';
import 'package:http/http.dart' as http;

class TasksPage extends ConsumerStatefulWidget {
  // Если practiceName == null – показываем список практик,
  // иначе – список задач для выбранной практики.
  final String? practiceName;
  const TasksPage({Key? key, this.practiceName}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  // В tasksMap каждая практика является ключом,
  // а её значение – словарь задач для этой практики.
  late Map<String, dynamic> tasksMap;

  final String updateUrl = "https://example.com/api/tasks";

  @override
  void initState() {
    super.initState();
    tasksMap = Map<String, dynamic>.from(json.decode(tasksJson));
  }

  // Функция преобразует словарь задач для выбранной практики в список задач,
  // возвращая вместе с обработанными данными оригинальный ключ и список details.
  List<Map<String, dynamic>> _convertTasksMapToList(
      Map<String, dynamic> practiceTasks) {
    List<Map<String, dynamic>> tasksList = [];
    practiceTasks.forEach((originalKey, taskData) {
      List<Map<String, String>> details = List<Map<String, String>>.from(
          taskData["details"].map((item) => Map<String, String>.from(item)));
      String title = originalKey;
      String description = "";
      Map<String, String> documents = {};
      List<String> detailData = [];

      for (var item in details) {
        if (item.containsKey("title")) {
          title = item["title"]!;
        } else if (item.containsKey("text") &&
            item["text"]!.contains("\n\nНеобходимые документы:")) {
          description =
              item["text"]!.split("\n\nНеобходимые документы:").first.trim();
        } else if (item.keys.any(
                (k) => k.startsWith("widget_") && k != "widget_white_none")) {
          item.forEach((key, value) {
            if (key.startsWith("widget_") && key != "widget_white_none") {
              documents[key] = value;
            }
          });
        } else if (item.containsKey("widget_white_none")) {
          detailData.add(item["widget_white_none"]!);
        }
      }

      tasksList.add({
        "originalKey": originalKey,
        "title": title,
        "text": description,
        "isSolved": taskData["isSolved"],
        "documents": documents,
        "detailData": detailData,
        "details": details, // сохраняем оригинальный список деталей для дальнейшего использования
      });
    });
    return tasksList;
  }

  Future<void> _sendUpdatedTasks() async {
    try {
      final response = await http.post(
        Uri.parse(updateUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(tasksMap),
      );
      if (response.statusCode != 200) {
        // обработка ошибки при необходимости
      }
    } catch (e) {
      // обработка исключений
    }
  }

  // Операции с задачами для выбранной практики (вызываются только если practiceName != null)
  void markTaskAsSolved(String taskKey) {
    if (widget.practiceName != null) {
      setState(() {
        (tasksMap[widget.practiceName] as Map<String, dynamic>)[taskKey]
        ["isSolved"] = true;
      });
      _sendUpdatedTasks();
    }
  }

  void deleteTask(String taskKey) {
    if (widget.practiceName != null) {
      setState(() {
        (tasksMap[widget.practiceName] as Map<String, dynamic>)
            .remove(taskKey);
      });
      _sendUpdatedTasks();
    }
  }

  void editTask(String taskKey, Map<String, dynamic> taskData) async {
    if (widget.practiceName != null) {
      final isSolved = (tasksMap[widget.practiceName] as Map<String, dynamic>)[taskKey]
      ["isSolved"];
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditTaskPage(
            taskName: taskKey,
            details: List<Map<String, String>>.from(
              taskData["details"].map((item) => Map<String, String>.from(item)),
            ),
          ),
        ),
      );
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          if (taskKey != result["taskName"]) {
            (tasksMap[widget.practiceName] as Map<String, dynamic>)
                .remove(taskKey);
          }
          (tasksMap[widget.practiceName] as Map<String, dynamic>)[result["taskName"]] = {
            "details": result["details"],
            "isSolved": isSolved,
          };
        });
        _sendUpdatedTasks();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);

    // Если не выбрана практика – показываем список практик
    if (widget.practiceName == null) {
      final practices = tasksMap.keys.toList();
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Заголовок для списка практик
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    color: dark_blue,
                    child: const Center(
                      child: Text(
                        "Практики",
                        style: TextStyle(
                          fontFamily: "Europe",
                          fontSize: big + 5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
              const SizedBox(height: 22),
              Expanded(
                child: ListView.builder(
                  itemCount: practices.length,
                  itemBuilder: (context, index) {
                    final practice = practices[index];
                    return ListTile(
                      title: Text(
                        practice,
                        style: const TextStyle(
                          fontFamily: "Europe",
                          fontSize: 18,
                        ),
                      ),
                      trailing: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TasksPage(practiceName: practice),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    // Если выбрана практика – отображаем список задач для неё
    else {
      final practiceTasks =
      tasksMap[widget.practiceName] as Map<String, dynamic>;
      final tasksList = _convertTasksMapToList(practiceTasks);
      final unsolvedTasksList = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: tasksList
              .where((task) => task["isSolved"] == false)
              .map((task) {
            final taskKey = task["originalKey"] as String;
            final taskName = task["title"] as String;
            final details = task["details"] as List<Map<String, String>>;
            return Column(
              children: [
                const SizedBox(height: 10),
                TaskItem(
                  taskName: taskName,
                  details: details,
                  onDelete: () => deleteTask(taskKey),
                  onMarkAsSolved: () => markTaskAsSolved(taskKey),
                  onEdit: () => editTask(taskKey, task),
                ),
              ],
            );
          }).toList(),
        ),
      );

      final solvedTasksList = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: tasksList
              .where((task) => task["isSolved"] == true)
              .map((task) {
            final taskKey = task["originalKey"] as String;
            final taskName = task["title"] as String;
            final details = task["details"] as List<Map<String, String>>;
            return Column(
              children: [
                const SizedBox(height: 8),
                TaskItem(
                  taskName: taskName,
                  details: details,
                  onDelete: () => deleteTask(taskKey),
                  onMarkAsSolved: () {},
                  onEdit: () => editTask(taskKey, task),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      );

      return Scaffold(
        body: SafeArea(
          child: Stack( // Используем Stack для позиционирования кнопки
            children: [
              Column(
                children: [
                  // Заголовок – название практики и кнопка добавления (если admin)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 110,
                        width: double.infinity,
                        color: dark_blue,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.practiceName!,
                                style: const TextStyle(
                                  fontFamily: "Europe",
                                  fontSize: big + 5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (isAdmin)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: yellow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add, color: Colors.black),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const NewTaskPage()),
                                    );
                                    if (result != null && result is Map<String, dynamic>) {
                                      final newTaskKey = result["taskName"] as String;
                                      final details = result["details"] as List<Map<String, String>>;
                                      setState(() {
                                        (tasksMap[widget.practiceName!]
                                        as Map<String, dynamic>)[newTaskKey] = {
                                          "details": details,
                                          "isSolved": false,
                                        };
                                      });
                                      _sendUpdatedTasks();
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
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
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'Europe',
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Поиск...',
                        hintStyle: const TextStyle(
                          fontFamily: 'Europe',
                          color: Colors.grey,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedTabSwitcher(
                      firstTabContent: unsolvedTasksList,
                      secondTabContent: solvedTasksList,
                    ),
                  ),
                ],
              ),
              // Переносим Positioned за пределы Column, но внутри Stack
              Positioned(
                left: 16, // Перемещаем кнопку влево
                bottom: 16, // Прижимаем к нижнему краю
                child: FloatingActionButton(
                  backgroundColor: yellow,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );

    }
  }
}

class AnimatedTabSwitcher extends StatefulWidget {
  final Widget firstTabContent;
  final Widget secondTabContent;

  const AnimatedTabSwitcher({
    Key? key,
    required this.firstTabContent,
    required this.secondTabContent,
  }) : super(key: key);

  @override
  _AnimatedTabSwitcherState createState() => _AnimatedTabSwitcherState();
}

class _AnimatedTabSwitcherState extends State<AnimatedTabSwitcher>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: yellow, width: 3.0),
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Нерешенные задачи'),
            Tab(text: 'Решенные задачи'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(child: widget.firstTabContent),
              SingleChildScrollView(child: widget.secondTabContent),
            ],
          ),
        ),
      ],
    );
  }
}
