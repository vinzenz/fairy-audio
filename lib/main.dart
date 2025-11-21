import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'theme.dart';
import 'providers/player_provider.dart';
import 'providers/search_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
      await dotenv.load(fileName: ".env"); // Load environment variables
  } catch(e) {
      print("Env not found, using defaults or failing gracefully.");
  }

  runApp(const FairyAudioApp());
}

class FairyAudioApp extends StatelessWidget {
  const FairyAudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'Fairy Audio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkLuxe,

        // Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('cs'), // Czech
        ],

        home: const HomeScreen(),
      ),
    );
  }
}
