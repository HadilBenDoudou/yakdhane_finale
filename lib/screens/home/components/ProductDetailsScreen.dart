import 'package:flutter/material.dart';
import '../../../models/Produit.dart';

class ProductDetailsScreen extends StatefulWidget {
  static String routeName = "/product_details";
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // Quantité par défaut

  void addToCart() {
    // Logique pour ajouter le produit au panier
    print("Produit ajouté au panier : ${widget.product.name}, Quantité : $quantity");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ajouté au panier : ${widget.product.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du produit"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec contrainte de taille explicite
            product.imageUrl != null
                ? Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3, // hauteur dynamique
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset(
                'assets/images/no_image.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prix : ${product.price.toStringAsFixed(2)} €',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description ?? "Description non disponible",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      // Positionner le bouton et le contrôle de la quantité au bas de l'écran
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            // Ajout de la contrainte pour le bouton
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 200), // Contrainte de largeur
              child: ElevatedButton(
                onPressed: addToCart,
                child: const Text('Ajouter au panier'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
