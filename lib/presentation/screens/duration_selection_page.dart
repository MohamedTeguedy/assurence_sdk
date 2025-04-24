// // duration_selection_page.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../data/models/car_model.dart';

// import '../../route.dart';
// import '../../utils/confirmation_aguments.dart';
// import '../../utils/duration_selection_arguments.dart';

// class DurationSelectionPage extends StatefulWidget {
//   const DurationSelectionPage({super.key, required this.args});
//   final DurationSelectionArguments args;

//   @override
//   DurationSelectionPageState createState() => DurationSelectionPageState();
// }

// class DurationSelectionPageState extends State<DurationSelectionPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _dureeController = TextEditingController();
//   DateTime? _selectedDate;
//   DateTime? _dateFin;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Durée de couverture'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Champ durée
//               TextFormField(
//                 controller: _dureeController,
//                 decoration: InputDecoration(
//                   labelText: 'Durée (mois)',
//                   suffixText: 'mois',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Obligatoire';
//                   final duree = int.tryParse(value);
//                   if (duree == null || duree < 1 || duree > 12) {
//                     return '1-12 mois';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   if (_selectedDate != null) {
//                     _calculateEndDate();
//                   }
//                 },
//               ),

//               // Sélection date début
//               ListTile(
//                 title: Text(_selectedDate == null
//                     ? 'Sélectionnez date début'
//                     : 'Début: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () => _selectDate(context),
//               ),

//               // Affichage date fin (calculée)
//               if (_dateFin != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: Text(
//                     'Fin: ${DateFormat('dd/MM/yyyy').format(_dateFin!)}',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ),

//               // Bouton Valider
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('VALIDER'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _calculateEndDate();
//       });
//     }
//   }

//   void _calculateEndDate() {
//     if (_selectedDate != null && _dureeController.text.isNotEmpty) {
//       final duree = int.tryParse(_dureeController.text) ?? 0;
//       setState(() {
//         _dateFin = _selectedDate!.add(Duration(days: 30 * duree));
//       });
//     }
//   }

//   //   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate() && _selectedDate != null) {
//       // Conversion sécurisée de la durée
//       final duree = int.tryParse(_dureeController.text) ?? 0;

//       if (duree <= 0) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Veuillez entrer une durée valide')),
//         );
//         return;
//       }

//       // Conversion des autres champs numériques si nécessaire
//       final carData = widget.args.carData;
//       final annee = carData['annee'] is String
//           ? int.tryParse(carData['annee']) ?? 0
//           : carData['annee'] as int;
//       final nbrePlace = carData['nbrePlace'] is String
//           ? int.tryParse(carData['nbrePlace']) ?? 0
//           : carData['nbrePlace'] as int;

//       final car = Car(
//         vin: carData['vin'],
//         matricule: carData['matricule'],
//         marque: carData['marque'],
//         modele: carData['modele'],
//         annee: annee,
//         nomProprietaire: carData['nomProprietaire'],
//         usage: carData['usage'],
//         nbrePlace: nbrePlace,
//         typesCouverture: List<String>.from(carData['couvertures']),
//         duree: duree
//             .toString(), // Ou conservez comme int si votre modèle le permet
//         puissance: carData['puissance'] ?? '',
//         dateDebut: DateFormat('yyyy-MM-dd').format(_selectedDate!),
//         dateFin: DateFormat('yyyy-MM-dd').format(_dateFin!),
//       );

//       Navigator.pushNamed(
//         context,
//         AppRoutes.confirmation,
//         arguments: ConfirmationArguments(
//           car: car,
//           assureur: widget.args.assureur,
//         ),
//       );
//     }
//   }
// }

import 'package:assurence_sdk/business_logic/cubits/car_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/car_model.dart';
import '../../route.dart';
import '../../utils/confirmation_aguments.dart';
import '../../utils/duration_selection_arguments.dart';

class DurationSelectionPage extends StatefulWidget {
  const DurationSelectionPage({super.key, required this.args});
  final DurationSelectionArguments args;

  @override
  DurationSelectionPageState createState() => DurationSelectionPageState();
}

class DurationSelectionPageState extends State<DurationSelectionPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  DateTime? _dateFin;
  int? _selectedDuree;

  @override
  void initState() {
    super.initState();
    _loadDurees();
  }

  void _loadDurees() {
    final carData = widget.args.carData;
    context.read<CarCubit>().fetchDurees(
          keyEntreprise: widget.args.assureur.nom,
          usage: carData['usage'],
          nbrePlace: carData['nbrePlace'] is String
              ? int.tryParse(carData['nbrePlace']) ?? 0
              : carData['nbrePlace'],
          nbrePuissance: carData['puissance'] is String
              ? int.tryParse(carData['puissance']) ?? 0
              : carData['puissance'],
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Durée de couverture'),
        centerTitle: true,
      ),
      body: BlocConsumer<CarCubit, CarState>(
        listener: (context, state) {
          if (state is DureeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Sélection de la durée'),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildDureeDropdown(state),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Date de début'),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'Sélectionnez une date'
                            : 'Début: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_dateFin != null)
                    Card(
                      color: Colors.green[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Fin: ${DateFormat('dd/MM/yyyy').format(_dateFin!)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.green[800]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.check),
                      label: const Text('VALIDER'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDureeDropdown(CarState state) {
    if (state is DureeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DureeLoaded) {
      return DropdownButtonFormField<int>(
        value: _selectedDuree,
        decoration: const InputDecoration(
          labelText: 'Durée (mois)',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        items: state.durees.map((duree) {
          return DropdownMenuItem<int>(
            value: duree,
            child: Text('$duree mois'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedDuree = value;
            if (_selectedDate != null) {
              _calculateEndDate();
            }
          });
        },
        validator: (value) =>
            value == null ? 'Veuillez sélectionner une durée' : null,
      );
    } else if (state is DureeError) {
      return Text('Erreur de chargement: ${state.message}');
    } else {
      return const Text('Chargement des durées...');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        if (_selectedDuree != null) {
          _calculateEndDate();
        }
      });
    }
  }

  void _calculateEndDate() {
    if (_selectedDate != null && _selectedDuree != null) {
      setState(() {
        _dateFin = _selectedDate!.add(Duration(days: 30 * _selectedDuree!));
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedDuree != null) {
      final carData = widget.args.carData;
      final car = Car(
        vin: carData['vin'],
        matricule: carData['matricule'],
        marque: carData['marque'],
        modele: carData['modele'],
        annee: carData['annee'] is String
            ? int.tryParse(carData['annee']) ?? 0
            : carData['annee'],
        nomProprietaire: carData['nomProprietaire'],
        usage: carData['usage'],
        nbrePlace: carData['nbrePlace'] is String
            ? int.tryParse(carData['nbrePlace']) ?? 0
            : carData['nbrePlace'],
        typesCouverture: List<String>.from(carData['couvertures']),
        duree: _selectedDuree.toString(),
        puissance: carData['puissance'] ?? '',
        dateDebut: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        dateFin: DateFormat('yyyy-MM-dd').format(_dateFin!),
      );

      Navigator.pushNamed(
        context,
        AppRoutes.confirmation,
        arguments: ConfirmationArguments(
          car: car,
          assureur: widget.args.assureur,
        ),
      );
    } else if (_selectedDuree == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une durée valide')),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
      ),
    );
  }
}
