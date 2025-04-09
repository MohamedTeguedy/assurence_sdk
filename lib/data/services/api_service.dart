import '../models/assureur_model.dart';
import '../models/car_model.dart';
import '../models/form_data_model.dart';
// import 'package:http/http.dart' as http;
import '../../presentation/customs/http_0.13.6/http.dart' as http;
import 'dart:convert';

class FormDataService {
  // final String baseUrl = 'http://192.168.1.107:8000';
  final String baseUrl = 'http://172.20.10.2:8000';

//fetchFormData
  Future<FormData> fetchFormData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/form-data/'),
      headers: {'Accept-Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      return FormData.fromJson(
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load form data');
    }
  }

//fetchModelesByMarque
  Future<List<Modele>> fetchModelesByMarque(int marqueId) async {
    print('🟡 Chargement des modèles pour marque ID: $marqueId');
    final url = Uri.parse('$baseUrl/form-data/$marqueId/');
    print('🔵 URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {'Accept-Charset': 'utf-8'},
      );
      print('🟢 Réponse reçue - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final modeles = (data['modeles'] as List)
            .map((modele) => Modele.fromJson(modele))
            .toList();

        // Debug détaillé
        print('📦 Modèles chargés (${modeles.length}):');
        for (final modele in modeles) {
          print('   - ${modele.toString()}');
        }

        return modeles;
      } else {
        print('🔴 Erreur HTTP: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception(
            'Échec du chargement des modèles. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
      rethrow;
    }
  }

//   Future<int> addCarandAssurence(Car car) async {
//     final url = Uri.parse('$baseUrl/assurance/generer/');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: json.encode(car.toMap()), // Utilisation de toApiMap()
//     );

//     if (response.statusCode == 201) {
//       final responseData = json.decode(response.body);
//       return responseData['id'] as int;
//     } else {
//       throw HttpException(
//         'Failed to add car: ${response.statusCode}',
//         statusCode: response.statusCode,
//       );
//     }
//   }
// }

// class HttpException implements Exception {
//   final String message;
//   final int statusCode;

//   HttpException(this.message, {this.statusCode = 500});

//   @override
//   String toString() {
//     return 'HttpException: $message (Status: $statusCode)';
//   }
// }

  // Future<void> addCar(Car car) async {
  //   final url = Uri.parse('$baseUrl/assurance/generer/');

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode({
  //       'vin': car.vin,
  //       'matricule': car.matricule,
  //       'marque': car.marque,
  //       'modele': car.modele,
  //       'annee': car.annee,
  //       'nom_proprietaire': car.nomProprietaire,
  //       'usage': car.usage,
  //       'puissance': car.puissance,
  //       'nbre_place': car.nbrePlace,
  //       'types_couverture': car.typesCouverture.join(','),
  //       'durée': car.duree,
  //       'date_debut': car.dateDebut.toIso8601String(),
  //       'date_fin': car.dateFin.toIso8601String(),
  //     }),
  //   );

  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to add car: ${response.statusCode}');
  //   }
  // }

//   Future<http.Response> addCar(Car car, Assureur assureur) async {
//     final url = Uri.parse('$baseUrl/assurance/generer/');

//     // Création de l'objet à envoyer
//     final requestBody = {
//       'key_entreprise': assureur.nom,
//       'vin': car.vin,
//       'matricule': car.matricule,
//       'marque': car.marque,
//       'modele': car.modele,
//       'annee': car.annee,
//       'nom_proprietaire': car.nomProprietaire,
//       'usage': car.usage,
//       'puissance': car.puissance,
//       'nbre_place': car.nbrePlace,
//       'types_couverture': car.typesCouverture,
//       'durée': car.duree,
//       'date_debut': car.dateDebut,
//       'date_fin': car.dateFin
//     };

//     // Debug: Affiche l'URL et le corps de la requête
//     print('🔵 [API Request] URL: $url');
//     print('🔵 [API Request] Body: ${json.encode(requestBody)}');
//     print(
//         '🔵 [API Request] Headers: {"Content-Type": "application/json; charset=UTF-8"}');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: json.encode(requestBody),
//       );

//       // Debug: Affiche la réponse
//       print('🟢 [API Response] Status: ${response.statusCode}');
//       print('🟢 [API Response] Body: ${response.body}');
//       print('🟢 [API Response] Headers: ${response.headers}');

//       if (response.statusCode != 201) {
//         throw Exception('Failed to add car: ${response.statusCode}');
//       }

//       print('✅ [API] Car added successfully');
//       return response;
//     } catch (e) {
//       print('🔴 [API Error] $e');
//       rethrow;
//     }
//   }
// }

  Future<Map<String, dynamic>> addCar(Car car, Assureur assureur) async {
    final url = Uri.parse('$baseUrl/assurance/generer/');

    final requestBody = {
      'key_entreprise': assureur.nom,
      'vin': car.vin,
      'matricule': car.matricule,
      'marque': car.marque,
      'modele': car.modele,
      'annee': car.annee,
      'nom_proprietaire': car.nomProprietaire,
      'usage': car.usage,
      'puissance': car.puissance,
      'nbre_place': car.nbrePlace,
      'types_couverture': car.typesCouverture,
      'durée': car.duree,
      'date_debut': car.dateDebut,
      'date_fin': car.dateFin
    };

    print('🔵 [API Request] Body: ${json.encode(requestBody)}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(requestBody),
      );

      print('🟢 [API Response] Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData; // Retourne les données de la réponse
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 [API Error] $e');
      rethrow;
    }
  }
}
