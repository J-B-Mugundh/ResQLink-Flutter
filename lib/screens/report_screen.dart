import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportScreen extends StatefulWidget {
  static const String routeName = '/report-incident';

  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Process data (e.g., send to Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incident reported')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFDFE),
      appBar: AppBar(
        title: const Text('Report New Incident'),
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
                'Provide details about the incident below.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Incident Title / Type',
                  hintText:
                      'e.g., Building Collapse, Flood, Fire',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText:
                      'Provide a brief description of the situation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location Details',
                  hintText:
                      'e.g., Near City Mall, Sector 5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Severity Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.priority_high_rounded,
                  ),
                ),
                value: 'Level 1',
                items:
                    ['Level 1', 'Level 2', 'Level 3']
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a severity level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Upload Image (Optional)',
                style:
                    Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  child:
                      _image != null
                          ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                          : Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons
                                      .add_a_photo_outlined,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to select image',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.white,
                ), // Icon color
                label: const Text('Submit Report'),
                onPressed: _submitReport,
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
