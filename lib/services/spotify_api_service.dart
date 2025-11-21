import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApiService {
  final String _baseUrl = 'https://api.spotify.com/v1';

  // Headers helper
  Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Search Functionality
  // type: 'track,album' for music, 'audiobook,episode' for stories
  Future<List<dynamic>> search(String query, String token, {bool isStories = false}) async {
    if (query.isEmpty) return [];

    final type = isStories ? 'audiobook,episode' : 'track,artist';
    // Note: 'audiobook' availability depends on market. 'episode' covers podcasts.

    final url = Uri.parse('$_baseUrl/search?q=$query&type=$type&limit=20');

    final response = await http.get(url, headers: _getHeaders(token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = [];

      if (isStories) {
          if (data['audiobooks'] != null) results.addAll(data['audiobooks']['items']);
          if (data['episodes'] != null) results.addAll(data['episodes']['items']);
      } else {
          if (data['tracks'] != null) results.addAll(data['tracks']['items']);
          // We prioritize tracks for playing
      }
      return results;
    } else {
      print('Search Error: ${response.body}');
      throw Exception('Failed to search Spotify');
    }
  }

  // Get User's Saved Tracks (Favorites)
  Future<List<dynamic>> getSavedTracks(String token) async {
    final url = Uri.parse('$_baseUrl/me/tracks?limit=20');
    final response = await http.get(url, headers: _getHeaders(token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'].map((item) => item['track']).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  // Get Recommendations (Simple Logic: seeded by top tracks if available)
  Future<List<dynamic>> getRecommendations(String token) async {
     // 1. Get Top Tracks for seeds
     final seedsUrl = Uri.parse('$_baseUrl/me/top/tracks?limit=2');
     final seedsResponse = await http.get(seedsUrl, headers: _getHeaders(token));
     String seedTracks = "";

     if (seedsResponse.statusCode == 200) {
         final data = jsonDecode(seedsResponse.body);
         final items = data['items'] as List;
         if (items.isNotEmpty) {
             seedTracks = items.map((i) => i['id']).join(',');
         }
     }

     if (seedTracks.isEmpty) return []; // Can't recommend without seeds

     final recUrl = Uri.parse('$_baseUrl/recommendations?seed_tracks=$seedTracks&limit=10');
     final recResponse = await http.get(recUrl, headers: _getHeaders(token));

     if (recResponse.statusCode == 200) {
         final data = jsonDecode(recResponse.body);
         return data['tracks'];
     }
     return [];
  }
}
