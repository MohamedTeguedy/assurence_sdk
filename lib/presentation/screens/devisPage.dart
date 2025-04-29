import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../route.dart';
import '../components/custom_app_bar.dart';
// import '../../presentation/customs/intl_0.18.1/intl.dart';

class DevisPage extends StatelessWidget {
  final Map<String, dynamic> devisData;

  const DevisPage({super.key, required this.devisData});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'fr_MR', symbol: 'MRU');

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Votre Devis d\'Assurance',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDevisItem(
                        'Numéro contrat', devisData['numero_contrat']),
                    const Divider(),
                    _buildDevisItem('Véhicule',
                        '${devisData['marque']} ${devisData['modele']}'),
                    _buildDevisItem('Immatriculation', devisData['matricule']),
                    _buildDevisItem('Année', devisData['annee'].toString()),
                    const Divider(),
                    _buildDevisItem('Période',
                        'Du ${devisData['date_debut']} au ${devisData['date_fin']}'),
                    const Divider(),
                    _buildDevisItem(
                        'Puissance', '${devisData['puissance']} CV'),
                    _buildDevisItem('Usage', _mapUsageCode(devisData['usage'])),
                    const Divider(),
                    _buildDevisItem('Couvertures',
                        _formatCouvertures(devisData['types_couverture'])),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL à payer:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            formatter.format(
                                double.parse(devisData['prime_totale'])),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _processPayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('PAYER CE DEVIS',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String _mapUsageCode(String code) {
    switch (code) {
      case 'A01':
        return 'Usage personnel';
      case 'A02':
        return 'Transport';
      case 'A03':
        return 'Professionnel';
      default:
        return 'Autre usage';
    }
  }

  String _formatCouvertures(dynamic couvertures) {
    if (couvertures is List) {
      return couvertures.join('\n');
    }
    return couvertures.toString();
  }

  void _processPayment(BuildContext context) {
    // Implémentez votre logique de paiement ici
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paiement'),
        content: const Text('Voulez-vous procéder au paiement maintenant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
