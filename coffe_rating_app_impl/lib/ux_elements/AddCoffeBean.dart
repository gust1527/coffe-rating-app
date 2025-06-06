import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';

class AddCoffeBean extends StatefulWidget {
  const AddCoffeBean({super.key});

  @override
  State<AddCoffeBean> createState() => _AddCoffeBeanState();
}

class _AddCoffeBeanState extends State<AddCoffeBean> {
  final _formKey = GlobalKey<FormState>();
  final _beanMakerController = TextEditingController();
  final _beanTypeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _beanMakerController.dispose();
    _beanTypeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<CoffeBeanDBProvider>(context, listen: false);
      
      await provider.addCoffeBeanType(
        _beanMakerController.text.trim(),
        _beanTypeController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty 
          ? null 
          : _imageUrlController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Coffee bean added successfully!',
              style: NordicTypography.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: NordicColors.caramel,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add coffee bean: $e',
              style: NordicTypography.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: NordicColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(NordicSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Add Coffee Bean',
                style: NordicTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: NordicColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: NordicSpacing.lg),
              
              // Bean Maker Field
              TextFormField(
                controller: _beanMakerController,
                decoration: InputDecoration(
                  labelText: 'Bean Maker',
                  hintText: 'e.g., Blue Bottle, Stumptown',
                  prefixIcon: const Icon(Icons.business),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                    borderSide: const BorderSide(color: NordicColors.caramel, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the bean maker';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: NordicSpacing.md),
              
              // Bean Type Field
              TextFormField(
                controller: _beanTypeController,
                decoration: InputDecoration(
                  labelText: 'Bean Type',
                  hintText: 'e.g., Ethiopian Yirgacheffe, Colombian',
                  prefixIcon: const Icon(Icons.coffee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                    borderSide: const BorderSide(color: NordicColors.caramel, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the bean type';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: NordicSpacing.md),
              
              // Image URL Field (Optional)
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL (Optional)',
                  hintText: 'https://example.com/coffee-image.jpg',
                  prefixIcon: const Icon(Icons.image),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                    borderSide: const BorderSide(color: NordicColors.caramel, width: 2),
                  ),
                  helperText: 'Leave empty to use default placeholder',
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final uri = Uri.tryParse(value.trim());
                    if (uri == null || !uri.hasScheme) {
                      return 'Please enter a valid URL';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: NordicSpacing.xl),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: NordicColors.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: NordicSpacing.lg,
                        vertical: NordicSpacing.md,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: NordicTypography.labelLarge,
                    ),
                  ),
                  
                  const SizedBox(width: NordicSpacing.md),
                  
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NordicColors.caramel,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: NordicSpacing.xl,
                        vertical: NordicSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Add Bean',
                            style: NordicTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
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
