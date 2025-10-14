import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:1234/v1/chat/completions';
  static const String model = 'qwen2.5-0.5b-instruct';

  static Future<String> sendMessage(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'model': model, 'messages': messages, 'stream': false}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to connect: ${response.statusCode}');
    }
  }
}
