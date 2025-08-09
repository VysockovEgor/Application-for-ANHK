import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design/colors.dart';
import '../../design/dimensions.dart';
import '../../providers/tasks_provider.dart';
import '../../providers/tasks_tab_provider.dart';
import 'task_item.dart';
import '../tasks_page/tasks_page.dart';

const double normal = 16.0;

class LevelTasksPage extends ConsumerStatefulWidget {
  final TaskLevel level;
  final int levelIndex;

  const LevelTasksPage({
    super.key,
    required this.level,
    required this.levelIndex,
  });

  @override
  _LevelTasksPageState createState() => _LevelTasksPageState();
}

class _LevelTasksPageState extends ConsumerState<LevelTasksPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final tabIndex = ref.watch(tasksTabIndexProvider);

    // Синхронизируем контроллер с провайдером
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index != tabIndex) {
        _tabController.animateTo(tabIndex);
      }
    });

    // Фильтруем задачи по уровню и тексту поиска
    final levelTasks =
        tasks.where((t) => t.level == widget.levelIndex).toList();
    final filteredTasks = levelTasks.where((t) {
      final title = _getTaskTitle(t.details).toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
    }).toList();
    final unsolved = filteredTasks.where((t) => !t.isSolved).toList();
    final solved = filteredTasks.where((t) => t.isSolved).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Синий блок с заголовком и кнопкой назад
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // стиль текста
                    const textStyle = TextStyle(
                      fontFamily: 'Europe',
                      fontSize: big,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    );

                    // измеряем ширину текста без ограничений
                    final painter = TextPainter(
                      text: TextSpan(text: widget.level.name, style: textStyle),
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                    )..layout();

                    // параметры:
                    const defaultLeftPadding =
                        56.0; // исходный отступ (72 - 16 кнопка)
                    const minLeftPadding = 8.0; // минимальный отступ
                    const iconButtonWidth = 48.0; // примерно размер IconButton
                    final availableWidth = constraints.maxWidth;

                    // высчитываем максимально возможный отступ
                    final freeSpace =
                        availableWidth - iconButtonWidth - painter.width;
                    // ограничиваем его минимальным и дефолтным значениями
                    final leftPadding =
                        freeSpace.clamp(minLeftPadding, defaultLeftPadding);

                    return Row(
                      children: [
                        // кнопка назад
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        // динамический отступ
                        SizedBox(width: leftPadding),
                        // заголовок
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.level.name,
                              style: textStyle,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Вкладки
            TabBar(
              controller: _tabController,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: yellow, width: 3),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              onTap: (i) => ref.read(tasksTabIndexProvider.notifier).state = i,
              tabs: const [
                Tab(text: 'Нерешённые'),
                Tab(text: 'Решённые'),
              ],
            ),
            // Содержание вкладок
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTasksList(unsolved),
                  _buildTasksList(solved),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<dynamic> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'Ничего не найдено',
          style: TextStyle(fontFamily: 'Europe', color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final t = list[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TaskItem(
            taskName: _getTaskTitle(t.details),
            details: t.details,
            originalKey: t.originalKey,
            practiceName: t.practiceName,
            isSolved: t.isSolved,
            onMarkAsSolved: (k, p) {
              ref.read(tasksProvider.notifier).markAsSolved(k, p);
              ref.read(tasksTabIndexProvider.notifier).state = 1;
            },
          ),
        );
      },
    );
  }

  String _getTaskTitle(List<Map<String, String>> details) {
    for (var item in details) {
      if (item.containsKey('title')) return item['title']!;
    }
    return '';
  }
}
