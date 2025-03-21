import 'package:flutter/material.dart';
import '../../design/colors.dart';
import '../../design/images.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskName;
  final List<Map<String, String>> details;

  const TaskDetailPage({
    Key? key,
    required this.taskName,
    required this.details,
  }) : super(key: key);


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
                      height: 200,
                      width: double.infinity,
                      color: dark_blue,
                      child: Center(child: highlighted_logo),
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: details.map((item) {
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
                              widgetColor = grey_widget;
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (imageName.toLowerCase() != "none") ...[
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
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            // Кнопка назад, закреплённая в левом нижнем углу
            Positioned(
              left: 16,
              bottom: 16,
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
