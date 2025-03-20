class Assureur {
  final int id;
  final String nom;
  final String description;
  final String imageUrl; // URL de l'image/logo de l'assureur

  Assureur({
    required this.id,
    required this.nom,
    required this.description,
    required this.imageUrl,
  });

  factory Assureur.fromMap(Map<String, dynamic> map) {
    return Assureur(
      id: map['id'],
      nom: map['nom'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
