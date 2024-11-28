import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart'; // Assurez-vous que cette constante est définie
import '../../../models/Produit.dart';
class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 160, // Largeur des cartes adaptées au défilement
    this.aspectRatio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRatio;
  final Product product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: onPress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du produit
              AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                      ? Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.broken_image,
                        size: 40,
                        color: kPrimaryColor.withOpacity(0.6),
                      );
                    },
                  )
                      : Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: kPrimaryColor.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Nom du produit
              Text(
                product.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Prix et bouton favori
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      print("Favori : ${product.name}");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: product.isPopular
                            ? kPrimaryColor.withOpacity(0.15)
                            : kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        colorFilter: ColorFilter.mode(
                          product.isPopular
                              ? const Color(0xFFFF4848)
                              : const Color(0xFFDBDEE4),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
