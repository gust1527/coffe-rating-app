import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/pages/coffee_bean_details_page.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/core/widgets/coffee_rating_popup.dart';

class NordicCoffeBeanListItem extends StatelessWidget {
  final CoffeBeanType bean;
  final VoidCallback? onTap;
  final bool showMachineActions;

  const NordicCoffeBeanListItem({
    super.key,
    required this.bean,
    this.onTap,
    this.showMachineActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final rating = bean.calculateMeanRating();
    
    return Container(
      margin: const EdgeInsets.only(bottom: NordicSpacing.xs),
      decoration: BoxDecoration(
        color: NordicColors.background,
        borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
        border: Border.all(
          color: NordicColors.surface,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => _navigateToDetails(context),
          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
          child: Padding(
            padding: const EdgeInsets.all(NordicSpacing.md),
            child: Row(
              children: [
                // Coffee image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.small),
                    color: NordicColors.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(NordicBorderRadius.small),
                    child: _buildCoffeeImage(),
                  ),
                ),
                
                const SizedBox(width: NordicSpacing.md),
                
                // Coffee details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coffee name
                      Text(
                        '${bean.beanMaker} ${bean.beanType}',
                        style: NordicTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: NordicSpacing.xs),
                      
                      // Rating display
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: NordicColors.ratingGold,
                          ),
                          const SizedBox(width: NordicSpacing.xs),
                          Text(
                            rating.toStringAsFixed(1),
                            style: NordicTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: NordicSpacing.sm),
                                                     Text(
                             '(${bean.beanRating.length} ${bean.beanRating.length == 1 ? 'rating' : 'ratings'})',
                             style: NordicTypography.bodyMedium.copyWith(
                               color: NordicColors.textSecondary,
                             ),
                           ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Navigation indicator
                _buildNavigationIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoffeeImage() {
    // Check if we have a valid image URL
    if (bean.imageUrl != null && bean.imageUrl!.isNotEmpty) {
      return Image.network(
        bean.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingImage();
        },
      );
    }
    // Fallback to placeholder if no image URL
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NordicColors.clay.withOpacity(0.3),
            NordicColors.oak.withOpacity(0.3),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.coffee,
          size: 24,
          color: NordicColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      color: NordicColors.surface,
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CoffeeBeanDetailsPage(
          bean: bean,
          isCommunityBean: false, // This is for private beans
        ),
      ),
    );
  }

  Widget _buildNavigationIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (bean.isInMachine)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: NordicSpacing.sm,
              vertical: NordicSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: NordicColors.caramel,
              borderRadius: BorderRadius.circular(NordicBorderRadius.small),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Text(
              'In Machine',
              style: NordicTypography.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        
        const SizedBox(height: NordicSpacing.xs),
        
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: NordicColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildMachineActions(BuildContext context) {
    if (bean.isInMachine) {
      // Show rate button for the current machine bean
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: NordicSpacing.sm,
              vertical: NordicSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: NordicColors.caramel,
              borderRadius: BorderRadius.circular(NordicBorderRadius.small),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Text(
              'In Machine',
              style: NordicTypography.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: NordicSpacing.sm),
          IconButton(
            onPressed: () => _showRatingPopup(context),
            icon: const Icon(Icons.star_outline),
            color: NordicColors.caramel,
            tooltip: 'Rate this coffee',
          ),
        ],
      );
    } else {
      // Show set in machine button
      return ElevatedButton.icon(
        onPressed: () => _setInMachine(context),
        icon: const Icon(Icons.coffee_maker_outlined, size: 16),
        label: const Text('Set in Machine'),
        style: ElevatedButton.styleFrom(
          backgroundColor: NordicColors.surface,
          foregroundColor: NordicColors.textPrimary,
          elevation: 0,
          minimumSize: const Size(120, 32),
          textStyle: NordicTypography.labelMedium,
        ),
      );
    }
  }

  void _showRatingPopup(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: NordicColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(NordicBorderRadius.popup),
              topRight: Radius.circular(NordicBorderRadius.popup),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CoffeeRatingPopup(
                bean: bean,
                isModal: true,
                onRatingSubmitted: () {
                  // Note: In a StatelessWidget, we can't call setState
                  // The parent will need to handle state updates
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setInMachine(BuildContext context) async {
    try {
      final provider = Provider.of<CoffeBeanDBProvider>(context, listen: false);
      await provider.setCoffeBeanToMachine(bean.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${bean.beanType} set in machine!'),
            backgroundColor: NordicColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: NordicColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );
      }
    }
  }
} 