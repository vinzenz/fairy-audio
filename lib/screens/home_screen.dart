import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';
import '../providers/player_provider.dart';
import 'tabs/home_tab.dart';
import 'tabs/search_tab.dart';
import 'tabs/library_tab.dart';
import 'tabs/settings_tab.dart';
import 'player_sheet.dart'; // We'll create this

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const SearchTab(),
    const LibraryTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final player = Provider.of<PlayerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Main Tab Content
          IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),

          // Mini Player (if connected and playing/paused)
          if (player.isConnected)
             Positioned(
                 left: 0, right: 0, bottom: 0,
                 child: PlayerSheet(), // The persistent player bar
             ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: l10n.tabHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_rounded),
            label: l10n.tabSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_music_rounded),
            label: l10n.tabLibrary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
