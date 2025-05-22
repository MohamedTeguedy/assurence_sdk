import 'package:assurence_sdk/presentation/customs/bloc_9.0.0/lib/flutter_bloc.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assurence_sdk/business_logic/cubits/car_cubit.dart';
import '../../data/models/assureur_model.dart';
import '../../data/models/form_data_model.dart';
import '../../route.dart';
import '../../utils/duration_selection_arguments.dart';
import '../../utils/text_utils.dart';
import '../components/custom_app_bar.dart';

class CarInfoPage extends StatefulWidget {
  const CarInfoPage({super.key, required this.assureur});
  final Assureur assureur;

  @override
  CarInfoPageState createState() => CarInfoPageState();
}

class CarInfoPageState extends State<CarInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _anneeController = TextEditingController();
  final TextEditingController _nomProprietaireController =
      TextEditingController();
  final TextEditingController _nbrePlaceController = TextEditingController();

  Marque? _selectedMarque;
  Modele? _selectedModele;
  Usage? _selectedUsage;
  List<Couverture> _selectedCouvertures = [];
  String? _selectedPuissance;
  List<Couverture> _allCouvertures = [];

  List<String> get puissancesDisponibles {
    if (_selectedUsage == null) return [];
    return _selectedUsage!.puissances.map((p) => '$p').toList();
  }

  List<String> get placesDisponibles {
    if (_selectedUsage == null) return [];
    return _selectedUsage!.places.map((p) => '$p places').toList();
  }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Informations du Véhicule et Couvertures',
        showBackButton: true,
        onBackPressed: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.listAssureur),
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
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails du véhicule',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            _buildTextField('VIN', _vinController, Icons.confirmation_number),
            const SizedBox(height: 20),
            _buildTextField(
                'Matricule', _matriculeController, Icons.directions_car),
            const SizedBox(height: 20),
            _buildMarqueDropdown(state.marques),
            const SizedBox(height: 20),
            if (_selectedMarque != null && state.modeles != null)
              _buildModeleDropdown(state.modeles!),
            const SizedBox(height: 20),
            _buildTextField('Année', _anneeController, Icons.calendar_today,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField(
                'Propriétaire', _nomProprietaireController, Icons.person),
            const SizedBox(height: 20),
            _buildUsageDropdown(state.usages),
            const SizedBox(height: 20),
            if (_selectedUsage != null) _buildNbrePlaceDropdown(),
            const SizedBox(height: 20),
            if (_selectedUsage != null) _buildPuissanceDropdown(),
            const SizedBox(height: 20),
            Text(
              'Couvertures',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _buildCouverturesSection(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('SUIVANT'),
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
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPuissance,
          isExpanded: true,
          items: puissances.map((puissance) {
            return DropdownMenuItem<String>(
              value: puissance,
              child: Text(puissance),
            );
          }).toList(),
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

  Widget _buildNbrePlaceDropdown() {
    final places = placesDisponibles;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Nombre de places',
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
        prefixIcon: Icon(
          Icons.airline_seat_recline_normal,
          color: Colors.blueGrey[600],
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _nbrePlaceController.text.isEmpty
              ? null
              : '${_nbrePlaceController.text} places',
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[600]),
          items: places.map((place) {
            return DropdownMenuItem<String>(
              value: place,
              child: Text(
                place,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _nbrePlaceController.text =
                  newValue?.replaceAll(' places', '') ?? '';
            });
          },
          hint: Text(
            'Sélectionnez le nombre de places',
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
          // onChanged: (Usage? usage) {
          //   setState(() => _selectedUsage = usage);
          // },
          onChanged: (Usage? newValue) {
            setState(() {
              _selectedUsage = newValue;
              _selectedPuissance = null;
              _nbrePlaceController.clear();
            });
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
        return 'Transport de marchandises';
      case 'A03':
        return 'Professionnel';
      case 'A04':
        return 'Transport en commun';
      default:
        return code;
    }
  }

  Widget _buildCouverturesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _allCouvertures.map((couverture) {
            final isSelected = _selectedCouvertures.contains(couverture);
            final isMandatory = couverture.type == 'RESPONSABILITE_CIVILE';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: isMandatory
                    ? null
                    : () {
                        setState(() {
                          if (isSelected) {
                            _selectedCouvertures.remove(couverture);
                          } else {
                            _selectedCouvertures.add(couverture);
                          }
                        });
                      },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      // Checkbox moderne avec effet
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: isMandatory
                              ? Colors.blue.shade800.withOpacity(0.2)
                              : isSelected
                                  ? Colors.blue.shade800
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isMandatory
                                ? Colors.blue.shade800
                                : isSelected
                                    ? Colors.blue.shade800
                                    : Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: isSelected || isMandatory
                            ? Icon(
                                Icons.check,
                                size: 18,
                                color: isMandatory
                                    ? Colors.blue.shade800
                                    : Colors.white,
                              )
                            : null,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  cleanFrenchText(couverture.typeDisplay),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isMandatory
                                            ? Colors.blue.shade800
                                            : Colors.grey.shade800,
                                      ),
                                ),
                                if (isMandatory)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '(Obligatoire)',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cleanFrenchText(couverture.description),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _validateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMarque == null ||
          _selectedModele == null ||
          _selectedUsage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Veuillez remplir tous les champs obligatoires')),
        );
        return;
      }

      final carData = {
        'vin': _vinController.text,
        'matricule': _matriculeController.text,
        'marque': _selectedMarque!.nom,
        'modele': _selectedModele!.nom,
        'annee': _anneeController.text,
        'nomProprietaire': _nomProprietaireController.text,
        'usage': _selectedUsage!.code,
        'nbrePlace': _nbrePlaceController.text,
        'puissance': _selectedPuissance,
        'couvertures': _selectedCouvertures.map((c) => c.type).toList(),
      };

      Navigator.pushNamed(
        context,
        AppRoutes.durationSelection,
        arguments: DurationSelectionArguments(
          assureur: widget.assureur,
          carData: carData,
        ),
      );
    }
  }
}
