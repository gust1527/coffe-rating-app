import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/core/widgets/coffee_rating_popup.dart';

class CoffeeBeanDetailsPage extends StatefulWidget {
  final CoffeBeanType bean;
  final bool isCommunityBean;

  const CoffeeBeanDetailsPage({
    super.key,
    required this.bean,
    this.isCommunityBean = false,
  });

  @override
  State<CoffeeBeanDetailsPage> createState() => _CoffeeBeanDetailsPageState();
}

class _CoffeeBeanDetailsPageState extends State<CoffeeBeanDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final rating = widget.bean.calculateMeanRating();
    final ratingCount = widget.bean.beanRating.length;

    return Scaffold(
      backgroundColor: NordicColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image
                    _buildHeroImage(),
                    
                    // Bean title and subtitle
                    _buildBeanInfo(),
                    
                    // Details section
                    _buildDetailsSection(),
                    
                    // Ratings section
                    if (ratingCount > 0) _buildRatingsSection(rating, ratingCount),
                    
                    // Reviews section
                    if (ratingCount > 0) _buildReviewsSection(),
                    
                    // Where to buy section (only for community beans)
                    if (widget.isCommunityBean) _buildWhereToBuySection(),
                    
                    // Action buttons
                    _buildActionButtons(),
                    
                    const SizedBox(height: NordicSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
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
              widget.isCommunityBean ? 'Community Roast' : 'My Roast Details',
              style: NordicTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance for centering
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
        child: Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: NordicColors.surface,
          ),
          child: widget.bean.hasImage
              ? Image.network(
                  widget.bean.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoadingImage();
                  },
                )
              : _buildPlaceholderImage(),
        ),
      ),
    );
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
          size: 80,
          color: NordicColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      color: NordicColors.surface,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
        ),
      ),
    );
  }

  Widget _buildBeanInfo() {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: NordicSpacing.lg),
          Text(
            '${widget.bean.beanMaker} ${widget.bean.beanType}',
            style: NordicTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: NordicSpacing.xs),
          Text(
            widget.isCommunityBean 
                ? 'Community roasted by ${widget.bean.beanMaker}'
                : 'Roasted by ${widget.bean.beanMaker}',
            style: NordicTypography.bodyMedium.copyWith(
              color: NordicColors.textSecondary,
            ),
          ),
          if (widget.bean.isInMachine) ...[
            const SizedBox(height: NordicSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NordicSpacing.md,
                vertical: NordicSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: NordicColors.caramel.withOpacity(0.1),
                borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                border: Border.all(
                  color: NordicColors.caramel.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: NordicColors.caramel,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: NordicSpacing.sm),
                  Text(
                    'Currently in Machine',
                    style: NordicTypography.labelMedium.copyWith(
                      color: NordicColors.caramel,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    final details = _getBeanDetails();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
      child: Column(
        children: details.entries.map((entry) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: NordicSpacing.lg),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: NordicColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    entry.key,
                    style: NordicTypography.bodyMedium.copyWith(
                      color: NordicColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: NordicSpacing.lg),
                Expanded(
                  child: Text(
                    entry.value,
                    style: NordicTypography.bodyMedium.copyWith(
                      color: NordicColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Map<String, String> _getBeanDetails() {
    final details = <String, String>{};
    
    // Basic details that all beans have
    details['Type'] = widget.bean.beanType;
    
    // Mock additional details - in a real app, these would come from the bean data
    if (widget.isCommunityBean) {
      details['Origin'] = 'Various Origins';
      details['Roast Level'] = 'Medium';
      details['Tasting Notes'] = 'Balanced, Smooth, Chocolatey';
      details['Process'] = 'Washed';
      details['Altitude'] = '1200-1800m';
    } else {
      details['Origin'] = 'Single Origin';
      details['Roast Level'] = 'Light to Medium';
      details['Tasting Notes'] = 'Bright, Floral, Citrus';
      details['Brewing Method'] = 'Pour-over, French Press';
    }
    
    return details;
  }

  Widget _buildRatingsSection(double rating, int ratingCount) {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ratings & Reviews',
            style: NordicTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: NordicSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: NordicTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                    ),
                  ),
                  const SizedBox(height: NordicSpacing.xs),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.round() ? Icons.star : Icons.star_border,
                        size: 18,
                        color: NordicColors.ratingGold,
                      );
                    }),
                  ),
                  const SizedBox(height: NordicSpacing.xs),
                  Text(
                    '$ratingCount ${ratingCount == 1 ? 'review' : 'reviews'}',
                    style: NordicTypography.bodyMedium,
                  ),
                ],
              ),
              
              const SizedBox(width: NordicSpacing.xl),
              
              // Rating distribution
              Expanded(
                child: _buildRatingDistribution(ratingCount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(int totalRatings) {
    // Mock rating distribution - in a real app, this would be calculated from actual ratings
    final distribution = [
      {'stars': 5, 'count': (totalRatings * 0.5).round(), 'percentage': 50},
      {'stars': 4, 'count': (totalRatings * 0.3).round(), 'percentage': 30},
      {'stars': 3, 'count': (totalRatings * 0.1).round(), 'percentage': 10},
      {'stars': 2, 'count': (totalRatings * 0.05).round(), 'percentage': 5},
      {'stars': 1, 'count': (totalRatings * 0.05).round(), 'percentage': 5},
    ];

    return Column(
      children: distribution.map((item) {
        final percentage = item['percentage'] as int;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '${item['stars']}',
                  style: NordicTypography.bodyMedium,
                ),
              ),
              const SizedBox(width: NordicSpacing.sm),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: NordicColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: NordicColors.textPrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: NordicSpacing.sm),
              SizedBox(
                width: 40,
                child: Text(
                  '$percentage%',
                  style: NordicTypography.bodyMedium.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewsSection() {
    // Mock reviews - in a real app, these would come from the database
    final reviews = _getMockReviews();
    
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Column(
        children: reviews.map((review) => _buildReviewItem(review)).toList(),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: NordicSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: NordicColors.surface,
                backgroundImage: review['avatar'] != null 
                    ? NetworkImage(review['avatar']) 
                    : null,
                child: review['avatar'] == null 
                    ? Text(
                        review['name'][0].toUpperCase(),
                        style: NordicTypography.labelLarge.copyWith(
                          color: NordicColors.textPrimary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: NordicSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: NordicTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: NordicTypography.bodyMedium.copyWith(
                        color: NordicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: NordicSpacing.md),
          
          // Rating stars
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review['rating'] ? Icons.star : Icons.star_border,
                size: 20,
                color: NordicColors.ratingGold,
              );
            }),
          ),
          
          const SizedBox(height: NordicSpacing.md),
          
          // Review text
          Text(
            review['text'],
            style: NordicTypography.bodyLarge,
          ),
          
          const SizedBox(height: NordicSpacing.md),
          
          // Like/Dislike buttons
          Row(
            children: [
              _buildReactionButton(
                Icons.thumb_up_outlined,
                review['likes'],
                () => _handleReaction('like', review),
              ),
              const SizedBox(width: NordicSpacing.xl),
              _buildReactionButton(
                Icons.thumb_down_outlined,
                review['dislikes'],
                () => _handleReaction('dislike', review),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReactionButton(IconData icon, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: NordicColors.textSecondary,
          ),
          const SizedBox(width: NordicSpacing.sm),
          Text(
            count.toString(),
            style: NordicTypography.bodyMedium.copyWith(
              color: NordicColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhereToBuySection() {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where to Buy',
            style: NordicTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: NordicSpacing.md),
          Container(
            padding: const EdgeInsets.all(NordicSpacing.md),
            decoration: BoxDecoration(
              color: NordicColors.surface,
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
              border: Border.all(
                color: NordicColors.divider,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.bean.beanMaker} Cafe',
                    style: NordicTypography.titleMedium,
                  ),
                ),
                Icon(
                  Icons.location_on_outlined,
                  color: NordicColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Column(
        children: [
          if (!widget.isCommunityBean) ...[
            // Rate this coffee button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showRatingDialog(),
                icon: const Icon(Icons.star_outline),
                label: const Text('Rate this Coffee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NordicColors.caramel,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: NordicSpacing.md),
                ),
              ),
            ),
            const SizedBox(height: NordicSpacing.md),
          ],
          
          // Set in machine button (only if not already in machine)
          if (!widget.bean.isInMachine)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _setInMachine(),
                icon: const Icon(Icons.coffee_maker_outlined),
                label: const Text('Set in Machine'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: NordicColors.caramel,
                  side: const BorderSide(color: NordicColors.caramel),
                  padding: const EdgeInsets.symmetric(vertical: NordicSpacing.md),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockReviews() {
    return [
      {
        'name': 'Liam',
        'date': '2 weeks ago',
        'rating': 5,
        'text': 'This roast is exceptional! The floral notes are prominent, and it has a lovely, clean finish. Perfect for pour-over.',
        'likes': 15,
        'dislikes': 2,
        'avatar': null,
      },
      {
        'name': 'Sophia',
        'date': '1 month ago',
        'rating': 4,
        'text': 'A solid choice for a light roast. The citrus notes are refreshing, but I found it a bit too acidic for my taste.',
        'likes': 8,
        'dislikes': 1,
        'avatar': null,
      },
    ];
  }

  void _handleReaction(String type, Map<String, dynamic> review) {
    // Handle like/dislike reactions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type.capitalize()} reaction recorded'),
        backgroundColor: NordicColors.caramel,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(NordicSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
        ),
      ),
    );
  }

  void _showRatingDialog() async {
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
                bean: widget.bean,
                isModal: true,
                onRatingSubmitted: () {
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setInMachine() async {
    try {
      final provider = Provider.of<CoffeBeanDBProvider>(context, listen: false);
      await provider.setCoffeBeanToMachine(widget.bean.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Coffee bean set in machine!'),
            backgroundColor: NordicColors.success,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(NordicSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );
        Navigator.of(context).pop(); // Go back to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: NordicColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(NordicSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
            ),
          ),
        );
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 