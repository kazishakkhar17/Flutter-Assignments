import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class HackerNewsApi {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0';

  static Future<List<int>> fetchStoryIds(String type) async {
    final url = '$_baseUrl/$type.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return [];
    return (jsonDecode(response.body) as List).cast<int>();
  }

  static Future<Story?> fetchStoryById(int id) async {
    final url = '$_baseUrl/item/$id.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200 || response.body.isEmpty) return null;
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>?;
    if (jsonData == null) return null;
    return Story.fromJson(jsonData);
  }

  // Fetch comment text by ID
  static Future<String?> fetchCommentText(int id) async {
    final url = '$_baseUrl/item/$id.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200 || response.body.isEmpty) return null;
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>?;
    return jsonData?['text'] as String?;
  }
}
