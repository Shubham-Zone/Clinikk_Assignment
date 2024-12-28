import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_tracker/Models/post_model.dart';
import 'package:task_tracker/Utils/constants.dart';

class ApiService {
  static Future<List<Post>> fetchPosts({int? userId}) async {
    try {
      String url = Constants.uri;
      if (userId != null) {
        url += '/$userId';
      }

      debugPrint("Fetching from: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          return data.map((post) => Post.fromJson(post)).toList();
        } else {
          Post post = Post.fromJson(data);
          debugPrint(post.title);
          List<Post> posts = [];
          posts.add(post);
          return posts;
        }
      } else if (response.statusCode == 404) {
        throw Exception('No data found.');
      } else {
        debugPrint(
            "Failed to fetch posts. Status code: ${response.statusCode}");
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error while fetching posts: $e");
      rethrow;
    }
  }
}
