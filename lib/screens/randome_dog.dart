import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DogImageScreen extends StatefulWidget {
  @override
  _DogImageScreenState createState() => _DogImageScreenState();
}

class _DogImageScreenState extends State<DogImageScreen> {
  String _imageUrl = ''; // URL de l'image du chien
  bool _isLoading = false; // Indicateur de chargement

  // Fonction pour récupérer une image aléatoire de chien
  Future<void> _fetchRandomDogImage() async {
    setState(() {
      _isLoading = true; // Afficher l'indicateur de chargement
    });

    try {
      final response =
          await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _imageUrl = data['message']; // Mettre à jour l'URL de l'image
        });
      } else {
        throw Exception('Failed to load dog image');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _imageUrl = ''; // Réinitialiser l'URL en cas d'erreur
      });
    } finally {
      setState(() {
        _isLoading = false; // Masquer l'indicateur de chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Dog Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator() // Afficher un indicateur de chargement
            else if (_imageUrl.isNotEmpty)
              Image.network(
                _imageUrl,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              Text('Appuyez sur le bouton pour voir une image de chien'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchRandomDogImage,
              child: Text('Obtenir une image de chien'),
            ),
          ],
        ),
      ),
    );
  }
}
