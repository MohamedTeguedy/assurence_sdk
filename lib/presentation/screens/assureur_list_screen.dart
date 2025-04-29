// }

import 'package:flutter/material.dart';
import '../../data/models/assureur_model.dart';
import '../../data/services/assureur_service.dart';
import '../../route.dart';
import '../components/custom_app_bar.dart';

class AssureurListScreen extends StatefulWidget {
  const AssureurListScreen({super.key});

  @override
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
    setState(() {
      _assureurs = assureurs;
      _isLoading = false;
    });
  }

  Widget _buildAssureurImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey.shade200,
            child: const Icon(Icons.business, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey.shade200,
            child:
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Choisir un Assureur',
        onBackPressed: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.home),
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
                        AppRoutes.carInfo,
                        arguments: assureur,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          _buildAssureurImage(assureur.imageUrl),
                          const SizedBox(width: 16),
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
