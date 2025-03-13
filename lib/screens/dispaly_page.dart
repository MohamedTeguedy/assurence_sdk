import 'package:flutter/material.dart';

class DisplayPage extends StatelessWidget {
  final String name;
  final String age;

  DisplayPage({required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations Saisies'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nom: $name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Âge: $age ans', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
