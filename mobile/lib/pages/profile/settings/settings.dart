import 'package:flutter/material.dart';
import '../../../design/colors.dart';
import '../../../design/images.dart';
import 'package:anhk/pages/profile/profile_page.dart';  // Импортируйте страницу ProfilePage
import 'package:anhk/pages/profile/settings/succes_page.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late AnimationController _lineAnimationController;
  late Animation<double> _lineWidthAnimation;
  late Animation<Offset> _messageSlideAnimation;
  double _screenWidth = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Получаем ширину экрана через MediaQuery
    _screenWidth = MediaQuery.of(context).size.width;

    // Инициализация анимаций
    _lineAnimationController = AnimationController(
      duration: const Duration(seconds: 3), // Время для линии
      vsync: this,
    );

    // Инвертируем анимацию ширины линии, чтобы она двигалась слева направо
    _lineWidthAnimation = Tween<double>(begin: 0.0, end: _screenWidth * 0.8).animate(
      CurvedAnimation(parent: _lineAnimationController, curve: Curves.linear),
    );

    // Анимация для вылета сообщения (быстрее, чем линия)
    _messageSlideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(parent: _lineAnimationController, curve: Curves.easeInOut),
    );
  }

  void _showSnackBar(String message) {
    // Добавляем новый слой на экран
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: _messageSlideAnimation,
            child: Container(
              padding: const EdgeInsets.all(12),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  // Анимация белой линии
                  AnimatedBuilder(
                    animation: _lineAnimationController,
                    builder: (context, child) {
                      return Container(
                        width: _lineWidthAnimation.value,
                        height: 3,
                        color: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Добавляем сообщение в Overlay
    overlay.insert(overlayEntry);

    // Запуск анимации для вылета предупреждения (делаем его быстрее)
    _lineAnimationController.duration = const Duration(milliseconds: 500); // Ускоряем вылет
    _lineAnimationController.forward();

    // Запускаем анимацию белой линии после задержки в 500 миллисекунд (когда предупреждение уже на экране)
    Future.delayed(const Duration(milliseconds: 500), () {
      _lineAnimationController.forward(); // Начинаем анимацию линии
    });

    // Убираем сообщение через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      // Начинаем анимацию для исчезновения с такой же скоростью
      _lineAnimationController.reverse();
      Future.delayed(const Duration(milliseconds: 1000), () {
        overlayEntry.remove(); // Убираем сообщение из Overlay
      });
    });
  }

  void _submitForm() {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Пожалуйста, заполните все поля');
    } else if (newPassword != confirmPassword) {
      _showSnackBar('Новый пароль и подтверждение пароля не совпадают');
    } else {
      // Если все в порядке, переходим на страницу успеха
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuccesPage()),
      );
    }
  }

  @override
  void dispose() {
    _lineAnimationController.dispose(); // Освобождаем ресурсы
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark_blue, // Цвет фона AppBar
        automaticallyImplyLeading: false, // Скрываем стандартную кнопку назад
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,  // Белая стрелочка
          ),
          iconSize: 32,
          onPressed: () {
            // Переход на страницу ProfilePage при нажатии на стрелочку
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),  // Переход на страницу ProfilePage
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Верхняя часть с синим фоном и логотипом
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 70,
                    width: double.infinity,
                    color: dark_blue,
                  ),
                  // Нижняя закругленная часть белого цвета
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
              const SizedBox(height: 80),
              // Заголовок "Смена пароля" по центру
              const Text(
                "Смена пароля",
                style: TextStyle(
                  fontFamily: 'Europe',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Поля ввода для паролей
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PasswordField(
                  label: "Текущий пароль",
                  controller: _currentPasswordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PasswordField(
                  label: "Новый пароль",
                  controller: _newPasswordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PasswordField(
                  label: "Подтвердить пароль",
                  controller: _confirmPasswordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: black,
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    textStyle:
                    const TextStyle(fontSize: 16, fontFamily: 'Europe'),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Отправить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const PasswordField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок поля ввода
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Europe',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Поле ввода пароля с закругленными углами и иконкой для показа/скрытия символов
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: const Icon(Icons.visibility_off),
          ),
          style: const TextStyle(fontFamily: 'Europe'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
