import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/widgets/coffee_card.dart';

class HorizontalCoffeeList extends StatelessWidget {
  final String title;
  final List<CoffeeCardData> coffees;
  final VoidCallback? onSeeAll;

  const HorizontalCoffeeList({
    super.key,
    required this.title,
    required this.coffees,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: NordicTypography.titleLarge,
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    foregroundColor: NordicColors.caramel,
                    padding: const EdgeInsets.symmetric(
                      horizontal: NordicSpacing.sm,
                      vertical: NordicSpacing.xs,
                    ),
                  ),
                  child: Text(
                    'See All',
                    style: NordicTypography.labelLarge.copyWith(
                      color: NordicColors.caramel,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: NordicSpacing.md),
        
        // Horizontal scrolling list with mouse support
        SizedBox(
          height: 280,
          child: coffees.isEmpty
              ? _buildEmptyState()
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
                    itemCount: coffees.length,
                    itemBuilder: (context, index) {
                      final coffee = coffees[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < coffees.length - 1 ? NordicSpacing.md : 0,
                        ),
                        child: CoffeeCard(
                          name: coffee.name,
                          rating: coffee.rating,
                          roastLevel: coffee.roastLevel,
                          imageUrl: coffee.imageUrl,
                          isInMachine: coffee.isInMachine,
                          onTap: coffee.onTap,
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: NordicColors.surface,
              borderRadius: BorderRadius.circular(NordicBorderRadius.large),
            ),
            child: const Icon(
              Icons.coffee_outlined,
              size: 40,
              color: NordicColors.textSecondary,
            ),
          ),
          const SizedBox(height: NordicSpacing.md),
          Text(
            'No coffee beans yet',
            style: NordicTypography.titleMedium.copyWith(
              color: NordicColors.textSecondary,
            ),
          ),
          const SizedBox(height: NordicSpacing.xs),
          Text(
            'Add some beans to get started',
            style: NordicTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class CoffeeCardData {
  final String name;
  final double? rating;
  final String? roastLevel;
  final String? imageUrl;
  final bool isInMachine;
  final VoidCallback? onTap;

  const CoffeeCardData({
    required this.name,
    this.rating,
    this.roastLevel,
    this.imageUrl,
    this.isInMachine = false,
    this.onTap,
  });
} 