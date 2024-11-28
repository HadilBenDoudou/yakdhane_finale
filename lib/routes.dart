import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/sign_up/components/sign_up_form.dart';
import 'screens/complete_profile/components/complete_profile_form.dart';
import 'screens/sign_in/components/sign_form.dart'; // Import du fichier contenant SignForm

final Map<String, WidgetBuilder> routes = {

  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  '/login_success': (context) => const LoginSuccessScreen(),
  '/forgot_password': (context) => const ForgotPasswordScreen(),

  // Routes spécifiques
  '/signup_step1': (context) => const SignUpStep1(),
  '/signup_step2': (context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    return SignUpStep2(email: email);
  },


  // Route pour le formulaire de connexion
  '/signin': (context) => const SignFormScreen(),
};

// Gestion spécifique pour ProductsScreen (nécessite un argument)
Route<dynamic>? generateRoute(RouteSettings settings) {
  if (settings.name == ProductsScreen.routeName) {
    final int categoryId = settings.arguments as int;
    return MaterialPageRoute(
      builder: (context) => ProductsScreen(categoryId: categoryId),
    );
  }

  return null; // Renvoie null si aucune route correspond
}