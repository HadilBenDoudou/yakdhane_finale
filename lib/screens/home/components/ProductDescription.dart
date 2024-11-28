import 'package:flutter/material.dart';

import '../../../models/Produit.dart';

class ProductDescription extends StatelessWidget {
  final Product product;
  final VoidCallback pressOnSeeMore;

  const ProductDescription({super.key, required this.product, required this.pressOnSeeMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Prix: ${product.price.toStringAsFixed(2)} €',
            style: const TextStyle(fontSize: 18, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Text(
            product.description ?? "Description non disponible",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: pressOnSeeMore,
            child: const Text("Voir plus"),
          ),
        ],
      ),
    );
  }
}
