import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Для эмулятора Android
  static String? authToken;

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  }

  // Метод для отправки SMS
  static Future<void> requestSms(String phone) async {
    await post('/auth/request-sms', {'phone': phone});
  }

  // Метод для верификации SMS
  static Future<void> verifySms(String phone, String code) async {
    final response = await post('/auth/verify-sms', {
      'phone': phone,
      'code': code,
    });
    authToken = response['access_token'];
  }

  // Метод для создания заказа
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    return await post('/orders/', orderData);
  }

  // Метод для получения списка ПВЗ
  static Future<List<dynamic>> getPvzList() async {
    final response = await get('/pvz/');
    return List<dynamic>.from(response);
  }

  // Метод для получения списка сервисов
  static Future<List<dynamic>> getServices() async {
    final response = await get('/services/');
    return List<dynamic>.from(response);
  }
}