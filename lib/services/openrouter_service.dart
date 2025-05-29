import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterService {
  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  late final String apiKey;
  late final String model;

  OpenRouterService() {
    apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
    model = dotenv.env['OPENROUTER_MODEL'] ?? 'meta-llama/llama-4-scout:free';
  }

  Future<String> generateResponse(List<Map<String, String>> messages) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://sales-training-ai.example.com',
          'X-Title': 'Sales Training AI',
        },
        body: jsonEncode({'model': model, 'messages': messages}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return 'Sorry, I encountered an error. Please try again later.';
      }
    } catch (e) {
      print('Exception: $e');
      return 'Sorry, I encountered an error. Please try again later.';
    }
  }
}
