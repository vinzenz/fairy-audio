import 'package:flutter/material.dart';
import '../services/spotify_api_service.dart';
import '../services/auth_service.dart';

class SearchProvider with ChangeNotifier {
  final SpotifyApiService _api = SpotifyApiService();
  final AuthService _auth = AuthService();

  bool _isStoriesMode = false;
  bool _isLoading = false;
  List<dynamic> _results = [];
  String _query = "";

  bool get isStoriesMode => _isStoriesMode;
  bool get isLoading => _isLoading;
  List<dynamic> get results => _results;
  String get query => _query;

  void toggleMode() {
    _isStoriesMode = !_isStoriesMode;
    // Clear results or re-search if query exists
    if (_query.isNotEmpty) {
      search(_query);
    } else {
      _results = [];
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    _query = query;
    if (query.isEmpty) {
        _results = [];
        notifyListeners();
        return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final token = _auth.accessToken;
      if (token != null) {
          _results = await _api.search(query, token, isStories: _isStoriesMode);
      }
    } catch (e) {
      print("Search Provider Error: $e");
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
      _query = "";
      _results = [];
      notifyListeners();
  }
}
