import 'package:assurence_sdk/data/models/car_model.dart';
import 'package:assurence_sdk/data/models/assureur_model.dart';

class ConfirmationArguments {
  final Car car;
  final Assureur assureur;

  ConfirmationArguments({required this.car, required this.assureur});
}
