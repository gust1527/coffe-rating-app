import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/widgets/hero_section.dart';
import 'package:coffe_rating_app_impl/core/widgets/horizontal_coffee_list.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanInMachine.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/pages/profile_page.dart';

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
                  Navigator.of(context).pushNamed('/beans');
                },
              ),
              
              const SizedBox(height: NordicSpacing.xxl),
              
              // Your Rated Roasts
              Consumer<FirebaseDBStrategy>(
                builder: (context, provider, child) {
                  final ratedCoffees = _getRatedCoffees(provider.coffeeBeans);
                  
                  return HorizontalCoffeeList(
                    title: 'Your Rated Roasts',
                    coffees: ratedCoffees,
                    onSeeAll: () {
                      Navigator.pushNamed(context, '/beans');
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
                  Navigator.pushNamed(context, '/beans');
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
              onPressed: () => _navigateToProfile(context),
              icon: const Icon(
                Icons.person,
                color: NordicColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
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
        imageUrl: bean.imageUrl,
        bean: bean,
        isCommunityBean: false,
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
    ];
  }

  String _getRandomRoastLevel() {
    const levels = ['Light Roast', 'Medium Roast', 'Dark Roast'];
    return levels[DateTime.now().millisecondsSinceEpoch % levels.length];
  }
} 