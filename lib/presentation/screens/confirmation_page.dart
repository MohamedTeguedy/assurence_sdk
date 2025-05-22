import 'package:flutter/material.dart';
import 'package:assurence_sdk/data/models/car_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubits/car_cubit.dart';
import '../../data/models/assureur_model.dart';

import '../../utils/text_utils.dart';
import '../components/custom_app_bar.dart';
import '../customs/bloc_9.0.0/lib/flutter_bloc.dart';
import 'devis_page.dart';

class ConfirmationPage extends StatelessWidget {
  final Car car;
  final Assureur assureur;

  const ConfirmationPage({
    super.key,
    required this.car,
    required this.assureur,
  });

  String _getUsageText(String usageCode) {
    switch (usageCode) {
      case 'A01':
        return 'Personnel';
      case 'A03':
        return 'Transport de marchandises';
      case 'A02':
        return 'Professionnel';
      case 'A04':
        return 'Transport en commun';
      default:
        return usageCode;
    }
  }

  String _formatDuree(String duree) {
    return '$duree mois';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Confirmation des données',
            showBackButton: true,
            onBackPressed: () => Navigator.pop(context),
          ),
          body: BlocListener<CarCubit, CarState>(
            listener: (context, state) {
              if (state is CarAddedSuccessfully) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DevisPage(devisData: state.response),
                  ),
                );
              } else if (state is CarError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                double padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      _buildSectionCard(context),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.edit, color: Colors.black87),
                            label: const Text(
                              'Corriger',
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                          BlocBuilder<CarCubit, CarState>(
                            builder: (context, state) {
                              return ElevatedButton.icon(
                                onPressed: state is CarLoading
                                    ? null
                                    : () {
                                        context
                                            .read<CarCubit>()
                                            .addCar(car, assureur);
                                      },
                                icon: state is CarLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.check_circle),
                                label: const Text('Valider'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Validation des données',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const Divider(height: 30),
            _buildInfoRow(Icons.business, 'Assureur', assureur.nom),
            _buildInfoRow(Icons.confirmation_number, 'VIN', car.vin),
            _buildInfoRow(Icons.directions_car, 'Matricule', car.matricule),
            _buildInfoRow(Icons.branding_watermark, 'Marque', car.marque),
            _buildInfoRow(
                Icons.model_training, 'Modèle', cleanFrenchText(car.modele)),
            _buildInfoRow(Icons.calendar_today, 'Année', car.annee.toString()),
            _buildInfoRow(Icons.person, 'Propriétaire', car.nomProprietaire),
            _buildInfoRow(Icons.assignment, 'Usage', _getUsageText(car.usage)),
            _buildInfoRow(Icons.speed, 'Puissance', car.puissance),
            _buildInfoRow(Icons.event_seat, 'Places', car.nbrePlace.toString()),
            _buildInfoRow(
                Icons.security, 'Couvertures', car.typesCouverture.join(', ')),
            _buildInfoRow(Icons.date_range, 'Durée', _formatDuree(car.duree)),
            _buildInfoRow(Icons.calendar_today, 'Début', car.dateDebut),
            _buildInfoRow(Icons.calendar_today_outlined, 'Fin', car.dateFin),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 46, 118, 252)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
