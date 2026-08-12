import '../models/watchable.dart';

/// Source de données locale pour la démo.
/// Les widgets ne contiennent jamais ces valeurs en dur : ils les reçoivent
/// via ce repository / le state géré dans HomeScreen.
class SampleData {
  static List<Watchable> initialList() {
    return [
      const Watchable(
        id: '1',
        title: 'Crash Landing on You',
        category: Category.kdrama,
        rating: 9.1,
        imageUrl: 'https://picsum.photos/seed/cloy/300/420',
        synopsis:
            'Une héritière sud-coréenne atterrit accidentellement en Corée du Nord '
            'lors d\'un accident de parapente et tombe amoureuse d\'un officier.',
      ),
      const Watchable(
        id: '2',
        title: 'Demon Slayer',
        category: Category.anime,
        rating: 8.9,
        imageUrl: 'https://picsum.photos/seed/demonslayer/300/420',
        synopsis:
            'Tanjiro part à la recherche d\'un remède pour sa sœur transformée '
            'en démon, tout en combattant des créatures maléfiques.',
      ),
      const Watchable(
        id: '3',
        title: 'Goblin',
        category: Category.kdrama,
        rating: 8.7,
        imageUrl: 'https://picsum.photos/seed/goblin/300/420',
        synopsis:
            'Un gobelin immortel cherche une mariée humaine capable de mettre '
            'fin à sa vie éternelle et douloureuse.',
      ),
      const Watchable(
        id: '4',
        title: 'Attack on Titan',
        category: Category.anime,
        rating: 9.0,
        imageUrl: 'https://picsum.photos/seed/aot/300/420',
        synopsis:
            'L\'humanité survit derrière des murs pour se protéger de titans '
            'géants dévoreurs d\'hommes.',
      ),
      const Watchable(
        id: '5',
        title: 'Itaewon Class',
        category: Category.kdrama,
        rating: 8.5,
        imageUrl: 'https://picsum.photos/seed/itaewon/300/420',
        synopsis:
            'Un jeune homme ouvre un bar-restaurant à Itaewon pour se venger '
            'd\'un puissant groupe de restauration.',
      ),
      const Watchable(
        id: '6',
        title: 'Your Name',
        category: Category.anime,
        rating: 9.3,
        imageUrl: 'https://picsum.photos/seed/yourname/300/420',
        synopsis:
            'Deux adolescents échangent mystérieusement leurs corps et '
            'tentent de se retrouver à travers le temps.',
      ),
    ];
  }
}
