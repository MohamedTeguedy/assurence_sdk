import 'package:assurence_sdk/data/models/assureur_model.dart';
import 'package:assurence_sdk/presentation/screens/assureur_list_screen.dart';
import 'package:assurence_sdk/presentation/screens/car_registre.dart';
import 'package:assurence_sdk/presentation/screens/confirmation_aguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assurence_sdk/business_logic/cubits/car_cubit.dart';

import 'package:assurence_sdk/presentation/screens/car_list_screen.dart';
import 'package:assurence_sdk/presentation/screens/confirmation_page.dart';

import 'data/services/assureur_service.dart';

class AppRoutes {
  // Nom des routes
  static const String carRegistration = '/car-registration';
  static const String carList = '/car-list';
  static const String confirmation = '/confirmation';
  static const String listAssureur = '/list-assureur';

  late final AssureurService assureurService;

  // Configuration des routes
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case carRegistration:
        final assureur = settings.arguments as Assureur?; // Cast en Assureur?
        if (assureur == null) {
          // Gérer le cas où l'argument est null
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Assureur non fourni'),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: CarRegistrationPage(
                assureur: assureur), // Passer l'assureur à la page
          ),
        );
      case carList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: CarListScreen(),
          ),
        );
      case listAssureur:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: AssureurListScreen(),
          ),
        );
      case confirmation:
        // final car = settings.arguments as Car; // Récupérer les arguments
        // final assureur = settings.arguments as Assureur;
        final wrapper = settings.arguments as ConfirmationArguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: ConfirmationPage(
              assureur: wrapper.assureur,
              car: wrapper.car,
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Aucune route définie pour ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Configuration des providers globaux
  static Widget setupProviders(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CarCubit()),
      ],
      child: child,
    );
  }
}
