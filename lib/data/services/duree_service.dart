import 'dart:convert';
// import 'package:http/http.dart' as http;

import '../../presentation/customs/http_0.13.6/http.dart' as http;

class DureeService {
  final String baseUrl = 'http://192.168.1.107:8000';

  Future<Map<String, dynamic>> fetchDurees({
    required String keyEntreprise,
    required String usage,
    required int nbrePlace,
    required int nbrePuissance,
  }) async {
    final url = Uri.parse('$baseUrl/durer/');
    final body = jsonEncode({
      'key_entreprise': keyEntreprise,
      'usage': usage,
      'nbreplace': nbrePlace,
      'nbrepuissance': nbrePuissance,
    });

    print('🔹 Envoi requête POST vers: $url');
    print('📦 Corps de la requête: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Réponse brute: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ Données décodées: $data');
      return data;
    } else {
      print('❌ Erreur lors du chargement des durées');
      throw Exception(
          'Failed to load durees - Status Code: ${response.statusCode}');
    }
  }
}
