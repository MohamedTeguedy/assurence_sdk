import 'package:flutter/material.dart';
import 'package:assurence_sdk/data/models/car_model.dart';
import 'package:assurence_sdk/data/services/service_data_local.dart';

class CarListScreen extends StatelessWidget {
  final _dbHelper = CarService();

  CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Voitures'),
      ),
      body: FutureBuilder<List<Car>>(
        future: _dbHelper.getCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune voiture enregistrée.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var car = snapshot.data![index];
                return ListTile(
                  title: Text('${car.marque} ${car.modele}'),
                  subtitle: Text('Propriétaire: ${car.nomProprietaire}'),
                  trailing: Text('Immatriculation: ${car.matricule}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
