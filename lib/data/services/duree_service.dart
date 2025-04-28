// import 'dart:convert';
// // import 'package:http/http.dart' as http;

// import '../../presentation/customs/http_0.13.6/http.dart' as http;
// import '../models/duree_model..dart';

// class DureeService {
//   static String baseUrl = 'http://192.168.1.107:8000';
//   static String? _authToken;

//   static void initialize({required String authToken, String? customBaseUrl}) {
//     _authToken = authToken;
//     if (authToken != null) {
//       print('🔑 Auth');
//     }
//     if (customBaseUrl != null) {
//       baseUrl = customBaseUrl;
//     }
//   }

//   Future<Map<String, dynamic>> fetchDurees({
//     required String keyEntreprise,
//     required String usage,
//     required int nbrePlace,
//     required int nbrePuissance,
//   }) async {
//     final url = Uri.parse('$baseUrl/durer/');
//     final body = jsonEncode({
//       'key_entreprise': keyEntreprise,
//       'usage': usage,
//       'nbreplace': nbrePlace,
//       'nbrepuissance': nbrePuissance,
//     });

//     print('🔹 Envoi requête POST vers: $url');
//     print('📦 Corps de la requête: $body');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );

//     print('📥 Status Code: ${response.statusCode}');
//     print('📥 Réponse brute: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print('✅ Données décodées: $data');
//       return data;
//     } else {
//       print('❌ Erreur lors du chargement des durées');
//       throw Exception(
//           'Failed to load durees - Status Code: ${response.statusCode}');
//     }
//   }
// }

import 'dart:convert';
import '../../presentation/customs/http_0.13.6/http.dart' as http;

class DureeService {
  static String baseUrl = 'http://192.168.1.107:8000';
  static String? _authToken;

  static void initialize({required String authToken, String? customBaseUrl}) {
    _authToken = authToken;
    if (customBaseUrl != null) {
      baseUrl = customBaseUrl;
    }
    print('🔑 DureeService initialisé avec token');
  }

  // Méthode privée pour les headers communs
  static Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
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

  // Méthode pour mettre à jour le token si nécessaire
  static void updateAuthToken(String newToken) {
    _authToken = newToken;
    print('🔑 Token DureeService mis à jour');
  }
}
