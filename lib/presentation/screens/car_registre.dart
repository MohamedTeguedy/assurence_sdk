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
  String? _selectedPuissance;

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
        title: const Text(
          'Détails du Véhicule & Options de Couverture',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.listAssureur),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<CarCubit, CarState>(
        listener: (context, state) {
          if (state is CarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CarLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
            );
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

          return Center(
            child: Text(
              'Chargement des données...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(CarDataLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations du véhicule',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 24),

            _buildTextField('VIN', _vinController, Icons.confirmation_number),
            const SizedBox(height: 20),

            _buildTextField(
                'Matricule', _matriculeController, Icons.directions_car),
            const SizedBox(height: 20),

            // Sélection de la marque
            _buildMarqueDropdown(state.marques),
            const SizedBox(height: 20),

            // Sélection du modèle
            if (_selectedMarque != null && state.modeles != null)
              _buildModeleDropdown(state.modeles!),
            const SizedBox(height: 20),

            _buildTextField('Année', _anneeController, Icons.calendar_today,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),

            _buildTextField(
                'Propriétaire', _nomProprietaireController, Icons.person),
            const SizedBox(height: 20),

            // Sélection de l'usage
            _buildUsageDropdown(state.usages),
            const SizedBox(height: 20),

            _buildTextField('Nombre de places', _nbrePlaceController,
                Icons.airline_seat_recline_normal,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),

            _buildPuissanceDropdown(),
            const SizedBox(height: 20),

            // Section des couvertures
            Text(
              'Couvertures d\'assurance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 12),
            _buildCouverturesSection(),
            const SizedBox(height: 20),

            // Durée de couverture
            _buildDureeField(),
            const SizedBox(height: 32),

            // Bouton de soumission
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'SUIVANT',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        prefixIcon: Icon(
          icon,
          color: Colors.blueGrey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Ce champ est obligatoire' : null,
    );
  }

  Widget _buildMarqueDropdown(List<Marque> marques) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Marque',
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Marque>(
          value: _selectedMarque,
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[600]),
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
          hint: Text(
            'Sélectionnez une marque',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      ),
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

  Widget _buildPuissanceDropdown() {
    final puissances = puissancesDisponibles;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Puissance fiscale',
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        prefixIcon: Icon(Icons.speed, color: Colors.blueGrey[600]),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPuissance,
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[600]),
          items: puissances
              .map((puissance) => DropdownMenuItem(
                    value: puissance,
                    child: Text(puissance),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPuissance = newValue;
            });
          },
          hint: Text(
            'Sélectionnez une puissance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeleDropdownWithModeles(List<Modele> modeles) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Modèle',
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Modele>(
          value: _selectedModele,
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[600]),
          items: modeles
              .map((modele) => DropdownMenuItem(
                    value: modele,
                    child: Text(modele.nom),
                  ))
              .toList(),
          onChanged: (Modele? modele) {
            setState(() => _selectedModele = modele);
          },
          hint: Text(
            'Sélectionnez un modèle',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsageDropdown(List<Usage> usages) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Usage',
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Usage>(
          value: _selectedUsage,
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[600]),
          items: usages
              .map((usage) => DropdownMenuItem(
                    value: usage,
                    child: Text(_mapUsageCode(usage.code)),
                  ))
              .toList(),
          onChanged: (Usage? usage) {
            setState(() => _selectedUsage = usage);
          },
          hint: Text(
            'Sélectionnez un usage',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      ),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: _allCouvertures
              .map((couverture) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      cleanFrenchText(couverture.typeDisplay),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      cleanFrenchText(couverture.description),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
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
                    activeColor: Theme.of(context).primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDureeField() {
    return TextFormField(
      controller: _dureeController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: 'Durée (mois)',
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.date_range,
          color: Colors.blueGrey[600],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      final duree = int.tryParse(_dureeController.text) ?? 0;

      // Calcul des dates
      final dateDebut = DateTime.now();
      final dateFin = dateDebut.add(Duration(days: 30 * duree));

      String formatDate(DateTime date) {
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }

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
        puissance: _selectedPuissance ?? '',
        dateDebut: formatDate(dateDebut),
        dateFin: formatDate(dateFin),
      );
      print('Date début: ${dateDebut.toIso8601String()}');
      print('Date fin: ${dateFin.toIso8601String()}');
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
