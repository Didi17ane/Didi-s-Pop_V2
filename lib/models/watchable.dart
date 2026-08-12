enum Category { kdrama, anime }

extension CategoryLabel on Category {
  String get label {
    switch (this) {
      case Category.kdrama:
        return 'K-drama';
      case Category.anime:
        return 'Anime';
    }
  }
}

class Watchable {
  final String id;
  final String title;
  final Category category;
  final double rating; // 0 à 10
  final String imageUrl;
  final String synopsis;

  const Watchable({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.synopsis,
  });

  /// Sérialisation pour la persistance locale (shared_preferences).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category.name,
        'rating': rating,
        'imageUrl': imageUrl,
        'synopsis': synopsis,
      };

  factory Watchable.fromJson(Map<String, dynamic> json) => Watchable(
        id: json['id'] as String,
        title: json['title'] as String,
        category: Category.values.byName(json['category'] as String),
        rating: (json['rating'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        synopsis: json['synopsis'] as String,
      );
}
