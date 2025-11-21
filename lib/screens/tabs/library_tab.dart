import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/spotify_api_service.dart';
import '../../services/auth_service.dart';
import '../../providers/player_provider.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  final SpotifyApiService _api = SpotifyApiService();
  final AuthService _auth = AuthService();

  Future<List<dynamic>>? _libraryFuture;

  @override
  void initState() {
    super.initState();
    if (_auth.accessToken != null) {
        _libraryFuture = _api.getSavedTracks(_auth.accessToken!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final player = Provider.of<PlayerProvider>(context, listen: false);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: Text(l10n.libraryFavorites, style: Theme.of(context).textTheme.headlineMedium),
           ),

           Expanded(
             child: FutureBuilder<List<dynamic>>(
                future: _libraryFuture,
                builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                   }
                   if (snapshot.hasError || !snapshot.hasData) {
                       return const Center(child: Text("Nothing here yet."));
                   }

                   final tracks = snapshot.data!;
                   return GridView.builder(
                       padding: const EdgeInsets.all(16),
                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 2,
                           childAspectRatio: 0.75,
                           crossAxisSpacing: 16,
                           mainAxisSpacing: 16,
                       ),
                       itemCount: tracks.length,
                       itemBuilder: (context, index) {
                           final track = tracks[index];
                           final images = track['album']['images'] as List;
                           final imageUrl = images.isNotEmpty ? images[0]['url'] : null;

                           return GestureDetector(
                             onTap: () => player.play(track['uri']),
                             child: Container(
                               decoration: BoxDecoration(
                                   color: Theme.of(context).cardColor,
                                   borderRadius: BorderRadius.circular(20),
                               ),
                               child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                                   children: [
                                       Expanded(
                                           child: Container(
                                               decoration: BoxDecoration(
                                                   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                                   image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
                                                   color: Colors.grey[800],
                                               ),
                                               child: imageUrl == null ? const Center(child: Icon(Icons.music_note, size: 40)) : null,
                                           ),
                                       ),
                                       Padding(
                                           padding: const EdgeInsets.all(12.0),
                                           child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                   Text(track['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                   const SizedBox(height: 4),
                                                   Text((track['artists'] as List).map((a) => a['name']).join(', '), maxLines: 1, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                               ],
                                           ),
                                       ),
                                   ],
                               ),
                             ),
                           );
                       },
                   );
                },
             ),
           ),
        ],
      ),
    );
  }
}
