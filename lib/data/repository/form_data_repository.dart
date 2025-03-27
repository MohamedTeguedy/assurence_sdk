import '../models/form_data_model.dart';
import '../services/api_service.dart';

class FormDataRepository {
  final FormDataService _service = FormDataService();

  Future<FormData> getFormData() async {
    try {
      return await _service.fetchFormData();
    } catch (e) {
      throw Exception('Failed to fetch form data: $e');
    }
  }

  Future<List<Modele>> getModelesByMarque(int marqueId) async {
    try {
      return await _service.fetchModelesByMarque(marqueId);
    } catch (e) {
      throw Exception('Failed to fetch modeles: $e');
    }
  }
}
