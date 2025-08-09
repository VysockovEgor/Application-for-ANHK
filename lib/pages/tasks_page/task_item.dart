// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Design imports
import '../../design/colors.dart';

// Local imports
import 'task_detail_page.dart';

class TaskItem extends ConsumerWidget {
  final String taskName;
  final List<Map<String, String>> details;
  final String originalKey;
  final String practiceName;
  final bool isSolved;
  final Function(String, String)? onMarkAsSolved;

  const TaskItem({
    super.key,
    required this.taskName,
    required this.details,
    required this.originalKey,
    required this.practiceName,
    required this.isSolved,
    this.onMarkAsSolved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                taskName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Europe",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final bool? solved = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailPage(
                    taskName: taskName,
                    details: details,
                    originalKey: originalKey,
                    practiceName: practiceName,
                    isSolved: isSolved,
                    onMarkAsSolved: onMarkAsSolved,
                  ),
                ),
              );

              if (solved == true && onMarkAsSolved != null) {
                onMarkAsSolved!(originalKey, practiceName);
              }
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: yellow,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
