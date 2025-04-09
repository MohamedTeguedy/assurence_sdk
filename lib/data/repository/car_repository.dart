import 'package:assurence_sdk/presentation/customs/http_0.13.6/http.dart';

import '../models/car_model.dart';
import '../models/form_data_model.dart';
import '../services/api_service.dart';
import '../services/service_data_local.dart';

class CarRepository {
  final CarService _carService = CarService();
  final FormDataService formDataService = FormDataService();

  // Future<int> addCar(Car car) async {
  //   return await _carService.insertCar(car);
  // }

  Future<List<Car>> getAllCars() async {
    return await _carService.getCars();
  }

  // Future<Response> addCar(Car car, assureur) async {
  //   try {
  //     final response = await formDataService.addCar(car, assureur);
  //     return response;
  //   } catch (e) {
  //     throw Exception('Repository error: $e');
  //   }
  // }

  Future<Map<String, dynamic>> addCar(Car car, assureur) async {
    try {
      return await formDataService.addCar(car, assureur);
    } catch (e) {
      throw Exception('Erreur Repository: $e');
    }
  }
}
