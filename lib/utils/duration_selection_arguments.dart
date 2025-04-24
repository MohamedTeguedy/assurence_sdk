import 'package:assurence_sdk/data/models/assureur_model.dart';

class DurationSelectionArguments {
  final Assureur assureur;
  final Map<String, dynamic> carData;

  DurationSelectionArguments({
    required this.assureur,
    required this.carData,
  });
}
