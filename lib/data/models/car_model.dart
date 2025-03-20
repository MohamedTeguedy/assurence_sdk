class Car {
  final int? id;
  final String vin;
  final String matricule;
  final String marque;
  final String modele;
  final int annee;
  final String nomProprietaire;
  final String usage;
  final String puissance;
  final int nbrePlace;
  final List<String> typesCouverture;
  final String duree;

  Car({
    this.id,
    required this.vin,
    required this.matricule,
    required this.marque,
    required this.modele,
    required this.annee,
    required this.nomProprietaire,
    required this.usage,
    required this.puissance,
    required this.nbrePlace,
    required this.typesCouverture,
    required this.duree,
  });

  // Convertir un objet Car en Map (pour la base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vin': vin,
      'matricule': matricule,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'nom_proprietaire': nomProprietaire,
      'usage': usage,
      'puissance': puissance,
      'nbre_place': nbrePlace,
      'types_couverture': typesCouverture.join(','),
      'durée': duree,
    };
  }

  // Convertir un Map en objet Car (depuis la base de données)
  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      vin: map['vin'],
      matricule: map['matricule'],
      marque: map['marque'],
      modele: map['modele'],
      annee: map['annee'],
      nomProprietaire: map['nom_proprietaire'],
      usage: map['usage'],
      puissance: map['puissance'],
      nbrePlace: map['nbre_place'],
      typesCouverture: (map['types_couverture'] as String).split(','),
      duree: map['durée'],
    );
  }

  // Convertir un objet Car en JSON
  Map<String, dynamic> toJson() => toMap();

  // Convertir un JSON en objet Car
  factory Car.fromJson(Map<String, dynamic> json) => Car.fromMap(json);
}
