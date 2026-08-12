import 'package:flutter/material.dart';
import 'app_state.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DidisPopApp());
}

class DidisPopApp extends StatefulWidget {
  const DidisPopApp({super.key});

  @override
  State<DidisPopApp> createState() => _DidisPopAppState();
}

class _DidisPopAppState extends State<DidisPopApp> {
  final AppState _appState = AppState();
  late final router = buildAppRouter(_appState);

  // Durée minimale d'affichage du splash, même si le chargement des
  // données est plus rapide (comme Snapchat/WhatsApp au démarrage).
  bool _minSplashDurationElapsed = false;

  @override
  void initState() {
    super.initState();
    _appState.load();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _minSplashDurationElapsed = true);
    });
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder reconstruit immédiatement dès que l'état change
    // (thème, prénom, liste...) : pas de délai, pas de double rebuild.
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        final showSplash = !_appState.isLoaded || !_minSplashDurationElapsed;

        if (showSplash) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }

        return MaterialApp.router(
          title: "Didi's Pop",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _appState.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}

/// Écran affiché au démarrage (durée fixe, cf. _minSplashDurationElapsed
/// dans _DidisPopAppState) : juste le logo, plein écran, comme
/// Snapchat/WhatsApp. Le fond rose est le même que le splash natif Android
/// (voir android/app/src/main/res/drawable/launch_background.xml) pour
/// qu'il n'y ait aucune coupure visible entre les deux.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDF0EE),
      body: Center(
        child: Image(
          image: AssetImage('assets/icon/app_icon.png'),
          width: 160,
          height: 160,
        ),
      ),
    );
  }
}
