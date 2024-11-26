import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/custom_surfix_icon.dart'; // Assurez-vous que ce fichier existe et que l'icône est accessible.
import '../../../components/form_error.dart'; // Assurez-vous d'avoir un composant pour afficher les erreurs.

class SignUpStep2 extends StatefulWidget {
  final String email;

  const SignUpStep2({Key? key, required this.email}) : super(key: key);

  @override
  _SignUpStep2State createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> completeSignUpStep2() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9991/api/auth/signup/step2'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': widget.email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscription terminée avec succès!")),
      );

      // Redirection vers l'écran de connexion
      Navigator.pushReplacementNamed(context, '/signin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Étape 2 : Compléter le profil")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Complétez votre profil",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Ajoutez vos informations personnelles pour terminer l'inscription.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          hintText: 'Entrez votre prénom',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                        ),
                        onSaved: (newValue) => firstName = newValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Le prénom est obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nom de famille',
                          hintText: 'Entrez votre nom',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                        ),
                        onSaved: (newValue) => lastName = newValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Le nom de famille est obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Numéro de téléphone',
                          hintText: 'Entrez votre numéro',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                        ),
                        onSaved: (newValue) => phoneNumber = newValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Le numéro de téléphone est obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Adresse',
                          hintText: 'Entrez votre adresse',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location.svg"),
                        ),
                        onSaved: (newValue) => address = newValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "L'adresse est obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      FormError(errors: errors),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            completeSignUpStep2();
                          }
                        },
                        child: const Text("Terminer l'inscription"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
