import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/car_model.dart';
import '../../data/repository/car_repository.dart';

part 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository _carRepository = CarRepository();

  CarCubit() : super(CarInitial());

  void loadCars() async {
    final cars = await _carRepository.getAllCars();
    emit(CarLoaded(cars: cars));
  }

  void addCar(Car car) async {
    await _carRepository.addCar(car);
    loadCars(); // Recharger la liste après ajout
  }
}
