import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/Produit.dart';

class ProductService {
  Future<List<Product>> fetchPopularProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:9991/produits/populaires'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Imprimez les données pour vérifier leur format
      print(data);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
