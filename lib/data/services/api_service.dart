import '../models/assureur_model.dart';
import '../models/car_model.dart';
import '../models/form_data_model.dart';
import '../../presentation/customs/http_0.13.6/http.dart' as http;
import 'dart:convert';

class FormDataService {
  static String? _authToken;
  static String baseUrl = 'http://192.168.1.107:8000';

  // Initialise le service avec le token
  static void initialize({required String authToken, String? customBaseUrl}) {
    _authToken = authToken;

    if (customBaseUrl != null) {
      baseUrl = customBaseUrl;
    }
  }

  // Headers communs pour toutes les requêtes
  static Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  // Méthode générique pour les requêtes GET
  static Future<dynamic> _get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // Méthode générique pour les requêtes POST
  static Future<dynamic> _post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // Gestion centralisée des réponses
  static dynamic _handleResponse(http.Response response) {
    // print('🔵 [API Response] Status: ${response.statusCode}');
    // print('🔵 [API Response] Body: ${response.body}');

    final decodedBody = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      throw Exception(
        decodedBody['message'] ?? 'Erreur API: ${response.statusCode}',
      );
    }
  }

  // fetchFormData avec gestion du token
  Future<FormData> fetchFormData() async {
    final data = await _get('form-data/');
    return FormData.fromJson(data as Map<String, dynamic>);
  }

  // fetchModelesByMarque avec gestion du token
  Future<List<Modele>> fetchModelesByMarque(int marqueId) async {
    // print('🟡 Chargement des modèles pour marque ID: $marqueId');
    final data = await _get('form-data/$marqueId/');

    final modeles = (data['modeles'] as List)
        .map((modele) => Modele.fromJson(modele))
        .toList();

    // print('📦 Modèles chargés (${modeles.length})');
    return modeles;
  }

  // addCar avec gestion du token
  Future<Map<String, dynamic>> addCar(Car car, Assureur assureur) async {
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
      'duree': car.duree,
      'date_debut': car.dateDebut,
      'date_fin': car.dateFin
    };

    print('🔵 [API Request] Body: $requestBody');
    return await _post('assurance/generer/', requestBody);
  }

  Future<Map<String, dynamic>> fetchDurees({
    required String keyEntreprise,
    required String usage,
    required int nbrePlace,
    required int nbrePuissance,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/durer/');
      final body = jsonEncode({
        'key_entreprise': keyEntreprise,
        'usage': usage,
        'nbreplace': nbrePlace,
        'nbrepuissance': nbrePuissance,
      });

      print('🔹 Envoi requête POST vers: $url');
      print('📦 Corps de la requête: $body');
      print(
          '🔐 Token utilisé: ${_authToken != null ? "****${_authToken!.substring(_authToken!.length - 4)}" : "null"}');

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      print('📥 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Données décodées avec succès');
        return data;
      } else if (response.statusCode == 401) {
        print('🔴 Erreur 401 - Token non valide ou expiré');
        throw Exception('Authentification requise - Token invalide ou expiré');
      } else {
        print('❌ Erreur serveur: ${response.body}');
        throw Exception('Erreur serveur - Code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la requête: $e');
      rethrow;
    }
  }
}
