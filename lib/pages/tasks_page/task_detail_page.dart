// Flutter imports
import 'package:flutter/material.dart';

// Design imports
import '../../design/colors.dart';
import '../../design/images.dart';

// Pages

class TaskDetailPage extends StatelessWidget {
  final String taskName;
  final List<Map<String, String>> details;
  final String originalKey;
  final String practiceName;
  final bool isSolved;
  final Function(String, String)? onMarkAsSolved;

  const TaskDetailPage({
    super.key,
    required this.taskName,
    required this.details,
    required this.originalKey,
    required this.practiceName,
    required this.isSolved,
    this.onMarkAsSolved,
  });

  Widget getImageWidget(String imageName) {
    switch (imageName) {
      case "clock":
        return clock;
      case "maps_point":
        return maps_point;
      case "passport":
        return passport;
      default:
        return const Icon(Icons.image);
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final bool? solved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Вы выполнили задачу?',
            style: TextStyle(
              fontFamily: 'Europe',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'НЕТ',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Europe',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'ДА',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Europe',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (solved == true) {
      if (onMarkAsSolved != null) {
        onMarkAsSolved!(originalKey, practiceName);
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      color: darkBlue,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
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
                          color: backgroundColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...details.map((item) {
                          final key = item.keys.first;
                          final value = item.values.first;
                          if (key == "title") {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Europe",
                                ),
                              ),
                            );
                          } else if (key == "text") {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Europe",
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          } else if (key.startsWith("widget_")) {
                            final params = key.substring("widget_".length);
                            final parts = params.split("_");
                            if (parts.length >= 2) {
                              final widgetColorParam = parts[0];
                              final imageName = parts.sublist(1).join("_");
                              Color widgetColor;
                              if (widgetColorParam == "grey") {
                                widgetColor = greyWidget;
                              } else if (widgetColorParam == "white") {
                                widgetColor = Colors.white;
                              } else {
                                widgetColor = Colors.grey;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: widgetColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (imageName.toLowerCase() !=
                                          "none") ...[
                                        getImageWidget(imageName),
                                        const SizedBox(width: 8),
                                      ],
                                      Expanded(
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Europe",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        if (!isSolved) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _showConfirmationDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Завершить',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Europe",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
