import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../design/colors.dart';
import '../../design/dimensions.dart';
import '../../design/images.dart';
import '../../providers/tasks_provider.dart';
import '../../providers/tasks_tab_provider.dart';
import 'level_tasks_page.dart';

const double normal = 16.0;

class TaskLevel {
  final String name;
  final int completedTasks;
  final int totalTasks;
  final Image levelImage;
  final bool isLocked;

  TaskLevel({
    required this.name,
    required this.completedTasks,
    required this.totalTasks,
    required this.levelImage,
    this.isLocked = false,
  });
}

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    final screenWidth = MediaQuery.of(context).size.width;

    // Подсчитываем выполненные задачи для каждого уровня
    final completedByLevel = [0, 0, 0];
    final totalByLevel = [0, 0, 0];

    for (var task in tasks) {
      totalByLevel[task.level]++;
      if (task.isSolved) {
        completedByLevel[task.level]++;
      }
    }

    // Проверяем доступность уровней
    final isLevel1Complete =
        totalByLevel[0] > 0 && completedByLevel[0] == totalByLevel[0];
    final isLevel2Complete =
        totalByLevel[1] > 0 && completedByLevel[1] == totalByLevel[1];

    // Обновляем список уровней с реальными данными и статусом блокировки
    final levels = [
      TaskLevel(
        name: 'Новичок',
        completedTasks: completedByLevel[0],
        totalTasks: totalByLevel[0],
        levelImage: beginner_level,
        isLocked: false, // Первый уровень всегда доступен
      ),
      TaskLevel(
        name: 'Продвинутый',
        completedTasks: completedByLevel[1],
        totalTasks: totalByLevel[1],
        levelImage: advanced_level,
        isLocked:
            !isLevel1Complete, // Заблокирован, пока не пройден первый уровень
      ),
      TaskLevel(
        name: 'Профи',
        completedTasks: completedByLevel[2],
        totalTasks: totalByLevel[2],
        levelImage: pro_level,
        isLocked:
            !isLevel2Complete, // Заблокирован, пока не пройден второй уровень
      ),
    ];

    // Синхронизируем контроллер с провайдером
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index != tabIndex) {
        _tabController.animateTo(tabIndex);
      }
    });

    final filteredTasks = tasks.where((task) {
      final title = _getTaskTitle(task.details).toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
    }).toList();

    final unsolvedTasks =
        filteredTasks.where((task) => !task.isSolved).toList();
    final solvedTasks = filteredTasks.where((task) => task.isSolved).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(100),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Уровни",
                          style: TextStyle(
                            fontFamily: "Europe",
                            fontSize: big + 5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: medal,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "12",
                                        style: TextStyle(
                                          fontFamily: "Europe",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "баллов",
                                    style: TextStyle(
                                      fontFamily: "Europe",
                                      fontSize: 14,
                                      color: greyText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 40),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(width: 40),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: time_clock,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "7",
                                        style: TextStyle(
                                          fontFamily: "Europe",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "дней",
                                    style: TextStyle(
                                      fontFamily: "Europe",
                                      fontSize: 14,
                                      color: greyText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    // Новичок (слева)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: screenWidth * 0.7,
                        child: _buildLevelCard(levels[0], 0),
                      ),
                    ),
                    // Линия от Новичка к Продвинутому
                    SizedBox(
                      height: 95,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8,
                            right: 8,
                            child: SvgPicture.asset(
                              'assets/images/way1.svg',
                              width: screenWidth - 16,
                              height: 95,
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                levels[1].isLocked
                                    ? Colors.grey
                                    : Colors.yellow,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Продвинутый (справа)
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: screenWidth * 0.7,
                        child: _buildLevelCard(levels[1], 1),
                      ),
                    ),
                    // Линия от Продвинутого к Профи
                    SizedBox(
                      height: 95,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8,
                            right: 8,
                            child: SvgPicture.asset(
                              'assets/images/way2.svg',
                              width: screenWidth - 16,
                              height: 95,
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                levels[2].isLocked
                                    ? Colors.grey
                                    : Colors.grey.shade400,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Профи (слева)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: screenWidth * 0.7,
                        child: _buildLevelCard(levels[2], 2),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(TaskLevel level, int index) {
    // Определяем цвет для заблокированного состояния
    final Color lockColor = Colors.grey.shade300;
    final bool isLocked = level.isLocked;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LevelTasksPage(
                    level: level,
                    levelIndex: index,
                  ),
                ),
              );
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked ? lockColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (index != 1) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isLocked ? Colors.grey : Colors.transparent,
                          BlendMode.saturation,
                        ),
                        child: level.levelImage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              level.name,
                              style: TextStyle(
                                fontFamily: "Europe",
                                fontSize: big,
                                fontWeight: FontWeight.bold,
                                color: isLocked ? Colors.grey : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.lock,
                                color: Colors.grey, size: 20),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        level.totalTasks > 0
                            ? 'Выполнено заданий ${level.completedTasks}/${level.totalTasks}'
                            : 'Нет доступных заданий',
                        style: TextStyle(
                          fontFamily: "Europe",
                          fontSize: normal,
                          color: isLocked ? Colors.grey : Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                if (index == 1) ...[
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isLocked ? Colors.grey : Colors.transparent,
                          BlendMode.saturation,
                        ),
                        child: level.levelImage,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: level.totalTasks > 0
                    ? level.completedTasks / level.totalTasks
                    : 0,
                backgroundColor:
                    isLocked ? Colors.grey.shade200 : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLocked
                      ? Colors.grey
                      : (index == 0
                          ? yellow
                          : (index == 1 ? darkBlue : Colors.purple)),
                ),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTaskTitle(List<Map<String, String>> details) {
    for (var item in details) {
      if (item.containsKey("title")) {
        return item["title"]!;
      }
    }
    return "";
  }
}
