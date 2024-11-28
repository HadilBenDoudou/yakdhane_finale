import 'package:flutter/material.dart';
import '../../../models/Produit.dart';

class ProductImages extends StatelessWidget {
  final Product product;

  const ProductImages({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Si imageUrl est null, utilisez une image par défaut
    final imageUrl = product.imageUrl ?? 'assets/images/no_image.png'; // Image par défaut

    return Container(
      height: 300,
      child: PageView(
        children: [
          Image.network(
            imageUrl, // Ici l'image sera soit l'URL soit l'image par défaut
            fit: BoxFit.cover,
          ),
          // Vous pouvez ajouter d'autres images ici si vous en avez
        ],
      ),
    );
  }
}
