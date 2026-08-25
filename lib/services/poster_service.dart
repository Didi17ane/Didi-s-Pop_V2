import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/tmdb_config.dart';

/// Recherche automatiquement une vraie affiche pour un titre donné.
/// - Pour la catégorie "anime" : API Jikan (MyAnimeList), gratuite, sans clé.
/// - Pour tout le reste (K-drama, catégories personnalisées...) : TMDB,
///   qui couvre bien séries et films, mais nécessite une clé API gratuite
///   (voir lib/config/tmdb_config.dart).
///
/// Retourne `null` si rien n'est trouvé ou en cas d'erreur réseau —
/// l'écran appelant retombe alors sur l'image par défaut actuelle.
class PosterService {
  static Future<String?> fetchPosterFor({
    required String title,
    required String categoryId,
  }) async {
    if (title.trim().isEmpty) return null;

    try {
      if (categoryId == 'anime') {
        final fromJikan = await _fetchFromJikan(title);
        if (fromJikan != null) return fromJikan;
      }
      // Pour les autres catégories (et en repli pour l'anime si Jikan n'a
      // rien trouvé), on tente TMDB.
      return await _fetchFromTmdb(title);
    } catch (_) {
      // Erreur réseau, API indisponible, timeout... on ne bloque jamais
      // l'ajout d'un titre pour ça.
      return null;
    }
  }

  static Future<String?> _fetchFromJikan(String title) async {
    final uri = Uri.parse(
      'https://api.jikan.moe/v4/anime?q=${Uri.encodeQueryComponent(title)}&limit=1',
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) return null;

    final images = data.first['images'] as Map<String, dynamic>?;
    final jpg = images?['jpg'] as Map<String, dynamic>?;
    return (jpg?['large_image_url'] ?? jpg?['image_url']) as String?;
  }

  static Future<String?> _fetchFromTmdb(String title) async {
    if (tmdbApiKey.isEmpty) return null;

    final uri = Uri.parse(
      'https://api.themoviedb.org/3/search/multi'
      '?api_key=$tmdbApiKey'
      '&query=${Uri.encodeQueryComponent(title)}'
      '&include_adult=false&language=fr-FR',
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>?;
    if (results == null) return null;

    for (final r in results) {
      final map = r as Map<String, dynamic>;
      final mediaType = map['media_type'] as String?;
      final posterPath = map['poster_path'] as String?;
      // On ignore les résultats "person" (acteurs/actrices) et ceux sans
      // affiche disponible.
      if ((mediaType == 'tv' || mediaType == 'movie') &&
          posterPath != null) {
        return 'https://image.tmdb.org/t/p/w500$posterPath';
      }
    }
    return null;
  }
}
