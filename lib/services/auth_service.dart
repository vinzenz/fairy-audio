import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String _clientId = dotenv.env['CLIENT_ID'] ?? '';
  static final String _redirectUrl = dotenv.env['REDIRECT_URL'] ?? '';

  String? _accessToken;
  String? get accessToken => _accessToken;

  Future<bool> connect() async {
    try {
      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: _clientId,
        redirectUrl: _redirectUrl,
        accessToken: _accessToken, // Optional, can be null
      );

      if (result) {
         // Once connected, we need to get the Access Token to use the Web API.
         // Spotify SDK's getAccessToken returns a string token.
         try {
             _accessToken = await SpotifySdk.getAccessToken(
                clientId: _clientId,
                redirectUrl: _redirectUrl,
                scope: 'app-remote-control,user-modify-playback-state,playlist-read-private,user-library-read,user-read-recently-played,user-top-read',
             );
             return true;
         } catch (e) {
             print('Error getting access token: $e');
             return false;
         }
      }
      return false;
    } on PlatformException catch (e) {
      print('Status: ${e.code}, Message: ${e.message}');
      return false;
    } on MissingPluginException {
      print('Spotify SDK not implemented on this platform');
      return false;
    }
  }

  Future<void> disconnect() async {
      try {
        await SpotifySdk.disconnect();
        _accessToken = null;
      } catch(e){
          print("Error disconnecting: $e");
      }
  }
}
