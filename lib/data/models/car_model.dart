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
  final String dateDebut;
  final String dateFin;

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
    required this.dateDebut,
    required this.dateFin,
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
      "date_debut": dateDebut,
      "date_fin": dateFin,
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
      dateDebut: map['date_debut'],
      dateFin: map['date_fin'],
    );
  }

  // Convertir un objet Car en JSON
  Map<String, dynamic> toJson() => toMap();

  // Convertir un JSON en objet Car
  factory Car.fromJson(Map<String, dynamic> json) => Car.fromMap(json);

  Car copyWith({
    int? id,
    String? vin,
    String? matricule,
    String? marque,
    String? modele,
    int? annee,
    String? nomProprietaire,
    String? usage,
    String? puissance,
    int? nbrePlace,
    List<String>? typesCouverture,
    String? duree,
    String? dateDebut,
    String? dateFin,
  }) {
    return Car(
      id: id ?? this.id,
      vin: vin ?? this.vin,
      matricule: matricule ?? this.matricule,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      annee: annee ?? this.annee,
      nomProprietaire: nomProprietaire ?? this.nomProprietaire,
      usage: usage ?? this.usage,
      puissance: puissance ?? this.puissance,
      nbrePlace: nbrePlace ?? this.nbrePlace,
      typesCouverture: typesCouverture ?? this.typesCouverture,
      duree: duree ?? this.duree,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
    );
  }
}
