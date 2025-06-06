import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/pages/coffee_bean_details_page.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';

class MachineTab extends StatelessWidget {
  const MachineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeBeanDBProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
            ),
          );
        }

        if (provider.error != null) {
          return _buildErrorState(provider);
        }

        final currentBean = provider.currentCoffeeBean;
        
        if (currentBean == null) {
          return _buildEmptyMachineState();
        }

        // Show the coffee bean details page for the current machine bean
        return CoffeeBeanDetailsPage(
          bean: currentBean,
          isCommunityBean: false,
          showBackButton: false,
        );
      },
    );
  }

  Widget _buildErrorState(CoffeBeanDBProvider provider) {
    return Scaffold(
      backgroundColor: NordicColors.background,
      body: SafeArea(
        child: Center(
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
                  'Something went wrong',
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
        ),
      ),
    );
  }

  Widget _buildEmptyMachineState() {
    return Scaffold(
      backgroundColor: NordicColors.background,
      body: SafeArea(
        child: Center(
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
                    border: Border.all(
                      color: NordicColors.divider,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.coffee_maker_outlined,
                    size: 60,
                    color: NordicColors.textSecondary,
                  ),
                ),
                const SizedBox(height: NordicSpacing.xl),
                Text(
                  'Machine is Empty',
                  style: NordicTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: NordicSpacing.md),
                Text(
                  'Go to "My Roasts" to select a coffee bean\nfor your machine',
                  style: NordicTypography.bodyLarge.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: NordicSpacing.xxl),
                Container(
                  padding: const EdgeInsets.all(NordicSpacing.lg),
                  decoration: BoxDecoration(
                    color: NordicColors.surface,
                    borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                    border: Border.all(
                      color: NordicColors.divider,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: NordicColors.caramel,
                        size: 32,
                      ),
                      const SizedBox(height: NordicSpacing.md),
                      Text(
                        'Tip',
                        style: NordicTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: NordicColors.caramel,
                        ),
                      ),
                      const SizedBox(height: NordicSpacing.sm),
                      Text(
                        'Use the "My Roasts" tab to browse your coffee collection and set a bean in your machine.',
                        style: NordicTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 