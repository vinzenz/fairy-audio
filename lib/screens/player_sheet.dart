import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme.dart';

class PlayerSheet extends StatelessWidget {
  const PlayerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);
    final state = player.playerState;

    if (state == null || state.track == null) return const SizedBox.shrink();

    final track = state.track!;

    // Note: We don't have the Album Art URL easily in the PlayerState directly without querying.
    // We often need to fetch the image bitmap.
    // For this concise implementation, we will stick to a sleek dark bar with text and controls.
    // If we had the metadata from a previous search context, we could pass it, but PlayerState is decoupled.

    return Container(
        height: 80,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppTheme.charcoalSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0,4))
            ],
            border: Border.all(color: Colors.white10)
        ),
        child: Row(
            children: [
                // Art Placeholder (or actual art if we implemented the bitmap fetcher)
                Container(
                    width: 64, height: 64,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white54),
                ),

                // Info
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                track.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                                track.artist.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                        ],
                    ),
                ),

                // Controls
                IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    onPressed: player.skipPrevious,
                ),
                IconButton(
                    icon: Icon(player.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 32, color: AppTheme.neonPurple),
                    onPressed: player.isPaused ? player.resume : player.pause,
                ),
                IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    onPressed: player.skipNext,
                ),
            ],
        ),
    );
  }
}
