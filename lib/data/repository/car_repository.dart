import '../models/car_model.dart';
import '../services/service_data_local.dart';

class CarRepository {
  final CarService _carService = CarService();

  Future<int> addCar(Car car) async {
    return await _carService.insertCar(car);
  }

  Future<List<Car>> getAllCars() async {
    return await _carService.getCars();
  }
}
