import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/widgets/hero_section.dart';
import 'package:coffe_rating_app_impl/core/widgets/horizontal_coffee_list.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanInMachine.dart';

class NordicHomePage extends StatelessWidget {
  const NordicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NordicColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              
              const SizedBox(height: NordicSpacing.lg),
              
              // Hero section
              HeroSection(
                title: 'Discover the best roasts',
                subtitle: 'Explore our curated selection of top-rated coffees, perfect for any brewing method.',
                buttonText: 'Explore',
                onButtonPressed: () {
                  // Navigate to coffee list or machine page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CoffeBeanInMachine(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: NordicSpacing.xxl),
              
              // Your Rated Roasts
              Consumer<CoffeBeanDBProvider>(
                builder: (context, provider, child) {
                  final ratedCoffees = _getRatedCoffees(provider.coffeeBeans);
                  
                  return HorizontalCoffeeList(
                    title: 'Your Rated Roasts',
                    coffees: ratedCoffees,
                    onSeeAll: () {
                      // Navigate to full list
                    },
                  );
                },
              ),
              
              const SizedBox(height: NordicSpacing.xxl),
              
              // Community Favorites (mock data for now)
              HorizontalCoffeeList(
                title: 'Community Favorites',
                coffees: _getCommunityFavorites(),
                onSeeAll: () {
                  // Navigate to community section
                },
              ),
              
              const SizedBox(height: NordicSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Row(
        children: [
          const SizedBox(width: 48), // Space for symmetry
          Expanded(
            child: Text(
              'Nordic Bean',
              style: NordicTypography.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
            child: IconButton(
              onPressed: () {
                // Search functionality
              },
              icon: const Icon(
                Icons.search,
                color: NordicColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CoffeeCardData> _getRatedCoffees(List<CoffeBeanType> coffeeBeans) {
    final userRatedCoffees = coffeeBeans
        .where((bean) => bean.beanRating.isNotEmpty)
        .map((bean) {
      final averageRating = bean.beanRating.isNotEmpty
          ? bean.beanRating.reduce((a, b) => a + b) / bean.beanRating.length
          : 0.0;
      
      return CoffeeCardData(
        name: '${bean.beanMaker} ${bean.beanType}',
        rating: averageRating,
        roastLevel: _getRandomRoastLevel(),
        isInMachine: bean.isInMachine,
        onTap: () {
          // Navigate to coffee detail
        },
      );
    }).toList();
    
    // If user has no rated coffees yet, provide some sample data for demo
    if (userRatedCoffees.isEmpty) {
      return [
        const CoffeeCardData(
          name: 'Blue Mountain',
          rating: 4.9,
          roastLevel: 'Medium Roast',
          isInMachine: true, // Show the overlay badge
        ),
        const CoffeeCardData(
          name: 'Colombia Supremo',
          rating: 4.3,
          roastLevel: 'Light Roast',
        ),
        const CoffeeCardData(
          name: 'Brazil Santos',
          rating: 4.1,
          roastLevel: 'Dark Roast',
        ),
        const CoffeeCardData(
          name: 'Hawaii Kona',
          rating: 4.7,
          roastLevel: 'Medium Roast',
        ),
      ];
    }
    
    return userRatedCoffees;
  }

  List<CoffeeCardData> _getCommunityFavorites() {
    // Mock data for community favorites - enough items to ensure scrolling
    return [
      const CoffeeCardData(
        name: 'Ethiopian Yirgacheffe',
        rating: 4.5,
        roastLevel: 'Light Roast',
      ),
      const CoffeeCardData(
        name: 'Guatemalan Antigua',
        rating: 4.2,
        roastLevel: 'Medium Roast',
      ),
      const CoffeeCardData(
        name: 'Kenyan AA',
        rating: 4.8,
        roastLevel: 'Light Roast',
        isInMachine: true, // Show overlay badge for demo
      ),
      const CoffeeCardData(
        name: 'Costa Rican Tarrazu',
        rating: 4.7,
        roastLevel: 'Medium Roast',
      ),
      const CoffeeCardData(
        name: 'Sumatran Mandheling',
        rating: 4.6,
        roastLevel: 'Dark Roast',
      ),
      const CoffeeCardData(
        name: 'Jamaican Blue Mountain',
        rating: 4.9,
        roastLevel: 'Medium Roast',
      ),
      const CoffeeCardData(
        name: 'Panama Geisha',
        rating: 4.8,
        roastLevel: 'Light Roast',
      ),
      const CoffeeCardData(
        name: 'Yemen Mocha',
        rating: 4.4,
        roastLevel: 'Dark Roast',
      ),
    ];
  }

  String _getRandomRoastLevel() {
    final roastLevels = ['Light Roast', 'Medium Roast', 'Dark Roast'];
    return roastLevels[DateTime.now().millisecond % roastLevels.length];
  }
} 