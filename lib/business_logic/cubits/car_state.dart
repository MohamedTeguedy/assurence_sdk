part of 'car_cubit.dart';

@immutable
class CarState {}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<Car> cars;

  CarLoaded({required this.cars});
}

// class CarAddedSuccessfully extends CarState {
//   final Map<String, dynamic> responseData;
//   CarAddedSuccessfully(Car newCar, Assureur assureur, this.responseData);
// }

class CarAddedSuccessfully extends CarState {
  final Map<String, dynamic> response;
  CarAddedSuccessfully(this.response);
}

class CarDataLoaded extends CarState {
  final List<Marque> marques;
  final List<Usage> usages;
  final List<Couverture> couvertures;
  final List<Modele>? modeles;

  CarDataLoaded({
    required this.marques,
    required this.usages,
    required this.couvertures,
    this.modeles,
  });
}

// class ModelesLoaded extends CarState {
//   final List<Modele> modeles;

//   ModelesLoaded(this.modeles);
// }

class CarError extends CarState {
  final String message;

  CarError(this.message);
}
