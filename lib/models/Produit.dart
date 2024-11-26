class Product {
  final int id;
  final String name;
  final String? description; // Peut être null
  final String? imageUrl; // Peut être null
  final double price;

  Product({
    required this.id,
    required this.name,
    this.description, // Champs optionnels
    this.imageUrl, // Champs optionnels
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Valeur par défaut si null
      name: json['nom'] ?? "Nom non disponible", // Valeur par défaut
      description: json['description'], // Peut être null
      imageUrl: json['imagePath'], // Peut être null
      price: (json['prix'] as num?)?.toDouble() ?? 0.0, // Gère les null
    );
  }
}
