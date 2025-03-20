import 'dart:convert';
import 'package:assurence_sdk/data/models/assureur_model.dart';
import 'package:assurence_sdk/data/models/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubits/car_cubit.dart';
import '../../data/services/service_data_local.dart';
import 'car_list_screen.dart';
import 'confirmation_page.dart';

class CarRegistrationPage extends StatefulWidget {
  const CarRegistrationPage({super.key, required Assureur assureur});

  @override
  // ignore: library_private_types_in_public_api
  _CarRegistrationPageState createState() => _CarRegistrationPageState();
}

class _CarRegistrationPageState extends State<CarRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = CarService();

  // Contrôleurs pour les champs de formulaire
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _anneeController = TextEditingController();
  final TextEditingController _nomProprietaireController =
      TextEditingController();
  final TextEditingController _nbrePlaceController = TextEditingController();
  final TextEditingController _dureeController = TextEditingController();

  String? _marque;
  String? _modele;
  String? _usage;
  String? _puissance;
  List<String> _typesCouverture = [];

  final List<String> _usages = ['A01', 'A02', 'A03'];
  final List<String> _couvertureOptions = [
    'RESPONSABILITE_CIVILE',
    'DOMMAGES_VEHICULE',
    'VOL',
  ];

  final Map<String, Map<String, List<String>>> _marqueModelesPuissance = {
    'Toyota': {
      'modèles': ['Corolla', 'Prado', 'RAV4'],
      'puissances': ['11CV', '12CV', '15CV'],
    },
    'Hyundai': {
      'modèles': ['Tucson', 'Santa Fe', 'Elantra'],
      'puissances': ['10CV', '13CV', '16CV'],
    },
    // Ajoutez d'autres marques ici
  };

  List<String> _modelesDisponibles = [];
  List<String> _puissancesDisponibles = [];

  @override
  void dispose() {
    // Libérer les contrôleurs pour éviter les fuites de mémoire
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
        title: const Text('Enregistrer une Voiture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'VIN',
                controller: _vinController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer le VIN'
                    : null,
                icon: Icons.confirmation_number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Matricule',
                controller: _matriculeController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer le matricule'
                    : null,
                icon: Icons.directions_car,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                value: _marque,
                label: 'Marque',
                items: _marqueModelesPuissance.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    _marque = value;
                    _modelesDisponibles =
                        _marqueModelesPuissance[value]?['modèles'] ?? [];
                    _puissancesDisponibles =
                        _marqueModelesPuissance[value]?['puissances'] ?? [];
                    _modele = null;
                    _puissance = null;
                  });
                },
                icon: Icons.branding_watermark,
              ),
              if (_marque != null) ...[
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _modele,
                  label: 'Modèle',
                  items: _modelesDisponibles,
                  onChanged: (value) {
                    setState(() {
                      _modele = value;
                    });
                  },
                  icon: Icons.model_training,
                ),
              ],
              if (_marque != null) ...[
                const SizedBox(height: 16),
                _buildDropdown(
                  value: _puissance,
                  label: 'Puissance',
                  items: _puissancesDisponibles,
                  onChanged: (value) {
                    setState(() {
                      _puissance = value;
                    });
                  },
                  icon: Icons.speed,
                ),
              ],
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Année',
                controller: _anneeController,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer l\'année'
                    : null,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nom du propriétaire',
                controller: _nomProprietaireController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer le nom du propriétaire'
                    : null,
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                value: _usage,
                label: 'Usage',
                items: _usages,
                onChanged: (value) {
                  setState(() {
                    _usage = value;
                  });
                },
                icon: Icons.assignment,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nombre de places',
                controller: _nbrePlaceController,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer le nombre de places'
                    : null,
                icon: Icons.airline_seat_recline_normal,
              ),
              const SizedBox(height: 16),
              ..._buildCouvertureCheckboxes(),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Durée',
                controller: _dureeController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Veuillez entrer la durée'
                    : null,
                icon: Icons.date_range,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCar, // Utiliser la méthode _saveCar
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  List<Widget> _buildCouvertureCheckboxes() {
    return _couvertureOptions.map((option) {
      return CheckboxListTile(
        title: Text(option),
        value: _typesCouverture.contains(option),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _typesCouverture.add(option);
            } else {
              _typesCouverture.remove(option);
            }
          });
        },
      );
    }).toList();
  }

  void _saveCar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Créer une instance de Car avec les données du formulaire
      final car = Car(
        vin: _vinController.text,
        matricule: _matriculeController.text,
        marque: _marque!,
        modele: _modele!,
        annee: int.tryParse(_anneeController.text) ?? 0,
        nomProprietaire: _nomProprietaireController.text,
        usage: _usage!,
        puissance: _puissance!,
        nbrePlace: int.tryParse(_nbrePlaceController.text) ?? 0,
        typesCouverture: _typesCouverture,
        duree: _dureeController.text,
      );

      // Ajouter la voiture via le Cubit

      // Naviguer vers la page de liste des voitures
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(car: car),
        ),
      );

      // Réinitialiser le formulaire
      _vinController.clear();
      _matriculeController.clear();
      _anneeController.clear();
      _nomProprietaireController.clear();
      _nbrePlaceController.clear();
      _dureeController.clear();
      setState(() {
        _marque = null;
        _modele = null;
        _usage = null;
        _puissance = null;
        _typesCouverture = [];
      });
    }
  }
}
