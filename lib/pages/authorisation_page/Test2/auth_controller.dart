// ignore_for_file: constant_identifier_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_service.dart';
import '../../../services/user_service.dart';

class AuthController {
  final _logger = Logger('AuthController');
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final WidgetRef ref;
  late final UserService _userService;

  AuthController(this.ref) {
    const baseUrl = kIsWeb
        ? 'http://localhost:8080' // Development proxy
        : 'http://109.172.101.13:8080';

    _logger.info('🌐 Initializing AuthController with baseUrl: $baseUrl');
    final apiService = ApiService(baseUrl: baseUrl);
    _userService = UserService(apiService);
  }

  Future<bool> tryAutoLogin() async {
    final token = await _getToken();
    if (token.isEmpty) return false;

    try {
      await _handleSuccessfulLogin(token);
      return true;
    } catch (e) {
      _logger.severe('AutoLogin error: $e');
      return false;
    }
  }

  Future<(bool, String)> login(String login, String password) async {
    try {
      _logger.info('🔐 Попытка входа в систему');
      _logger.info('📤 Отправляем запрос на /api/auth/login');

      final credentials = {
        "login": login,
        "password": password,
      };

      _logger.info('Данные запроса: ${json.encode(credentials)}');

      final token = await _userService.login(login, password);

      _logger.info('✅ Успешно получен токен авторизации');
      await _saveToken(token);
      ref.read(authTokenProvider.notifier).state = token;

      return (true, '');
    } catch (e) {
      _logger.severe('❌ Ошибка при попытке входа: $e');
      return (false, 'Ошибка авторизации: ${e.toString()}');
    }
  }

  Future<void> _handleSuccessfulLogin(String token) async {
    await _saveToken(token);
    ref.read(authTokenProvider.notifier).state = token;

    _logger.info('🔄 Загружаем профиль пользователя...');
    // Загружаем профиль пользователя
    final user = await _userService.getProfile();
    _logger.info('👤 Данные пользователя получены: ${user.toString()}');
    ref.read(userProvider.notifier).updateUser(user);
  }

  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
    _logger.info('💾 Токен сохранен в хранилище');
  }

  Future<String> _getToken() async {
    return await _secureStorage.read(key: 'token') ?? '';
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    ref.read(authTokenProvider.notifier).state = null;
    ref.read(userProvider.notifier).updateUser(
          const User(name: '', level: 0, points: 0),
        );
    _logger.info('🚪 Выполнен выход из системы');
  }
}
