import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post_model.dart';

class PostRepository {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> fetchPostDetails(int postId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post details');
    }
  }
}
