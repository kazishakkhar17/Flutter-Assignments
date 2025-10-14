import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final double totalPrice;
  const PaymentPage({super.key, required this.totalPrice});

  void makePayment(BuildContext context) {
    // Simulate payment success
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text('Your payment of ৳ ${totalPrice.toStringAsFixed(0)} was successful!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst); // go back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Payment: ৳ ${totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => makePayment(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
