import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/assureur_model.dart';
import '../../data/models/car_model.dart';
import '../../data/models/form_data_model.dart';
import '../../data/repository/car_repository.dart';
import '../../data/repository/form_data_repository.dart';

part 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository _carRepository = CarRepository();
  final FormDataRepository _formDataRepository = FormDataRepository();

  CarCubit() : super(CarInitial());

  void loadCars() async {
    final cars = await _carRepository.getAllCars();
    emit(CarLoaded(cars: cars));
  }

  // Future<Map<String, dynamic>> addCar(Car car, Assureur assureur) async {
  //   emit(CarLoading());
  //   try {
  //     final response = await _carRepository.addCar(car, assureur);
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);

  //       emit(CarAddedSuccessfully(car, assureur, responseData));
  //       return responseData;
  //     } else {
  //       emit(CarError('Failed to add car:'));
  //       throw Exception('Failed to add car: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     emit(CarError('Failed to add car: $e'));
  //     throw Exception('Failed to add car: $e');
  //   }
  // }

  Future<void> addCar(Car car, Assureur assureur) async {
    emit(CarLoading());
    try {
      final response = await _carRepository.addCar(car, assureur);
      emit(CarAddedSuccessfully(response));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  Future<void> loadAllData() async {
    emit(CarLoading());
    try {
      final formData = await _formDataRepository.getFormData();
      emit(CarDataLoaded(
        marques: formData.marques,
        usages: formData.usages,
        couvertures: formData.couvertures,
        modeles: null,
      ));
    } catch (e) {
      emit(CarError('Failed to load car data: $e'));
    }
  }

  Future<void> loadModelesByMarque(int marqueId) async {
    try {
      final modeles = await _formDataRepository.getModelesByMarque(marqueId);
      final currentState = state as CarDataLoaded;
      emit(CarDataLoaded(
        marques: currentState.marques,
        usages: currentState.usages,
        couvertures: currentState.couvertures,
        modeles: modeles,
      ));
    } catch (e) {
      emit(CarError('Failed to load modeles: $e'));
    }
  }
}
