import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/player_provider.dart';
import '../../services/spotify_api_service.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final SpotifyApiService _api = SpotifyApiService();
  final AuthService _auth = AuthService();

  Future<List<dynamic>>? _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
      if (_auth.accessToken != null) {
          setState(() {
              _recommendationsFuture = _api.getRecommendations(_auth.accessToken!);
          });
      }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final player = Provider.of<PlayerProvider>(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header / Welcome
          Text(
            l10n.welcomeMessage,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 24),

          // Connection Status / Button
          if (!player.isConnected)
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                    await player.connect();
                    _loadData(); // Retry loading data after connect
                },
                icon: const Icon(Icons.link),
                label: Text(l10n.connectToSpotify),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Daily Mix / Recommendations Section
          Text("For You", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),

          FutureBuilder<List<dynamic>>(
            future: _recommendationsFuture,
            builder: (context, snapshot) {
              if (!player.isConnected) {
                  return const Center(child: Text("Connect to load music", style: TextStyle(color: Colors.grey)));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Could not load recommendations"));
              }

              final tracks = snapshot.data ?? [];
              if (tracks.isEmpty) {
                  return const Center(child: Text("No recommendations yet. Play some music!"));
              }

              // Horizontal List for "Teen" aesthetic
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    final album = track['album'];
                    final images = album['images'] as List;
                    final imageUrl = images.isNotEmpty ? images[0]['url'] : null;

                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => player.play(track['uri']),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Album Art Card
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                     BoxShadow(color: AppTheme.neonPurple.withOpacity(0.3), blurRadius: 12, offset: const Offset(0,4))
                                  ],
                                  image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
                                  color: Colors.grey[900],
                                ),
                                child: imageUrl == null ? const Center(child: Icon(Icons.music_note, size: 50)) : null,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              track['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              (track['artists'] as List).map((a) => a['name']).join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
