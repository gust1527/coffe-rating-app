import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/widgets/coffee_rating_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeBeanInMachine extends StatefulWidget {
  const CoffeBeanInMachine({super.key});

  @override
  _CoffeBeanInMachineState createState() => _CoffeBeanInMachineState();
}

class _CoffeBeanInMachineState extends State<CoffeBeanInMachine> {

  @override
  void initState() {
    super.initState();
    // Initialize the provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FirebaseDBStrategy>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NordicColors.background,
      appBar: AppBar(
        title: Text(
          'Coffee Machine',
          style: NordicTypography.titleLarge,
        ),
        backgroundColor: NordicColors.background,
        foregroundColor: NordicColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Consumer<FirebaseDBStrategy>(
        builder: (context, provider, child) {
          // Handle loading state
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
                  ),
                  const SizedBox(height: NordicSpacing.md),
                  Text(
                    'Loading coffee data...',
                    style: NordicTypography.bodyMedium,
                  ),
                ],
              ),
            );
          }

          // Handle error state
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(NordicSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: NordicColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: NordicColors.error,
                      ),
                    ),
                    const SizedBox(height: NordicSpacing.lg),
                    Text(
                      'Oops! Something went wrong',
                      style: NordicTypography.titleMedium.copyWith(
                        color: NordicColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: NordicSpacing.sm),
                    Text(
                      provider.error!,
                      style: NordicTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: NordicSpacing.xl),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearError();
                        provider.initialize();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Get current coffee bean
          CoffeBeanType? currentBean = provider.currentCoffeeBean;

          // Handle case where no bean is in machine
          if (currentBean == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(NordicSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: NordicColors.surface,
                        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                      ),
                      child: const Icon(
                        Icons.coffee_maker_outlined,
                        size: 60,
                        color: NordicColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: NordicSpacing.lg),
                    Text(
                      'Machine is Empty',
                      style: NordicTypography.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: NordicSpacing.sm),
                    Text(
                      'Select a coffee bean from your collection to start brewing the perfect cup.',
                      style: NordicTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: NordicSpacing.xl),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to coffee list
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Choose Coffee'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Display the current coffee bean
          return SingleChildScrollView(
            padding: const EdgeInsets.all(NordicSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: NordicSpacing.lg),
                
                // Coffee illustration
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        NordicColors.primaryBrown.withOpacity(0.1),
                        NordicColors.caramel.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(NordicBorderRadius.xlarge),
                  ),
                  child: const Icon(
                    Icons.coffee,
                    size: 80,
                    color: NordicColors.primaryBrown,
                  ),
                ),
                
                const SizedBox(height: NordicSpacing.xl),
                
                // Coffee information card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(NordicSpacing.xl),
                  decoration: BoxDecoration(
                    color: NordicColors.surface,
                    borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentBean.beanMaker,
                        style: NordicTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: NordicSpacing.xs),
                      Text(
                        currentBean.beanType,
                        style: NordicTypography.titleMedium.copyWith(
                          color: NordicColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      if (currentBean.beanRating.isNotEmpty) ...[
                        const SizedBox(height: NordicSpacing.lg),
                        
                        // Rating display
                        Container(
                          padding: const EdgeInsets.all(NordicSpacing.md),
                          decoration: BoxDecoration(
                            color: NordicColors.ratingGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: NordicColors.ratingGold,
                                size: 24,
                              ),
                              const SizedBox(width: NordicSpacing.sm),
                              Text(
                                currentBean.calculateMeanRating().toStringAsFixed(1),
                                style: NordicTypography.titleLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: NordicSpacing.sm),
                              Text(
                                '(${currentBean.beanRating.length} ratings)',
                                style: NordicTypography.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: NordicSpacing.xxl),
                
                // Action Buttons
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(NordicSpacing.xl),
                  decoration: BoxDecoration(
                    color: NordicColors.background,
                    borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                    border: Border.all(color: NordicColors.divider),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Rate Your Experience',
                        style: NordicTypography.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: NordicSpacing.sm),
                      Text(
                        'Share your thoughts on this coffee',
                        style: NordicTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: NordicSpacing.xl),
                      
                      // Rate This Coffee button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showRatingPopup(currentBean),
                          icon: const Icon(Icons.star_outline),
                          label: const Text('Rate This Coffee'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: NordicSpacing.lg),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRatingPopup(CoffeBeanType bean) async {
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
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}