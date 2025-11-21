import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/search_provider.dart';
import '../../providers/player_provider.dart';
import '../../theme.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchProvider = Provider.of<SearchProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final activeColor = searchProvider.isStoriesMode ? AppTheme.neonOrange : AppTheme.neonPurple;

    return SafeArea(
      child: Column(
        children: [
          // Header & Toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Custom Toggle Switch
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalSurface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      _buildToggleOption(
                        context,
                        title: l10n.toggleMusic,
                        isSelected: !searchProvider.isStoriesMode,
                        color: AppTheme.neonPurple,
                        onTap: () {
                             if(searchProvider.isStoriesMode) searchProvider.toggleMode();
                        },
                      ),
                      _buildToggleOption(
                        context,
                        title: l10n.toggleStories,
                        isSelected: searchProvider.isStoriesMode,
                        color: AppTheme.neonOrange,
                        onTap: () {
                            if(!searchProvider.isStoriesMode) searchProvider.toggleMode();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: searchProvider.isStoriesMode
                        ? l10n.searchPlaceholderStories
                        : l10n.searchPlaceholderMusic,
                    prefixIcon: Icon(Icons.search, color: activeColor),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                          _controller.clear();
                          searchProvider.clear();
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(16),
                       borderSide: BorderSide(color: activeColor, width: 1.5),
                    ),
                  ),
                  onSubmitted: (val) => searchProvider.search(val),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: searchProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: searchProvider.results.length,
                    itemBuilder: (context, index) {
                      final item = searchProvider.results[index];
                      final name = item['name'];
                      // Handle different object structures for tracks vs audiobooks
                      String subtitle = "";
                      String? imageUrl;
                      String uri = item['uri'];

                      if (item['type'] == 'track') {
                          subtitle = (item['artists'] as List).map((a) => a['name']).join(', ');
                          final images = item['album']['images'] as List;
                          if (images.isNotEmpty) imageUrl = images[0]['url'];
                      } else if (item['type'] == 'audiobook') {
                          subtitle = (item['authors'] as List).map((a) => a['name']).join(', ');
                          final images = item['images'] as List;
                          if (images.isNotEmpty) imageUrl = images[0]['url'];
                      } else if (item['type'] == 'episode') {
                           // Podcast episode
                           if (item['images'] != null && (item['images'] as List).isNotEmpty) {
                               imageUrl = item['images'][0]['url'];
                           }
                           subtitle = item['description'] ?? "";
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: Container(
                             width: 56, height: 56,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
                               color: Colors.grey[800]
                             ),
                             child: imageUrl == null ? const Icon(Icons.audiotrack) : null,
                          ),
                          title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                             icon: Icon(Icons.play_circle_fill, color: activeColor, size: 32),
                             onPressed: () {
                                 playerProvider.play(uri);
                             },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(BuildContext context, {
    required String title,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
