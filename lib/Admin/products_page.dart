import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  List<dynamic> _categories = [];
  File? _selectedImage;

  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _adresseIpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:9991/produits/categories'));
    if (response.statusCode == 200) {
      setState(() {
        _categories = json.decode(response.body);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedImage != null) {
      final uri = Uri.parse('http://10.0.2.2:9991/produits');
      final request = http.MultipartRequest('POST', uri);

      // Ajout des champs texte
      request.fields['nom'] = _nomController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['prix'] = _prixController.text;
      request.fields['quantite'] = _quantiteController.text;
      request.fields['categorie_id'] = _selectedCategory!;
      request.fields['adresse_ip'] = _adresseIpController.text; // Ajout de l'adresse IP

      // Ajout de l'image
      final imageFile = await http.MultipartFile.fromPath('image', _selectedImage!.path);
      request.files.add(imageFile);

      final response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produit ajouté avec succès !')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de l\'ajout du produit')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ajouter un produit')),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: SingleChildScrollView(
    child: Column(
    children: [
    TextFormField(
    controller: _nomController,
    decoration: InputDecoration(labelText: 'Nom du produit'),
    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
    ),
    TextFormField(
    controller: _descriptionController,
    decoration: InputDecoration(labelText: 'Description'),
    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
    ),
    TextFormField(
    controller: _prixController,
    decoration: InputDecoration(labelText: 'Prix'),
    keyboardType: TextInputType.number,
    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
    ),
    TextFormField(
    controller: _quantiteController,
    decoration: InputDecoration(labelText: 'Quantité'),
    keyboardType: TextInputType.number,
    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
    ),
    TextFormField(
    controller: _adresseIpController,
    decoration: InputDecoration(labelText: 'Adresse IP'),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Ce champ est obligatoire';
    }
    final ipRegex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$'); // Validation IPv4
    if (!ipRegex.hasMatch(value)) {
    return 'Adresse IP invalide';
    }
    return null;
    },
    ),
    DropdownButtonFormField<String>(
    value: _selectedCategory,
    hint: Text('Sélectionnez une catégorie'),
    items: _categories.map<DropdownMenuItem<String>>((category) {
    return DropdownMenuItem<String>(
    value: category['id'].toString(),
    child: Text(category['nom']),
    );
    }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
    ),
      SizedBox(height: 20),
      _selectedImage == null
          ? Text('Aucune image sélectionnée')
          : Image.file(_selectedImage!, height: 150),
      ElevatedButton.icon(
        onPressed: _pickImage,
        icon: Icon(Icons.image),
        label: Text('Importer une image'),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _submitForm,
        child: Text('Ajouter le produit'),
      ),
    ],
    ),
    ),
    ),
        ),
    );
  }
}

