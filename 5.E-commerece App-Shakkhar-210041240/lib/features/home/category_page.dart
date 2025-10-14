import 'package:flutter/material.dart';
import 'package:flutter_application_ghorerbazar/features/cart/cart_page.dart';
import 'package:flutter_application_ghorerbazar/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/sample_products.dart';
import '../../widget/product_card.dart';
import '../../models/product.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Filter products by category. "All" shows everything
    final List<Product> products = category == 'All'
        ? sampleProducts
        : sampleProducts.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
  title: Text(category),
  actions: [
    Consumer(
      builder: (context, ref, _) {
        final totalItems = ref.watch(cartProvider).fold<int>(
            0, (previousValue, item) => previousValue + item.quantity);
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
            if (totalItems > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    totalItems.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
          ],
        );
      },
    ),
  ],
),

body: GridView.builder(
  padding: const EdgeInsets.all(8),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return ProductCard(product: product); // <-- corrected
  },
),

    );
  }
}
