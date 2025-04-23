// import 'package:assurence_sdk/presentation/customs/http_0.13.6/http.dart';

import '../models/car_model.dart';

import '../services/api_service.dart';

class CarRepository {
  final FormDataService formDataService = FormDataService();

  Future<Map<String, dynamic>> addCar(Car car, assureur) async {
    try {
      return await formDataService.addCar(car, assureur);
    } catch (e) {
      throw Exception('Erreur Repository: $e');
    }
  }
}
