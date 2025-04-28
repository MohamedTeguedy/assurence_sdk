import 'package:flutter/material.dart';

import '../../data/models/assureur_model.dart';
import '../../data/services/assureur_service.dart';
import '../../route.dart';

class AssureurListScreen extends StatefulWidget {
  const AssureurListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AssureurListScreenState createState() => _AssureurListScreenState();
}

class _AssureurListScreenState extends State<AssureurListScreen> {
  final AssureurService _assureurService = AssureurService();
  List<Assureur> _assureurs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssureurs();
  }

  Future<void> _loadAssureurs() async {
    final assureurs = await _assureurService.getAssureurs();
    setState(() {});
    _assureurs = assureurs;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir un Assureur'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _assureurs.length,
              itemBuilder: (context, index) {
                final assureur = _assureurs[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        // AppRoutes.carRegistration,
                        AppRoutes.carInfo,
                        arguments: assureur,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Logo de l'assureur
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              assureur.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Informations de l'assureur
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  assureur.nom,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  assureur.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
