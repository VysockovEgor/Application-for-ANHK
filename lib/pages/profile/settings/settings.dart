import 'package:flutter/material.dart';
import '../../../design/colors.dart';
// Импортируйте страницу ProfilePage
import 'package:anhk/pages/profile/settings/succes_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
    _lineWidthAnimation =
        Tween<double>(begin: 0.0, end: _screenWidth * 0.8).animate(
      CurvedAnimation(parent: _lineAnimationController, curve: Curves.linear),
    );

    // Анимация для вылета сообщения (быстрее, чем линия)
    _messageSlideAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(
          parent: _lineAnimationController, curve: Curves.easeInOut),
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
    _lineAnimationController.duration =
        const Duration(milliseconds: 500); // Ускоряем вылет
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

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
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
        backgroundColor: darkBlue, // Цвет фона AppBar
        automaticallyImplyLeading: false, // Скрываем стандартную кнопку назад
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Белая стрелочка
          ),
          iconSize: 32,
          onPressed: () {
            Navigator.pop(context);
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
                    color: darkBlue,
                  ),
                  // Нижняя закругленная часть белого цвета
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

class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок поля ввода
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Europe',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // Поле ввода пароля с улучшенным дизайном
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _isObscured,
            style: const TextStyle(
              fontFamily: 'Europe',
              fontSize: 16,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _isFocused ? yellow : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: yellow,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(
                fontFamily: 'Europe',
                color: Colors.grey.shade400,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: _isFocused ? yellow : Colors.grey.shade400,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
