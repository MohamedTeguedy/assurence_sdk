class FormData {
  final List<Marque> marques;
  final List<Usage> usages;
  final List<Couverture> couvertures;

  FormData({
    required this.marques,
    required this.usages,
    required this.couvertures,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      marques: (json['marques'] as List)
          .map((marque) => Marque.fromJson(marque))
          .toList(),
      usages: (json['usages'] as List)
          .map((usage) => Usage.fromJson(usage))
          .toList(),
      couvertures: (json['couvertures'] as List)
          .map((couverture) => Couverture.fromJson(couverture))
          .toList(),
    );
  }
}

class Marque {
  final int id;
  final String nom;

  Marque({required this.id, required this.nom});

  factory Marque.fromJson(Map<String, dynamic> json) {
    return Marque(
      id: json['id'],
      nom: json['nom'],
    );
  }
}

class Usage {
  final int id;
  final String code;

  Usage({required this.id, required this.code});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      id: json['id'],
      code: json['code'],
    );
  }
}

class Couverture {
  final int id;
  final String type;
  final String typeDisplay;
  final String description;

  Couverture({
    required this.id,
    required this.type,
    required this.typeDisplay,
    required this.description,
  });

  factory Couverture.fromJson(Map<String, dynamic> json) {
    return Couverture(
      id: json['id'],
      type: json['type'],
      typeDisplay: json['type_display'],
      description: json['description'],
    );
  }
}

class Modele {
  final int id;
  final String nom;
  final int marqueId;
  final String marqueNom;

  Modele({
    required this.id,
    required this.nom,
    required this.marqueId,
    required this.marqueNom,
  });

  factory Modele.fromJson(Map<String, dynamic> json) {
    return Modele(
      id: json['id'],
      nom: json['nom'],
      marqueId: json['marque'],
      marqueNom: json['marque_nom'],
    );
  }

  @override
  String toString() {
    return 'Modele{id: $id, nom: "$nom", marque: "$marqueNom" (ID: $marqueId)}';
  }
}

List<String> get puissancesDisponibles => [
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16 et plus'
    ];
