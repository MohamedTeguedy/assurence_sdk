import 'dart:convert';

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import '../../data/models/assureur_model.dart';
import '../../data/models/car_model.dart';
import '../../data/models/form_data_model.dart';
import '../../data/repository/car_repository.dart';
import '../../data/repository/form_data_repository.dart';
import '../../data/repository/duree_repository.dart';
import '../../presentation/customs/bloc_9.0.0/lib/flutter_bloc.dart';

part 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository _carRepository = CarRepository();
  final FormDataRepository _formDataRepository = FormDataRepository();
  final DureeRepository repository = DureeRepository();

  CarCubit() : super(CarInitial());

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

  Future<void> fetchDurees({
    required String keyEntreprise,
    required String usage,
    required int nbrePlace,
    required int nbrePuissance,
  }) async {
    emit(DureeLoading());
    try {
      final dureeEntity = await repository.getDurees(
        keyEntreprise: keyEntreprise,
        usage: usage,
        nbrePlace: nbrePlace,
        nbrePuissance: nbrePuissance,
      );
      emit(DureeLoaded(durees: dureeEntity.durees));
    } catch (e) {
      emit(DureeError(message: e.toString()));
    }
  }
}
