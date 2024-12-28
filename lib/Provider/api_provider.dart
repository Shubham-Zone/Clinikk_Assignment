import 'package:flutter/material.dart';
import 'package:task_tracker/Models/post_model.dart';
import 'package:task_tracker/Services/api_service.dart';

class ApiProvider extends ChangeNotifier {
  String _error = '';
  bool _loading = false;
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];

  // Getters for state
  bool get loading => _loading;
  String get error => _error;
  List<Post> get posts => _filteredPosts.isEmpty ? _posts : _filteredPosts;

  Future<void> fetchAllPosts({int? userId}) async {
    try {
      _error = '';
      _loading = true;
      notifyListeners();

      // Fetch posts
      List<Post> fetchedPosts = await ApiService.fetchPosts(userId: userId);

      if (fetchedPosts.isEmpty) {
        _error = 'No data found.';
      }

      if (userId != null) {
        _filteredPosts = fetchedPosts;
      } else {
        _posts = fetchedPosts;
        _filteredPosts = [];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void filterPosts(int userId) {
    fetchAllPosts(userId: userId);
  }

  void clearFilter() {
    _filteredPosts = [];
    notifyListeners();
  }
}
