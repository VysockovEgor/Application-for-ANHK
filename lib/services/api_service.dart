import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class ApiService {
  final _logger = Logger('ApiService');
  final String baseUrl;
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ApiService({required this.baseUrl}) {
    _logger.info('🌐 API Service initialized with base URL: $baseUrl');
  }

  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
    _logger.info('🔑 Auth token set in headers');
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    _logger.info('📡 GET request to: $url');
    _logger.info('Request headers: $_headers');

    try {
      final response = await http.get(
        url,
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      _logger.severe('❌ GET $endpoint error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    // Подробное логирование запроса
    _logger.info('⬆️ ОТПРАВЛЯЕМ ЗАПРОС:');
    _logger.info('URL: $url');
    _logger.info('Метод: POST');
    _logger.info('Заголовки: $_headers');
    _logger.info('Тело запроса: ${json.encode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: _headers,
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10));

      // Подробное логирование ответа
      _logger.info('\n⬇️ ПОЛУЧЕН ОТВЕТ:');
      _logger.info('Статус: ${response.statusCode}');
      _logger.info('Заголовки ответа: ${response.headers}');
      _logger.info('Тело ответа: ${response.body}');

      return _handleResponse(response);
    } catch (e, stackTrace) {
      _logger.severe('❌ Ошибка при выполнении запроса:');
      _logger.severe('$e');
      _logger.severe('Stack trace: $stackTrace');
      if (e is http.ClientException) {
        _logger.severe('Детали ошибки клиента: ${e.message}');
      }
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.trim().startsWith('<!DOCTYPE html>')) {
          _logger.severe('❌ ОШИБКА: Получен HTML вместо JSON');
          _logger.severe('Содержимое ответа:');
          _logger.severe(response.body);
          throw ApiException(
            statusCode: response.statusCode,
            message:
                'Получен HTML вместо JSON. Проверьте правильность URL и эндпоинта.',
          );
        }

        final decoded = json.decode(utf8.decode(response.bodyBytes));
        _logger.info('✅ JSON успешно декодирован:');
        _logger.info(json.encode(decoded));
        return decoded;
      } catch (e) {
        _logger.severe('❌ ОШИБКА при парсинге ответа:');
        _logger.severe('Тип ошибки: ${e.runtimeType}');
        _logger.severe('Сообщение: $e');
        _logger.severe('Content-Type: ${response.headers['content-type']}');
        _logger.severe('Тело ответа:');
        _logger.severe(response.body);
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Ошибка при парсинге ответа: ${e.toString()}',
        );
      }
    } else {
      _logger.severe('❌ ОШИБКА HTTP ${response.statusCode}');
      _logger.severe('Тело ответа:');
      _logger.severe(response.body);
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
