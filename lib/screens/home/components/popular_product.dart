import 'package:flutter/material.dart';
import '../../../components/product_card.dart';
import '../../../models/Produit.dart';
import 'ProductDetailsScreen.dart';
import 'ProductService.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late List<Product> popularProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPopularProducts();
  }

  Future<void> loadPopularProducts() async {
    try {
      final products = await ProductService().fetchPopularProducts();
      setState(() {
        popularProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Erreur lors du chargement des produits populaires : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Produits Populaires",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : popularProducts.isEmpty
            ? const Center(child: Text("Aucun produit populaire trouvé."))
            : SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularProducts.length,
            itemBuilder: (context, index) {
              final product = popularProducts[index];
              return ProductCard(
                product: product,
                onPress: () {
                  // Navigation vers la page de détails produit
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product: product),  // Passage du produit
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
