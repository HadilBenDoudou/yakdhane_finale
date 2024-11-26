import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () {
                // Afficher l'e-mail de l'utilisateur connecté
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("My Account"),
                    content: Text(
                      "Email: ${currentUser?.email ?? "Not available"}",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                // Déconnexion de Firebase
                await FirebaseAuth.instance.signOut();

                // Déconnexion de Google
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();

                // Retour à l'écran de connexion ou d'accueil
                Navigator.pushNamedAndRemoveUntil(
                    context, '/sign_in', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
