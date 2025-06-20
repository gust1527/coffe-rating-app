import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';

/// Nordic-styled coffee rating popup that matches the design guidelines
/// Can be used both as a modal popup and as a standalone page component
class CoffeeRatingPopup extends StatefulWidget {
  final String beanId;
  final String beanName;
  final Function(int rating) onSubmit;
  final VoidCallback onClose;

  const CoffeeRatingPopup({
    super.key,
    required this.beanId,
    required this.beanName,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<CoffeeRatingPopup> createState() => _CoffeeRatingPopupState();
}

class _CoffeeRatingPopupState extends State<CoffeeRatingPopup> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _flavorNotes = ['Fruity', 'Nutty', 'Chocolatey', 'Floral'];
  final Set<String> _selectedFlavorNotes = <String>{};
  bool _isSubmitting = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    CoffeeLogger.ui('Initializing rating popup for bean: ${widget.beanName}');
  }

  @override
  void dispose() {
    CoffeeLogger.ui('Disposing rating popup for bean: ${widget.beanName}');
    _disposed = true;
    _reviewController.dispose();
    super.dispose();
  }

  void _handleRatingChange(int rating) {
    if (_disposed) return;
    CoffeeLogger.ui('Rating changed to $rating for bean: ${widget.beanName}');
    setState(() {
      _selectedRating = rating;
    });
  }

  Future<void> _handleSubmit() async {
    if (_disposed) return;
    if (_selectedRating == 0) {
      CoffeeLogger.warning('Attempted to submit without selecting a rating');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: NordicColors.error,
        ),
      );
      return;
    }

    CoffeeLogger.ui(
      'Submitting rating $_selectedRating for bean: ${widget.beanName}'
    );
    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(_selectedRating);
      if (!_disposed) {
        CoffeeLogger.ui('Successfully submitted rating');
        widget.onClose();
      }
    } catch (e, stackTrace) {
      CoffeeLogger.error('Failed to submit rating', e, stackTrace);
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: $e'),
            backgroundColor: NordicColors.error,
          ),
        );
      }
    } finally {
      if (!_disposed) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NordicSpacing.lg),
      decoration: BoxDecoration(
        color: NordicColors.background,
        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate ${widget.beanName}',
                style: NordicTypography.headlineMedium,
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: NordicSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final rating = index + 1;
              return IconButton(
                onPressed: _isSubmitting ? null : () => _handleRatingChange(rating),
                icon: Icon(
                  rating <= _selectedRating
                      ? Icons.coffee
                      : Icons.coffee_outlined,
                  color: rating <= _selectedRating
                      ? NordicColors.caramel
                      : NordicColors.textSecondary,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: NordicSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: NordicColors.caramel,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: NordicSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(NordicBorderRadius.button),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Submit Rating'),
            ),
          ),
        ],
      ),
    );
  }
} 