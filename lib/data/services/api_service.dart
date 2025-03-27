import '../models/form_data_model.dart';
// import 'package:http/http.dart' as http;
import '../../presentation/customs/http_0.13.6/http.dart' as http;
import 'dart:convert';

class FormDataService {
  final String baseUrl = 'http://192.168.1.107:8000';

  Future<FormData> fetchFormData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/form-data/'),
      headers: {'Accept-Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      return FormData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load form data');
    }
  }

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
        final data = json.decode(response.body);
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
}
