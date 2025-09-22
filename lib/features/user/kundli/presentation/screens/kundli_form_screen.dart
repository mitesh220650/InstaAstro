import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instaastro_clone/core/theme/app_theme.dart';
import 'package:instaastro_clone/features/user/kundli/data/models/kundli_model.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/providers/kundli_provider.dart';
import 'package:instaastro_clone/features/user/kundli/presentation/screens/kundli_result_screen.dart';
import 'package:intl/intl.dart';

class KundliFormScreen extends ConsumerStatefulWidget {
  const KundliFormScreen({super.key});

  @override
  ConsumerState<KundliFormScreen> createState() => _KundliFormScreenState();
}

class _KundliFormScreenState extends ConsumerState<KundliFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _tobController = TextEditingController();
  final _pobController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _saveProfile = true;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _tobController.dispose();
    _pobController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _tobController.text = picked.format(context);
      });
    }
  }
  
  Future<void> _generateKundli() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Create birth details object
      final birthDetails = BirthDetails(
        name: _nameController.text,
        dateOfBirth: _selectedDate!,
        timeOfBirth: _tobController.text,
        placeOfBirth: _pobController.text,
        latitude: 0.0, // This would be fetched from a geocoding service
        longitude: 0.0, // This would be fetched from a geocoding service
        timezone: 'Asia/Kolkata', // This would be determined based on location
      );
      
      try {
        // Generate kundli
        await ref.read(kundliStateProvider.notifier).generateKundli(birthDetails);
        
        // Save profile if checkbox is checked
        if (_saveProfile) {
          await ref.read(kundliStateProvider.notifier).saveProfile(birthDetails);
        }
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const KundliResultScreen(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Kundli'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Birth Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please provide accurate birth details for precise kundli generation',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Date of Birth
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Time of Birth
                TextFormField(
                  controller: _tobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Time of Birth',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectTime(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select time of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Place of Birth
                TextFormField(
                  controller: _pobController,
                  decoration: const InputDecoration(
                    labelText: 'Place of Birth',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter place of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Save profile checkbox
                CheckboxListTile(
                  value: _saveProfile,
                  onChanged: (value) {
                    setState(() {
                      _saveProfile = value ?? true;
                    });
                  },
                  title: const Text('Save this profile for future use'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),
                
                // Generate button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _generateKundli,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Generate Kundli'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
