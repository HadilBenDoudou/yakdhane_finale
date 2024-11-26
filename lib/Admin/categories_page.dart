// category_form_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? nom;

  // Fonction pour envoyer les données au backend
  Future<void> addCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:9991/produits/categorie/ajouter'), // Remplacez par l'URL de votre backend
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'nom': nom}),
        );

        if (response.statusCode == 201) {
          // Si la catégorie est ajoutée avec succès, affichez un message de succès
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catégorie ajoutée avec succès!')),
          );
        } else {
          // Si l'ajout échoue, affichez une erreur
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'ajout de la catégorie')),
          );
        }
      } catch (e) {
        print("Erreur : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur de connexion avec le serveur')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une catégorie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nom de la catégorie",
                  hintText: "Entrez le nom de la catégorie",
                ),
                onSaved: (newValue) => nom = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le nom de la catégorie est requis";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addCategory,
                child: const Text("Ajouter la catégorie"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
