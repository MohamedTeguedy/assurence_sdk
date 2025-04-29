library assurence_sdk;

import 'package:assurence_sdk/route.dart';
import 'package:flutter/material.dart';

import 'data/services/api_service.dart';

void main() {
  runApp(AssurenceSdk.getSdkWidget());
}

class AssurenceSdk {
  static void initialize({required String authToken, String? baseUrl}) {
    // Initialiser le service avec le token
    FormDataService.initialize(
      authToken: authToken,
      customBaseUrl: baseUrl,
    );

    // Vous pourriez aussi initialiser d'autres services ici
  }

  static Widget getSdkWidget() {
    return MaterialApp(
      title: 'Enregistrement de Voiture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
          titleMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.listAssureur,
    );
  }
}
