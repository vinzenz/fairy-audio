import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/auth_service.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
           Text(l10n.tabSettings, style: Theme.of(context).textTheme.headlineMedium),
           const SizedBox(height: 32),

           // Parent Mode Placeholder
           Card(
               child: ListTile(
                   leading: const Icon(Icons.lock_outline, color: Colors.orange),
                   title: Text(l10n.parentModeTitle),
                   subtitle: Text(l10n.parentModeComingSoon),
                   trailing: const Icon(Icons.chevron_right),
               ),
           ),

           const SizedBox(height: 16),

           ElevatedButton(
               style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.8)),
               onPressed: () async {
                   await AuthService().disconnect();
               },
               child: const Text("Disconnect Spotify"),
           ),
        ],
      ),
    );
  }
}
