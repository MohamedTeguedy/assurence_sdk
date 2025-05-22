import 'package:assurence_sdk/presentation/customs/bloc_9.0.0/lib/flutter_bloc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../business_logic/cubits/car_cubit.dart';
import '../../data/models/car_model.dart';
import '../../route.dart';
import '../../utils/confirmation_aguments.dart';
import '../../utils/duration_selection_arguments.dart';
import '../components/custom_app_bar.dart';

class DurationSelectionPage extends StatefulWidget {
  const DurationSelectionPage({super.key, required this.args});
  final DurationSelectionArguments args;

  @override
  DurationSelectionPageState createState() => DurationSelectionPageState();
}

class DurationSelectionPageState extends State<DurationSelectionPage> {
  final _formKey = GlobalKey<FormState>();
  late DateFormat _dateFormatter;
  final DateFormat _apiDateFormatter = DateFormat('yyyy-MM-dd');

  DateTime? _selectedDate;
  DateTime? _dateFin;
  int? _selectedDuree;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
    _loadDurees();
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('fr_FR');
    _dateFormatter = DateFormat('dd MMM yyyy', 'fr_FR');
    if (mounted) setState(() {});
  }

  void _loadDurees() {
    final carData = widget.args.carData;
    context.read<CarCubit>().fetchDurees(
          keyEntreprise: widget.args.assureur.nom,
          usage: carData['usage'],
          nbrePlace: _parseInt(carData['nbrePlace']),
          nbrePuissance: _parseInt(carData['puissance']),
        );
  }

  int _parseInt(dynamic value) {
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is int) return value;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Durée de couverture',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<CarCubit, CarState>(
        listener: (context, state) {
          if (state is DureeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Sélection de la durée'),
                  const SizedBox(height: 12),
                  _buildDureeCard(state),
                  const SizedBox(height: 25),
                  _buildSectionTitle('Date de début'),
                  const SizedBox(height: 12),
                  _buildDatePickerCard(),
                  if (_dateFin != null) ...[
                    const SizedBox(height: 20),
                    _buildEndDateCard(),
                  ],
                  const SizedBox(height: 35),
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey.shade800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildDureeCard(CarState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Durée en mois',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            _buildDureeDropdown(state),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.blue.shade800,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date de début',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedDate == null
                        ? 'Sélectionner une date'
                        : _dateFormatter.format(_selectedDate!),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _selectedDate == null
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndDateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100.withOpacity(0.3)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color: Colors.green.shade600,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date de fin estimée',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateFormatter.format(_dateFin!),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitForm,
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
        child: const Text('Valider la sélection'),
      ),
    );
  }

  Widget _buildDureeDropdown(CarState state) {
    if (state is DureeLoading) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: CircularProgressIndicator(strokeWidth: 2),
      ));
    }

    if (state is DureeError) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600),
            const SizedBox(width: 8),
            Flexible(
              child: Text('Erreur: ${state.message}',
                  style: TextStyle(color: Colors.red.shade600)),
            ),
          ],
        ),
      );
    }

    if (state is! DureeLoaded) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Chargement des options...'),
      ));
    }

    return DropdownButtonFormField<int>(
      value: _selectedDuree,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        hintText: 'Sélectionnez une durée',
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: Colors.white,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.blue.shade800,
        size: 28,
      ),
      items: state.durees.map((duree) {
        return DropdownMenuItem<int>(
          value: duree,
          child: Text(
            '$duree mois',
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDuree = value;
          if (_selectedDate != null) _calculateEndDate();
        });
      },
      validator: (value) =>
          value == null ? 'Veuillez sélectionner une durée' : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        if (_selectedDuree != null) _calculateEndDate();
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
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedDuree == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner une durée valide'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    final carData = widget.args.carData;
    final car = Car(
      vin: carData['vin'],
      matricule: carData['matricule'],
      marque: carData['marque'],
      modele: carData['modele'],
      annee: _parseInt(carData['annee']),
      nomProprietaire: carData['nomProprietaire'],
      usage: carData['usage'],
      nbrePlace: _parseInt(carData['nbrePlace']),
      typesCouverture: List<String>.from(carData['couvertures']),
      duree: _selectedDuree.toString(),
      puissance: carData['puissance']?.toString() ?? '',
      dateDebut: _apiDateFormatter.format(_selectedDate!),
      dateFin: _apiDateFormatter.format(_dateFin!),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.confirmation,
      arguments: ConfirmationArguments(
        car: car,
        assureur: widget.args.assureur,
      ),
    );
  }
}
