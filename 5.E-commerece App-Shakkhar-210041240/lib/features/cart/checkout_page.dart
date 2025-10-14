import 'package:flutter/material.dart';
import 'order_summary_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all address fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roadController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void goToSummary() {
    if (_formKey.currentState?.validate() ?? false) {
      // Combine all fields into a single address string
      final fullAddress = '''
Name: ${_nameController.text.trim()}
Road/Street: ${_roadController.text.trim()}
City: ${_cityController.text.trim()}
District: ${_districtController.text.trim()}
Postal Code: ${_postalController.text.trim()}
''';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSummaryPage(address: fullAddress),
        ),
      );
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(controller: _nameController, label: 'Full Name'),
              _buildTextField(controller: _roadController, label: 'Road / Street'),
              _buildTextField(controller: _cityController, label: 'City'),
              _buildTextField(controller: _districtController, label: 'District'),
              _buildTextField(controller: _postalController, label: 'Postal Code'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: goToSummary,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Continue', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
