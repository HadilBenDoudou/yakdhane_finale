import 'dart:io'; // Pour manipuler les fichiers
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart'; // Pour la gestion de la caméra et de la galerie
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Pour utiliser Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Pour enregistrer l'URL dans Firestore

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _imageFile; // Variable pour stocker l'image prise
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? imageUrl; // Variable pour stocker l'URL de l'image

  @override
  void initState() {
    super.initState();
    _loadImage(); // Charger l'image depuis Firestore au démarrage
  }

  // Méthode pour charger l'image depuis Firebase Storage
  Future<void> _loadImage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Obtenir l'URL de l'image de profil de Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        String? imageUrl = userDoc['profileImageUrl'];
        if (imageUrl != null) {
          setState(() {
            this.imageUrl = imageUrl; // Afficher l'image de l'utilisateur
          });
        }
      } catch (e) {
        print('Error loading image: $e');
      }
    }
  }

  // Méthode pour afficher un choix entre la caméra et la galerie
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Afficher un dialogue pour choisir entre la caméra ou la galerie
    final pickedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select image source'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (pickedSource != null) {
      final XFile? image = await _picker.pickImage(source: pickedSource);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path); // Mettre à jour l'image
        });
        _saveImage(image); // Sauvegarder l'image dans Firebase Storage
      }
    }
  }

  // Méthode pour sauvegarder l'image dans Firebase Storage
  Future<void> _saveImage(XFile image) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child('${user.uid}.png');
        await storageRef.putFile(File(image.path)); // Uploader l'image dans Firebase Storage
        String imageUrl = await storageRef.getDownloadURL(); // Obtenir l'URL de l'image

        // Enregistrer l'URL de l'image dans Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profileImageUrl': imageUrl,
        });

        setState(() {
          this.imageUrl = imageUrl; // Mettre à jour l'URL de l'image
        });
      } catch (e) {
        print('Error saving image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Afficher l'image de profil ou l'image prise
          CircleAvatar(
            backgroundImage: imageUrl == null
                ? const AssetImage("assets/images/Profile Image.png")
                : NetworkImage(imageUrl!) as ImageProvider,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: _pickImage, // Appeler la méthode pour choisir une image
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
