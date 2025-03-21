import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main_page/menu_page.dart';
import '../../design/colors.dart';
import '../../design/images.dart';
import 'providers.dart';

const String BASE_URL = "https://tgrj0i-37-29-92-61.ru.tuna.am";
const String LOGIN_URL = "$BASE_URL/api/login";

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'tuna-skip-browser-warning': 'true',
  };

  @override
  void initState() {
    super.initState();
    _tryAutoLogin();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _tryAutoLogin() async {
    final tokens = await _getTokens();
    final accessToken = tokens['access_token'] ?? '';
    print("AutoLogin: найден токен: $accessToken");
    if (accessToken.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(LOGIN_URL),
          headers: _headers,
          body: json.encode({'access_token': accessToken}),
        );
        final decodedResponse = utf8.decode(response.bodyBytes);
        print("AutoLogin: ответ ${response.statusCode} - $decodedResponse");

        if (response.statusCode == 200) {
          final tokenParts = accessToken.split('_');
          if (tokenParts.isNotEmpty && tokenParts.last == 'admin') {
            ref.read(isAdminProvider.notifier).state = true;
            _showError('Администратор успешно вошел!');
          }
          _navigateToHome();
        }
      } catch (e) {
        print("AutoLogin: исключение $e");
      }
    }
  }

  Future<void> _onLoginPressed() async {
    final login = _loginController.text;
    final password = _passwordController.text;

    if (login.isEmpty || password.isEmpty) {
      _showError('Пожалуйста, заполните все поля');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(LOGIN_URL),
        headers: _headers,
        body: json.encode({'login': login, 'password': password}),
      );
      print("Login: ответ ${response.statusCode} - ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Login: полученные данные $data");
        await _saveTokens(data['access_token']);

        final tokenParts = data['access_token'].split('_');
        if (tokenParts.isNotEmpty && tokenParts.last == 'admin') {
          ref.read(isAdminProvider.notifier).state = true;
          _showError('Администратор успешно вошел!');
        }
        _navigateToHome();
      } else if (response.statusCode == 401) {
        _showError('Неверный логин или пароль');
      } else {
        _showError('Ошибка авторизации');
      }
    } catch (e) {
      _showError('Ошибка соединения. Попробуйте позже.');
      print("Login: исключение $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveTokens(String accessToken) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
  }

  Future<Map<String, String>> _getTokens() async {
    final accessToken = await _secureStorage.read(key: 'access_token') ?? '';
    return {
      'access_token': accessToken,
    };
  }


  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
    );
  }


  void _showError(String message) {
    print("showError: получено сообщение: $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.red)),
        backgroundColor: Colors.white,
      ),
    );
  }


  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 195,
              width: double.infinity,
              child: CustomPaint(
                painter: TriangleAppBarPainter(),
                child: Center(child: logo),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: Text(
                      "Авторизация",
                      style: TextStyle(fontFamily: "Europe", fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text("Логин", style: TextStyle(fontFamily: "Europe")),
                  ),
                  TextField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      hintText: 'Логин',
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Europe'),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text("Пароль", style: TextStyle(fontFamily: "Europe")),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Europe'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: black,
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      textStyle: const TextStyle(fontSize: 16, fontFamily: 'Europe'),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Вход'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Кастомный AppBar с треугольной формой
class TriangleAppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlack = Paint()..color = black;
    final pathBlack = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height + 45)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(pathBlack, paintBlack);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final shadowPath = Path()
      ..moveTo(0, size.height + 40)
      ..lineTo(size.width / 2, size.height + 85)
      ..lineTo(size.width, size.height + 40);
    canvas.drawPath(shadowPath, shadowPaint);

    final paintYellow = Paint()..color = yellow;
    final pathYellow = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, size.height + 45)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height + 40)
      ..lineTo(size.width / 2, size.height + 85)
      ..lineTo(0, size.height + 40);
    canvas.drawPath(pathYellow, paintYellow);

    final paintWhite = Paint()..color = white;
    final pathWhite = Path()
      ..moveTo(30, 0)
      ..lineTo(size.width - 30, 0)
      ..lineTo(size.width - 30, size.height - 40)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(30, size.height - 40)
      ..close();
    canvas.drawPath(pathWhite, paintWhite);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
