import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models/watchable.dart';
import '../screens/root_shell.dart';
import '../screens/detail_screen.dart';
import '../screens/add_screen.dart';

/// Construit le routeur de l'app. Chaque écran reçoit directement
/// [appState] et se met à jour lui-même (via AnimatedBuilder) quand
/// l'état change — pas besoin de faire rejouer la navigation.
GoRouter buildAppRouter(AppState appState) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => RootShell(appState: appState),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) => DetailScreen(
          itemId: state.pathParameters['id']!,
          appState: appState,
        ),
      ),
      GoRoute(
        path: '/add',
        name: 'add',
        builder: (context, state) => AddScreen(appState: appState),
      ),
      GoRoute(
        path: '/edit/:id',
        name: 'edit',
        builder: (context, state) {
          // On ne fait jamais confiance à `extra` : sur certains cas
          // (rechargement web, hot-reload), Flutter le restaure comme un
          // Map JSON brut plutôt que le vrai objet Watchable, ce qui
          // provoquait un crash au cast. On va toujours chercher l'item
          // à jour dans appState par son id à la place.
          final id = state.pathParameters['id']!;
          Watchable? existing;
          for (final w in appState.items) {
            if (w.id == id) {
              existing = w;
              break;
            }
          }
          return AddScreen(appState: appState, editingItem: existing);
        },
      ),
    ],
  );
}
