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
        builder: (context, state) {
          // On récupère l'objet complet passé en `extra` (plus simple pour
          // une débutante que de re-fetch par id depuis une source distante).
          final item = state.extra as Watchable? ??
              appState.items.firstWhere(
                (w) => w.id == state.pathParameters['id'],
                orElse: () => appState.items.first,
              );
          return DetailScreen(item: item, appState: appState);
        },
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
          final item = state.extra as Watchable? ??
              appState.items.firstWhere(
                (w) => w.id == state.pathParameters['id'],
                orElse: () => appState.items.first,
              );
          return AddScreen(appState: appState, editingItem: item);
        },
      ),
    ],
  );
}
