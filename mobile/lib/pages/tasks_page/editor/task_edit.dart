import 'package:flutter/material.dart';
import '../../../design/colors.dart';

class EditTaskPage extends StatefulWidget {
  final String taskName;
  final List<Map<String, String>> details;

  const EditTaskPage({
    Key? key,
    required this.taskName,
    required this.details,
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  final List<Map<String, String>> selectedDocuments = [];
  final List<Map<String, String>> availableDocuments = [
    {
      "display": "Паспорт гражданина РФ",
      "key": "widget_grey_passport",
    },
    {
      "display": "Заявка на пропуск с отметкой о прохожденнии вводного инструктажа",
      "key": "widget_grey_maps_point",
    },
  ];

  final List<TextEditingController> detailedInfoControllers = [];

  @override
  void initState() {
    super.initState();

    String title = '';
    String description = '';
    List<Map<String, String>> documents = [];
    List<Map<String, String>> detailedInfos = [];

    if (widget.details.isNotEmpty) {
      if (widget.details[0].containsKey("title")) {
        title = widget.details[0]["title"]!;
      }
      if (widget.details.length > 1 && widget.details[1].containsKey("text")) {
        final fullDesc = widget.details[1]["text"]!;
        final parts = fullDesc.split("\n\nНеобходимые документы:");
        description = parts.first;
      }
      bool detailedSectionStarted = false;
      for (int i = 2; i < widget.details.length; i++) {
        final item = widget.details[i];
        if (!detailedSectionStarted &&
            item.containsKey("text") &&
            item["text"]!.contains("Подробная информация")) {
          detailedSectionStarted = true;
          continue;
        }
        if (!detailedSectionStarted) {
          if (item.keys.any((key) => key.startsWith("widget_"))) {
            documents.add(item);
          }
        } else {
          if (item.containsKey("widget_white_none")) {
            detailedInfos.add(item);
          }
        }
      }
    }

    _titleController = TextEditingController(text: title);
    _descriptionController = TextEditingController(text: description);
    selectedDocuments.addAll(documents);

    for (final info in detailedInfos) {
      detailedInfoControllers
          .add(TextEditingController(text: info["widget_white_none"]));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final controller in detailedInfoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showDocumentSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: availableDocuments.length,
          itemBuilder: (context, index) {
            final doc = availableDocuments[index];
            return ListTile(
              title: Text(doc["display"]!),
              onTap: () {
                setState(() {
                  if (!selectedDocuments.any(
                          (element) => element.containsKey(doc["key"]!))) {
                    selectedDocuments.add({doc["key"]!: doc["display"]!});
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _addDetailedInfoBlock() {
    setState(() {
      detailedInfoControllers.add(TextEditingController());
    });
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isNotEmpty && description.isNotEmpty) {
      final List<Map<String, String>> updatedTask = [
        {"title": title},
        {"text": description + "\n\nНеобходимые документы:"},
        ...selectedDocuments,
      ];

      if (detailedInfoControllers.isNotEmpty) {
        updatedTask.add({"text": "\n\nПодробная информация:"});
        for (final controller in detailedInfoControllers) {
          final info = controller.text.trim();
          if (info.isNotEmpty) {
            updatedTask.add({"widget_white_none": info});
          }
        }
      }
      Navigator.pop(context, {
        "taskName": title,
        "details": updatedTask,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните все поля")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактирование задачи"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTask,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Заголовок"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Описание"),
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Необходимые документы:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: _showDocumentSelection,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellow,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedDocuments.map((doc) {
                  final key = doc.keys.first;
                  final value = doc.values.first;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.description, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            value,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Подробная информация:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 28),
                  InkWell(
                    onTap: _addDetailedInfoBlock,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellow,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: detailedInfoControllers.map((controller) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Введите информацию",
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
