import '../models/assureur_model.dart';

class AssureurService {
  // Exemple de liste statique d'assureurs avec des images
  Future<List<Assureur>> getAssureurs() async {
    await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
    return [
      Assureur(
        id: 1,
        nom: 'mar',
        description: 'Description A',
        imageUrl:
            'https://logodix.com/logo/1931259.png', // Remplacez par une URL réelle
      ),
      Assureur(
        id: 2,
        nom: 'Assureur B',
        description: 'Description B',
        imageUrl: 'https://logodix.com/logo/1931259.png',
      ),
      Assureur(
        id: 3,
        nom: 'Assureur C',
        description: 'Description C',
        imageUrl: 'https://logodix.com/logo/1931259.png',
      ),
    ];
  }
}
