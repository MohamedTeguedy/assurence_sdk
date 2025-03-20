library assurence_sdk;

import 'package:assurence_sdk/presentation/screens/assureur_list_screen.dart';
import 'package:assurence_sdk/presentation/screens/car_list_screen.dart';
import 'package:assurence_sdk/presentation/screens/car_registre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/cubits/car_cubit.dart';

void main() {
  runApp(const AssurenceSdk());
}

class AssurenceSdk extends StatelessWidget {
  const AssurenceSdk({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enregistrement de Voiture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        // create: (context) => CarCubit()..loadCars(),
        create: (context) => CarCubit(),
        child: AssureurListScreen(),
        // child: CarListScreen(),
      ),
    );
  }
}
