import 'package:flutter/material.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/pages/coffee_bean_details_page.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

class CoffeeCard extends StatelessWidget {
  final String name;
  final String? roastLevel;
  final double? rating;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isInMachine;
  final CoffeBeanType? bean; // Optional bean for navigation
  final bool isCommunityBean;

  const CoffeeCard({
    super.key,
    required this.name,
    this.roastLevel,
    this.rating,
    this.imageUrl,
    this.onTap,
    this.isInMachine = false,
    this.bean,
    this.isCommunityBean = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (bean != null ? () => _navigateToDetails(context) : null),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: NordicColors.background,
          borderRadius: BorderRadius.circular(NordicBorderRadius.card),
          border: Border.all(
            color: NordicColors.surface,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coffee image with overlay badge
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(NordicBorderRadius.card),
                      topRight: Radius.circular(NordicBorderRadius.card),
                    ),
                    color: NordicColors.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(NordicBorderRadius.card),
                      topRight: Radius.circular(NordicBorderRadius.card),
                    ),
                    child: _buildCoffeeImage(),
                  ),
                ),
                // "In Machine" overlay badge
                if (isInMachine)
                  Positioned(
                    top: NordicSpacing.sm,
                    right: NordicSpacing.sm,
                    child: Container(
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Text(
                        'In Machine',
                        style: NordicTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Coffee details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(NordicSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Coffee name
                    Text(
                      name,
                      style: NordicTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: NordicSpacing.xs),
                  
                  // Rating and roast level
                  Row(
                    children: [
                      if (rating != null) ...[
                        Icon(
                          Icons.star,
                          size: 16,
                          color: NordicColors.ratingGold,
                        ),
                        const SizedBox(width: NordicSpacing.xs),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: NordicTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (roastLevel != null) ...[
                          const SizedBox(width: NordicSpacing.xs),
                          Text(
                            '•',
                            style: NordicTypography.bodyMedium,
                          ),
                        ],
                      ],
                      if (roastLevel != null) ...[
                        const SizedBox(width: NordicSpacing.xs),
                        Expanded(
                          child: Text(
                            roastLevel!,
                            style: NordicTypography.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeImage() {
    // Check if we have a valid image URL
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
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
          size: 48,
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
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    if (bean != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CoffeeBeanDetailsPage(
            bean: bean!,
            isCommunityBean: isCommunityBean,
          ),
        ),
      );
    }
  }
} 