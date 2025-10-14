import 'package:flutter/material.dart';
import 'package:flutter_application_ghorerbazar/features/cart/cart_page.dart';
import 'package:flutter_application_ghorerbazar/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/global_providers.dart';
import '../auth/login_signup_page.dart';
import 'category_page.dart';
import 'food_image_scroller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    final categories = [
      'All',
      'Dates',
      'Ghee',
      'Masala',
      'Nuts',
      'Mustard Oil',
    ];

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ghorer Bazar'),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((cat) => Tab(text: cat)).toList(),
            onTap: (index) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryPage(category: categories[index]),
                ),
              );
            },
          ),
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
        body: Column(
          children: [
            const SizedBox(height: 150, child: FoodImageScroller()),
            const Expanded(
              child: Center(child: Text('Select a category from tabs above')),
            ),
          ],
        ),
      ),
    );
  }
}
