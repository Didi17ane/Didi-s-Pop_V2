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
  final String categoryId; // référence à AppCategory.id
  final double rating; // 0 à 10
  final String imageUrl;
  final String synopsis;
  final WatchStatus status;

  const Watchable({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.rating,
    required this.imageUrl,
    required this.synopsis,
    this.status = WatchStatus.toWatch,
  });

  /// Retourne une copie de ce Watchable avec certains champs remplacés.
  Watchable copyWith({
    String? id,
    String? title,
    String? categoryId,
    double? rating,
    String? imageUrl,
    String? synopsis,
    WatchStatus? status,
  }) {
    return Watchable(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      synopsis: synopsis ?? this.synopsis,
      status: status ?? this.status,
    );
  }

  /// Sérialisation pour la persistance locale (shared_preferences).
  /// La clé JSON reste 'category' (et non 'categoryId') pour rester
  /// compatible avec les titres déjà enregistrés avant cette mise à jour.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': categoryId,
        'rating': rating,
        'imageUrl': imageUrl,
        'synopsis': synopsis,
        'status': status.name,
      };

  factory Watchable.fromJson(Map<String, dynamic> json) => Watchable(
        id: json['id'] as String,
        title: json['title'] as String,
        categoryId: json['category'] as String,
        rating: (json['rating'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        synopsis: json['synopsis'] as String,
        status: json['status'] != null
            ? WatchStatus.values.byName(json['status'] as String)
            : WatchStatus.toWatch,
      );
}
