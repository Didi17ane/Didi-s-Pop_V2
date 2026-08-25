/// Clé API TMDB (gratuite), utilisée pour retrouver automatiquement le
/// vrai poster d'un titre lors de l'ajout/modification.
///
/// Comment l'obtenir :
/// 1. Crée un compte gratuit sur https://www.themoviedb.org
/// 2. Va dans Paramètres du compte -> API -> demande une clé (usage
///    "Développeur", motif "usage personnel" suffit)
/// 3. Copie la "Clé API (v3 auth)" et colle-la ci-dessous
///
/// Tant que ce champ est vide, la recherche TMDB est simplement ignorée
/// (l'app retombe sur l'image par défaut) — rien ne plante.
const String tmdbApiKey = '8d4b79ed1832316c99cb6842a460ce6a';
