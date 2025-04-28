import 'package:assurence_sdk/data/models/assureur_model.dart';
import 'package:assurence_sdk/presentation/screens/assureur_list_screen.dart';
import 'package:assurence_sdk/presentation/screens/car_info_page.dart';

import 'package:assurence_sdk/presentation/screens/confirmation_page.dart';
import 'package:assurence_sdk/presentation/screens/duration_selection_page.dart';
import 'package:assurence_sdk/utils/confirmation_aguments.dart';
import 'package:assurence_sdk/utils/duration_selection_arguments.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assurence_sdk/business_logic/cubits/car_cubit.dart';
import 'data/services/assureur_service.dart';

class AppRoutes {
  // Noms des routes
  static const String home = '/home';
  static const String carList = '/car-list';
  static const String confirmation = '/confirmation';
  static const String listAssureur = '/list-assureur';
  static const String carInfo = '/car-info';
  static const String durationSelection = '/duration-selection';

  late final AssureurService assureurService;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case carInfo:
        final assureur = settings.arguments as Assureur?;
        if (assureur == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Assureur non fourni')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: CarInfoPage(assureur: assureur),
          ),
        );

      case durationSelection:
        final args = settings.arguments as DurationSelectionArguments?;
        if (args == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Données manquantes')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: DurationSelectionPage(args: args),
          ),
        );

      case listAssureur:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CarCubit(),
            child: const AssureurListScreen(),
          ),
        );

      case confirmation:
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

  static Widget setupProviders(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CarCubit()),
      ],
      child: child,
    );
  }
}
