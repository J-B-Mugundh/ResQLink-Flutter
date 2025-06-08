import 'package:flutter/material.dart';

class RequestSuppliesScreen extends StatefulWidget {
  static const String routeName = '/request-supplies';

  const RequestSuppliesScreen({super.key});

  @override
  State<RequestSuppliesScreen> createState() =>
      _RequestSuppliesScreenState();
}

class _RequestSuppliesScreenState
    extends State<RequestSuppliesScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _supplyType;
  String? _urgency;

  final List<String> _supplyTypes = [
    'Medical Kits',
    'Food Rations',
    'Drinking Water',
    'Shelter Kits',
    'Tools & Equipment',
    'Other',
  ];
  final List<String> _urgencyLevels = [
    'High - Critical',
    'Medium - Urgent',
    'Low - Routine',
  ];

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process data (e.g., send to Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Supply request submitted (simulated)',
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFDFE),
      appBar: AppBar(
        title: const Text('Request Supplies'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Specify the supplies needed and their urgency.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Type of Supply',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                  ),
                ),
                value: _supplyType,
                hint: const Text('Select supply type'),
                items:
                    _supplyTypes
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _supplyType = value;
                  });
                },
                validator:
                    (value) =>
                        value == null
                            ? 'Please select a supply type'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity / Amount',
                  hintText:
                      'e.g., 10 kits, 50 liters, 20 units',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.format_list_numbered,
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity needed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Urgency Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.priority_high_rounded,
                  ),
                ),
                value: _urgency,
                hint: const Text('Select urgency'),
                items:
                    _urgencyLevels
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _urgency = value;
                  });
                },
                validator:
                    (value) =>
                        value == null
                            ? 'Please select an urgency level'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Delivery Location / Point',
                  hintText:
                      'e.g., CP Alpha, Sector 3 Tent Area',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify the delivery location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      'Detailed Explanation (Optional)',
                  hintText:
                      'Provide any specific details, brands, or justifications if necessary.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.notes_outlined,
                  ),
                ),
                maxLines: 3,
                // No validator for optional field
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.white,
                ), // Icon color
                label: const Text('Submit Request'),
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    236,
                    88,
                    88,
                  ), // Red background
                  foregroundColor:
                      Colors.white, // White text/icon
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ), // Similar padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // Rounded stadium border
                    side: BorderSide(
                      color: Colors.red.shade900,
                      width: 2,
                    ), // Border
                  ),
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ), // Text style
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
