library assurence_sdk;

import 'package:assurence_sdk/route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AssurenceSdk());
}

class AssurenceSdk extends StatelessWidget {
  const AssurenceSdk({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Enregistrement de Voiture',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: BlocProvider(
    //     create: (context) => CarCubit(),
    //     child: AssureurListScreen(),
    //   ),
    // );

    var assureur;
    return MaterialApp(
      title: 'Enregistrement de Voiture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Utiliser les routes définies dans AppRoutes
      onGenerateRoute: AppRoutes.generateRoute,
      // Définir la route initiale
      initialRoute: AppRoutes.listAssureur,
      // Configurer les providers globaux
    );
  }
}
