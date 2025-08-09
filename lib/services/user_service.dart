import 'api_service.dart';
import '../models/user.dart';
import 'package:logging/logging.dart';
import 'dart:convert';

class UserService {
  final _logger = Logger('UserService');
  final ApiService _api;
  static const String _profileEndpoint = '/api/user/profile';
  static const String _loginEndpoint = '/api/auth/login';
  static const String _registerEndpoint = '/api/register';
  static const String _resetPasswordEndpoint = '/api/reset-password';

  UserService(this._api);

  Future<String> login(String login, String password) async {
    _logger.info('👉 Вызов метода login');
    _logger.info('Эндпоинт: $_loginEndpoint');

    final requestBody = {
      'login': login,
      'password': password,
    };
    _logger.info('Тело запроса: ${json.encode(requestBody)}');

    final response = await _api.post(_loginEndpoint, requestBody);
    _logger.info('✅ Получен ответ от сервера');
    return response['token'] as String;
  }

  Future<User> getProfile() async {
    _logger.info('📱 Запрос профиля пользователя');
    final response = await _api.get(_profileEndpoint);
    final user = User.fromJson(response);
    _logger.info('✅ Получен профиль: $user');
    return user;
  }

  Future<void> register({
    required String login,
    required String password,
    required String email,
    required String name,
  }) async {
    await _api.post(_registerEndpoint, {
      'login': login,
      'password': password,
      'email': email,
      'name': name,
    });
  }

  Future<void> resetPassword(String email) async {
    await _api.post(_resetPasswordEndpoint, {
      'email': email,
    });
  }
}
