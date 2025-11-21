import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import '../services/auth_service.dart';

class PlayerProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isConnected = false;
  PlayerState? _playerState;

  bool get isConnected => _isConnected;
  PlayerState? get playerState => _playerState;
  bool get isPaused => _playerState?.isPaused ?? true;

  // Connect to Spotify Remote
  Future<void> connect() async {
    bool result = await _authService.connect();
    _isConnected = result;
    if (_isConnected) {
        _subscribeToPlayerState();
    }
    notifyListeners();
  }

  void _subscribeToPlayerState() {
    SpotifySdk.subscribePlayerState().listen((state) {
      _playerState = state;
      notifyListeners();
    }, onError: (err) {
      print("Player State Error: $err");
    });
  }

  Future<void> play(String uri) async {
    try {
        await SpotifySdk.play(spotifyUri: uri);
    } catch (e) {
        print("Play Error: $e");
    }
  }

  Future<void> pause() async {
    try {
        await SpotifySdk.pause();
    } catch (e) {
        print("Pause Error: $e");
    }
  }

  Future<void> resume() async {
    try {
        await SpotifySdk.resume();
    } catch (e) {
        print("Resume Error: $e");
    }
  }

  Future<void> skipNext() async {
      await SpotifySdk.skipNext();
  }

  Future<void> skipPrevious() async {
      await SpotifySdk.skipPrevious();
  }

  // Helper to get image URL
  Future<String?> getImageUrl(ImageUri? imageUri) async {
      if (imageUri == null) return null;
      try {
          // This returns a simpler URI, usually we need to construct the URL or use the SDK to fetch the bitmap.
          // However, for simplicity in UI, we might use Web API metadata if we have it,
          // or use SpotifySdk.getImage() which returns a Uint8List.
          // For now, let's return null and rely on Web API metadata in the UI if possible,
          // or we will implement the Uint8List fetch in the UI widget.
          return imageUri.raw;
      } catch (e) {
          return null;
      }
  }
}
