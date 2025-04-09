// import 'package:flutter/material.dart';
// import 'package:assurence_sdk/data/models/car_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../business_logic/cubits/car_cubit.dart';
// import '../../data/models/assureur_model.dart';
// import '../../route.dart';
// import '../../utils/text_utils.dart';
// import 'devisPage.dart';

// class ConfirmationPage extends StatelessWidget {
//   final Car car;

//   final Assureur assureur;

//   const ConfirmationPage(
//       {super.key, required this.car, required this.assureur});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CarCubit(),
//       child: Builder(builder: (context) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Confirmer les données'),
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: Colors.blue.shade800,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Carte pour afficher les informations de la voiture
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Informations de la voiture',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           Text('Assureur: ${assureur.nom}',
//                               style: const TextStyle(fontSize: 16)),
//                           const SizedBox(height: 16),
//                           _buildInfoRow(
//                               Icons.confirmation_number, 'VIN', car.vin),
//                           _buildInfoRow(
//                               Icons.directions_car, 'Matricule', car.matricule),
//                           _buildInfoRow(
//                               Icons.branding_watermark, 'Marque', car.marque),
//                           _buildInfoRow(Icons.model_training, 'Modèle',
//                               cleanFrenchText(car.modele)),
//                           _buildInfoRow(Icons.calendar_today, 'Année',
//                               car.annee.toString()),
//                           _buildInfoRow(Icons.person, 'Propriétaire',
//                               car.nomProprietaire),
//                           _buildInfoRow(Icons.assignment, 'Usage', car.usage),
//                           _buildInfoRow(
//                               Icons.speed, 'Puissance', car.puissance),
//                           _buildInfoRow(Icons.airline_seat_recline_normal,
//                               'Nombre de places', car.nbrePlace.toString()),
//                           _buildInfoRow(Icons.security, 'Types de couverture',
//                               car.typesCouverture.join(', ')),
//                           _buildInfoRow(Icons.date_range, 'Durée', car.duree),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   // Boutons pour corriger ou valider
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           // Retourner au formulaire pour corriger les données
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey.shade300,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Corriger',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           // Valider les données et naviguer vers la liste des voitures

//                           await context.read<CarCubit>().addCar(car, assureur);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DevisPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade800,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Valider',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   // Méthode pour construire une ligne d'information avec une icône
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue.shade800),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:assurence_sdk/data/models/car_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../business_logic/cubits/car_cubit.dart';
// import '../../data/models/assureur_model.dart';

// import '../../utils/text_utils.dart';
// import 'devisPage.dart';

// class ConfirmationPage extends StatelessWidget {
//   final Car car;
//   final Assureur assureur;

//   const ConfirmationPage(
//       {super.key, required this.car, required this.assureur});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CarCubit(),
//       child: Builder(builder: (context) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Confirmer les données'),
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: Colors.blue.shade800,
//           ),
//           body: BlocListener<CarCubit, CarState>(
//             listener: (context, state) {
//               if (state is CarAddedSuccessfully) {
//                 // Navigation vers DevisPage avec les données de la réponse
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DevisPage(devisData: state.response),
//                   ),
//                 );
//               }
//               if (state is CarError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message)),
//                 );
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ... (votre contenu existant) ...

//                     // Carte pour afficher les informations de la voiture
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Informations de la voiture',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                             Text('Assureur: ${assureur.nom}',
//                                 style: const TextStyle(fontSize: 16)),
//                             const SizedBox(height: 16),
//                             _buildInfoRow(
//                                 Icons.confirmation_number, 'VIN', car.vin),
//                             _buildInfoRow(Icons.directions_car, 'Matricule',
//                                 car.matricule),
//                             _buildInfoRow(
//                                 Icons.branding_watermark, 'Marque', car.marque),
//                             _buildInfoRow(Icons.model_training, 'Modèle',
//                                 cleanFrenchText(car.modele)),
//                             _buildInfoRow(Icons.calendar_today, 'Année',
//                                 car.annee.toString()),
//                             _buildInfoRow(Icons.person, 'Propriétaire',
//                                 car.nomProprietaire),
//                             _buildInfoRow(Icons.assignment, 'Usage', car.usage),
//                             _buildInfoRow(
//                                 Icons.speed, 'Puissance', car.puissance),
//                             _buildInfoRow(Icons.airline_seat_recline_normal,
//                                 'Nombre de places', car.nbrePlace.toString()),
//                             _buildInfoRow(Icons.security, 'Types de couverture',
//                                 car.typesCouverture.join(', ')),
//                             _buildInfoRow(Icons.date_range, 'Durée', car.duree),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Boutons pour corriger ou valider
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey.shade300,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 24, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             'Corriger',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                         BlocBuilder<CarCubit, CarState>(
//                           builder: (context, state) {
//                             return ElevatedButton(
//                               onPressed: state is CarLoading
//                                   ? null
//                                   : () async {
//                                       await context
//                                           .read<CarCubit>()
//                                           .addCar(car, assureur);
//                                     },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue.shade800,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 24, vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: state is CarLoading
//                                   ? const CircularProgressIndicator(
//                                       color: Colors.white)
//                                   : const Text(
//                                       'Valider',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   // ... (votre méthode _buildInfoRow existante) ...
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue.shade800),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:assurence_sdk/data/models/car_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubits/car_cubit.dart';
import '../../data/models/assureur_model.dart';

import '../../utils/text_utils.dart';
import 'devisPage.dart';

class ConfirmationPage extends StatelessWidget {
  final Car car;
  final Assureur assureur;

  const ConfirmationPage(
      {super.key, required this.car, required this.assureur});

  // Méthode pour convertir le code usage en texte explicite
  String _getUsageText(String usageCode) {
    switch (usageCode) {
      case 'A01':
        return 'Personnel';
      case 'A02':
        return 'Professionnel';
      case 'A03':
        return 'Mixte';
      default:
        return usageCode;
    }
  }

  // Méthode pour formater la durée
  String _formatDuree(String duree) {
    return '$duree mois';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirmer les données'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue.shade800,
          ),
          body: BlocListener<CarCubit, CarState>(
            listener: (context, state) {
              if (state is CarAddedSuccessfully) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DevisPage(devisData: state.response),
                  ),
                );
              }
              if (state is CarError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informations de la voiture',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text('Assureur: ${assureur.nom}',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                                Icons.confirmation_number, 'VIN', car.vin),
                            _buildInfoRow(Icons.directions_car, 'Matricule',
                                car.matricule),
                            _buildInfoRow(
                                Icons.branding_watermark, 'Marque', car.marque),
                            _buildInfoRow(Icons.model_training, 'Modèle',
                                cleanFrenchText(car.modele)),
                            _buildInfoRow(Icons.calendar_today, 'Année',
                                car.annee.toString()),
                            _buildInfoRow(Icons.person, 'Propriétaire',
                                car.nomProprietaire),
                            _buildInfoRow(Icons.assignment, 'Usage',
                                _getUsageText(car.usage)),
                            _buildInfoRow(
                                Icons.speed, 'Puissance', car.puissance),
                            _buildInfoRow(Icons.airline_seat_recline_normal,
                                'Nombre de places', car.nbrePlace.toString()),
                            _buildInfoRow(Icons.security, 'Types de couverture',
                                car.typesCouverture.join(', ')),
                            _buildInfoRow(Icons.date_range, 'Durée',
                                _formatDuree(car.duree)),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Corriger',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        BlocBuilder<CarCubit, CarState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is CarLoading
                                  ? null
                                  : () async {
                                      await context
                                          .read<CarCubit>()
                                          .addCar(car, assureur);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade800,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: state is CarLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Valider',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
