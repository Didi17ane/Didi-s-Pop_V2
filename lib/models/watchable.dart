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

/// Statut de visionnage, façon Netflix : à voir, en cours, ou déjà vu.
enum WatchStatus { toWatch, watching, watched }

extension WatchStatusLabel on WatchStatus {
  String get label {
    switch (this) {
      case WatchStatus.toWatch:
        return 'À voir';
      case WatchStatus.watching:
        return 'En cours';
      case WatchStatus.watched:
        return 'Vu';
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
  final WatchStatus status;

  const Watchable({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.synopsis,
    this.status = WatchStatus.toWatch,
  });

  /// Retourne une copie de ce Watchable avec certains champs remplacés.
  /// Pratique pour modifier juste le statut sans retaper tous les champs.
  Watchable copyWith({
    String? id,
    String? title,
    Category? category,
    double? rating,
    String? imageUrl,
    String? synopsis,
    WatchStatus? status,
  }) {
    return Watchable(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      synopsis: synopsis ?? this.synopsis,
      status: status ?? this.status,
    );
  }

  /// Sérialisation pour la persistance locale (shared_preferences).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category.name,
        'rating': rating,
        'imageUrl': imageUrl,
        'synopsis': synopsis,
        'status': status.name,
      };

  factory Watchable.fromJson(Map<String, dynamic> json) => Watchable(
        id: json['id'] as String,
        title: json['title'] as String,
        category: Category.values.byName(json['category'] as String),
        rating: (json['rating'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        synopsis: json['synopsis'] as String,
        // Les titres ajoutés avant cette mise à jour n'ont pas ce champ
        // sauvegardé : on les considère "À voir" par défaut.
        status: json['status'] != null
            ? WatchStatus.values.byName(json['status'] as String)
            : WatchStatus.toWatch,
      );
}
