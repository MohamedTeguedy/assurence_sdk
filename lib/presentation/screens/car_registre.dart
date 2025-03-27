import 'package:assurence_sdk/utils/confirmation_aguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:assurence_sdk/business_logic/cubits/car_cubit.dart';

import '../../data/models/assureur_model.dart';
import '../../data/models/car_model.dart';
import '../../data/models/form_data_model.dart';
import '../../route.dart';
import '../../utils/text_utils.dart';

class CarRegistrationPage extends StatefulWidget {
  const CarRegistrationPage({super.key, required this.assureur});
  final Assureur assureur;

  @override
  CarRegistrationPageState createState() => CarRegistrationPageState();
}

class CarRegistrationPageState extends State<CarRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _anneeController = TextEditingController();
  final TextEditingController _nomProprietaireController =
      TextEditingController();
  final TextEditingController _nbrePlaceController = TextEditingController();
  final TextEditingController _dureeController = TextEditingController();

  Marque? _selectedMarque;
  Modele? _selectedModele;
  Usage? _selectedUsage;
  List<Couverture> _selectedCouvertures = [];
  List<Couverture> _allCouvertures = [];

  @override
  void initState() {
    super.initState();
    context.read<CarCubit>().loadAllData();
  }

  @override
  void dispose() {
    _vinController.dispose();
    _matriculeController.dispose();
    _anneeController.dispose();
    _nomProprietaireController.dispose();
    _nbrePlaceController.dispose();
    _dureeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrement Véhicule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.listAssureur),
        ),
      ),
      body: BlocConsumer<CarCubit, CarState>(
        listener: (context, state) {
          if (state is CarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CarDataLoaded) {
            _allCouvertures = state.couvertures;
            if (_selectedCouvertures.isEmpty) {
              _selectedCouvertures = _allCouvertures
                  .where((c) => c.type == 'RESPONSABILITE_CIVILE')
                  .toList();
            }
            return _buildForm(state);
          }

          return const Center(child: Text('Chargement des données...'));
        },
      ),
    );
  }

  Widget _buildForm(CarDataLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('VIN', _vinController, Icons.confirmation_number),
            const SizedBox(height: 16),
            _buildTextField(
                'Matricule', _matriculeController, Icons.directions_car),
            const SizedBox(height: 16),

            // Sélection de la marque
            _buildMarqueDropdown(state.marques),
            const SizedBox(height: 16),

            // Sélection du modèle (si marque sélectionnée et modèles disponibles)
            if (_selectedMarque != null && state.modeles != null)
              _buildModeleDropdown(state.modeles!),
            const SizedBox(height: 16),

            _buildTextField('Année', _anneeController, Icons.calendar_today,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(
                'Propriétaire', _nomProprietaireController, Icons.person),
            const SizedBox(height: 16),

            // Sélection de l'usage
            _buildUsageDropdown(state.usages),
            const SizedBox(height: 16),

            _buildTextField('Nombre de places', _nbrePlaceController,
                Icons.airline_seat_recline_normal,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            // Sélection des couvertures
            _buildCouverturesSection(),
            const SizedBox(height: 16),

            // Durée de couverture
            _buildDureeField(),
            const SizedBox(height: 24),

            // Bouton de soumission
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Les méthodes _buildTextField, _buildMarqueDropdown, _buildModeleDropdown,
  // _buildUsageDropdown, _buildCouverturesSection, _buildDureeField restent identiques
  // à l'implémentation précédente montrée plus haut)

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Ce champ est obligatoire' : null,
    );
  }

  Widget _buildMarqueDropdown(List<Marque> marques) {
    return DropdownButtonFormField<Marque>(
      value: _selectedMarque,
      decoration: const InputDecoration(
        labelText: 'Marque',
        border: OutlineInputBorder(),
      ),
      items: marques
          .map((marque) => DropdownMenuItem(
                value: marque,
                child: Text(marque.nom),
              ))
          .toList(),
      onChanged: (Marque? marque) async {
        if (marque != null) {
          setState(() {
            _selectedMarque = marque;
            _selectedModele = null;
          });
          await context.read<CarCubit>().loadModelesByMarque(marque.id);
        }
      },
      validator: (value) => value == null ? 'Sélectionnez une marque' : null,
    );
  }

  Widget _buildModeleDropdown(List<Modele> list) {
    return BlocBuilder<CarCubit, CarState>(
      builder: (context, state) {
        if (state is CarDataLoaded) {
          return _buildModeleDropdownWithModeles(state.modeles ?? []);
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildModeleDropdownWithModeles(List<Modele> modeles) {
    return DropdownButtonFormField<Modele>(
      value: _selectedModele,
      decoration: const InputDecoration(
        labelText: 'Modèle',
        border: OutlineInputBorder(),
      ),
      items: modeles
          .map((modele) => DropdownMenuItem(
                value: modele,
                child: Text(modele.nom),
              ))
          .toList(),
      onChanged: (Modele? modele) {
        setState(() => _selectedModele = modele);
      },
      validator: (value) => value == null ? 'Sélectionnez un modèle' : null,
    );
  }

  Widget _buildUsageDropdown(List<Usage> usages) {
    return DropdownButtonFormField<Usage>(
      value: _selectedUsage,
      decoration: const InputDecoration(
        labelText: 'Usage',
        border: OutlineInputBorder(),
      ),
      items: usages
          .map((usage) => DropdownMenuItem(
                value: usage,
                child: Text(_mapUsageCode(usage.code)),
              ))
          .toList(),
      onChanged: (Usage? usage) {
        setState(() => _selectedUsage = usage);
      },
      validator: (value) => value == null ? 'Sélectionnez un usage' : null,
    );
  }

  String _mapUsageCode(String code) {
    switch (code) {
      case 'A01':
        return 'Personnel';
      case 'A02':
        return 'Transport';
      case 'A03':
        return 'Professionnel';
      case 'A04':
        return 'Autre';
      default:
        return code;
    }
  }

  Widget _buildCouverturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Couvertures',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ..._allCouvertures
            .map((couverture) => CheckboxListTile(
                  // title: Text(couverture.typeDisplay),
                  title: Text(cleanFrenchText(couverture.typeDisplay)),
                  subtitle: Text(couverture.description),
                  value: _selectedCouvertures.contains(couverture),
                  onChanged: couverture.type == 'RESPONSABILITE_CIVILE'
                      ? null
                      : (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedCouvertures.add(couverture);
                            } else {
                              _selectedCouvertures.remove(couverture);
                            }
                          });
                        },
                ))
            .toList(),
      ],
    );
  }

  Widget _buildDureeField() {
    return TextFormField(
      controller: _dureeController,
      decoration: const InputDecoration(
        labelText: 'Durée (mois)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.date_range),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Entrez une durée';
        final duree = int.tryParse(value);
        if (duree == null || duree < 1 || duree > 12) {
          return 'Entre 1 et 12 mois';
        }
        return null;
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final car = Car(
        vin: _vinController.text,
        matricule: _matriculeController.text,
        marque: _selectedMarque!.nom,
        modele: _selectedModele!.nom,
        annee: int.tryParse(_anneeController.text) ?? 0,
        nomProprietaire: _nomProprietaireController.text,
        usage: _selectedUsage!.code,
        nbrePlace: int.tryParse(_nbrePlaceController.text) ?? 0,
        typesCouverture: _selectedCouvertures.map((c) => c.type).toList(),
        duree: _dureeController.text,
        puissance: '',
      );

      Navigator.pushNamed(
        context,
        AppRoutes.confirmation,
        arguments: ConfirmationArguments(
          car: car,
          assureur: widget.assureur,
        ),
      );
    }
  }
}

// String _cleanFrenchText(String input) {
//   return input
//       .replaceAll('Ã©', 'é')
//       .replaceAll('Ã¨', 'è')
//       .replaceAll('Ãª', 'ê')
//       .replaceAll('Ã¹', 'ù')
//       .replaceAll('Ã¢', 'â')
//       .replaceAll('Ã®', 'î')
//       .replaceAll('Ã´', 'ô')
//       .replaceAll('Ã§', 'ç')
//       .replaceAll('Ãª', 'ê');
// }




