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
  final List<int> puissances;
  final List<int> places;

  Usage({
    required this.id,
    required this.code,
    required this.puissances,
    required this.places,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      id: json['id'],
      code: json['code'],
      puissances: List<int>.from(json['puissances']),
      places: List<int>.from(json['places']),
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

class VehiculeData {
  final List<Marque> marques;
  final List<Usage> usages;
  final List<Couverture> couvertures;

  VehiculeData({
    required this.marques,
    required this.usages,
    required this.couvertures,
  });

  factory VehiculeData.fromJson(Map<String, dynamic> json) {
    return VehiculeData(
      marques:
          List<Marque>.from(json['marques'].map((e) => Marque.fromJson(e))),
      usages: List<Usage>.from(json['usages'].map((e) => Usage.fromJson(e))),
      couvertures: List<Couverture>.from(
          json['couvertures'].map((e) => Couverture.fromJson(e))),
    );
  }
}

/// This class represents the response from the API for the duration data.
class DureeModel {
  final List<int> durees;

  DureeModel({required this.durees});

  factory DureeModel.fromJson(Map<String, dynamic> json) {
    return DureeModel(
      durees: List<int>.from(json['duree']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duree': durees,
    };
  }
}
