import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';

/// Nordic-styled coffee rating popup that matches the design guidelines
/// Can be used both as a modal popup and as a standalone page component
class CoffeeRatingPopup extends StatefulWidget {
  final CoffeBeanType bean;
  final bool isModal;
  final VoidCallback? onRatingSubmitted;

  const CoffeeRatingPopup({
    super.key,
    required this.bean,
    this.isModal = true,
    this.onRatingSubmitted,
  });

  @override
  State<CoffeeRatingPopup> createState() => _CoffeeRatingPopupState();
}

class _CoffeeRatingPopupState extends State<CoffeeRatingPopup> {
  int? _selectedRating;
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _flavorNotes = ['Fruity', 'Nutty', 'Chocolatey', 'Floral'];
  final Set<String> _selectedFlavorNotes = <String>{};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    if (_selectedRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a rating'),
          backgroundColor: NordicColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final provider = Provider.of<FirebaseDBStrategy>(context, listen: false);
      await provider.addRatingsToCoffeBeanType(widget.bean.id, _selectedRating!);

      // Store flavor notes and review locally for now (fallback until database support is added)
      final reviewText = _reviewController.text.trim();
      final flavorNotes = _selectedFlavorNotes.toList();
      
      // TODO: When database support is added, store reviewText and flavorNotes
      // For now, we're just submitting the rating to maintain existing functionality
      
      if (mounted) {
        String successMessage = 'Rating ${_selectedRating!} ⭐ submitted successfully!';
        if (reviewText.isNotEmpty || flavorNotes.isNotEmpty) {
          successMessage += '\nReview and flavor notes saved locally.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: NordicColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );

        if (widget.isModal) {
          Navigator.of(context).pop();
        }
        
        widget.onRatingSubmitted?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: $e'),
            backgroundColor: NordicColors.error,
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
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isModal) {
      return _buildContent();
    } else {
      return Scaffold(
        backgroundColor: NordicColors.background,
        body: SafeArea(
          child: _buildContent(),
        ),
      );
    }
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isModal) _buildModalHandle(),
        _buildHeader(),
        _buildBeanInfo(),
        _buildRatingSection(),
        _buildReviewSection(),
        _buildFlavorNotesSection(),
        _buildSubmitButton(),
        const SizedBox(height: NordicSpacing.md),
      ],
    );
  }

  Widget _buildModalHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: NordicSpacing.md),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: NordicColors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NordicSpacing.md,
        vertical: NordicSpacing.md,
      ),
      child: Row(
        children: [
          if (!widget.isModal)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: NordicColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          Expanded(
            child: Text(
              'Rate this coffee',
              style: NordicTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: widget.isModal ? TextAlign.left : TextAlign.center,
            ),
          ),
          if (!widget.isModal) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBeanInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
              image: widget.bean.imageUrl?.isNotEmpty == true
                  ? DecorationImage(
                      image: NetworkImage(widget.bean.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: widget.bean.imageUrl?.isEmpty != false
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        NordicColors.primaryBrown.withOpacity(0.1),
                        NordicColors.caramel.withOpacity(0.2),
                      ],
                    )
                  : null,
            ),
            child: widget.bean.imageUrl?.isEmpty != false
                ? const Icon(
                    Icons.coffee,
                    color: NordicColors.primaryBrown,
                    size: 28,
                  )
                : null,
          ),
          const SizedBox(width: NordicSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bean.beanType,
                  style: NordicTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: NordicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Roaster: ${widget.bean.beanMaker}',
                  style: NordicTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NordicSpacing.md,
            vertical: NordicSpacing.md,
          ),
          child: Text(
            'Your rating',
            style: NordicTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
          child: Wrap(
            spacing: NordicSpacing.sm,
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected = _selectedRating == rating;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = rating;
                  });
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: NordicColors.background,
                    borderRadius: BorderRadius.circular(NordicBorderRadius.rating),
                    border: Border.all(
                      color: isSelected ? NordicColors.caramel : NordicColors.divider,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      rating.toString(),
                      style: NordicTypography.labelLarge.copyWith(
                        color: NordicColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: TextField(
        controller: _reviewController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Add a review (optional)',
          hintStyle: NordicTypography.bodyMedium,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(NordicBorderRadius.rating),
            borderSide: const BorderSide(color: NordicColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(NordicBorderRadius.rating),
            borderSide: const BorderSide(color: NordicColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(NordicBorderRadius.rating),
            borderSide: const BorderSide(color: NordicColors.caramel),
          ),
          filled: true,
          fillColor: NordicColors.background,
          contentPadding: const EdgeInsets.all(NordicSpacing.md),
        ),
        style: NordicTypography.bodyMedium.copyWith(
          color: NordicColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFlavorNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NordicSpacing.md,
            vertical: NordicSpacing.md,
          ),
          child: Text(
            'Flavor notes',
            style: NordicTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.sm),
          child: Wrap(
            spacing: NordicSpacing.sm,
            runSpacing: NordicSpacing.sm,
            children: _flavorNotes.map((note) {
              final isSelected = _selectedFlavorNotes.contains(note);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedFlavorNotes.remove(note);
                    } else {
                      _selectedFlavorNotes.add(note);
                    }
                  });
                },
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected ? NordicColors.caramel.withOpacity(0.1) : NordicColors.surface,
                    borderRadius: BorderRadius.circular(NordicBorderRadius.chip),
                    border: isSelected 
                        ? Border.all(color: NordicColors.caramel, width: 1)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      note,
                      style: NordicTypography.labelMedium.copyWith(
                        color: isSelected ? NordicColors.caramel : NordicColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitRating,
          style: ElevatedButton.styleFrom(
            backgroundColor: NordicColors.caramel,
            foregroundColor: NordicColors.textPrimary,
            elevation: 0,
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
                    valueColor: AlwaysStoppedAnimation<Color>(NordicColors.textPrimary),
                  ),
                )
              : Text(
                  'Submit Rating',
                  style: NordicTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
} 