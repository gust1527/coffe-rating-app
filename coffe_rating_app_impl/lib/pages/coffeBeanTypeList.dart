import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/widgets/nordic_coffee_bean_list_item.dart';
import 'package:coffe_rating_app_impl/ux_elements/AddCoffeBean.dart';
import 'package:coffe_rating_app_impl/ux_elements/SetBeanInMachine.dart';

enum SortOption {
  ratingHigh('Rating: High to Low'),
  ratingLow('Rating: Low to High'),
  nameAZ('Name: A to Z'),
  nameZA('Name: Z to A'),
  maker('Maker');

  const SortOption(this.label);
  final String label;
}

class NordicCoffeBeanTypeList extends StatefulWidget {
  const NordicCoffeBeanTypeList({super.key});

  @override
  State<NordicCoffeBeanTypeList> createState() => _NordicCoffeBeanTypeListState();
}

class _NordicCoffeBeanTypeListState extends State<NordicCoffeBeanTypeList> {
  SortOption _currentSort = SortOption.ratingHigh;
  
  @override
  void initState() {
    super.initState();
    // Initialize the provider if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CoffeBeanDBProvider>(context, listen: false).initialize();
    });
  }

  List<CoffeBeanType> _sortCoffeeBeans(List<CoffeBeanType> beans) {
    final sortedBeans = List<CoffeBeanType>.from(beans);
    
    switch (_currentSort) {
      case SortOption.ratingHigh:
        sortedBeans.sort((a, b) => b.calculateMeanRating().compareTo(a.calculateMeanRating()));
        break;
      case SortOption.ratingLow:
        sortedBeans.sort((a, b) => a.calculateMeanRating().compareTo(b.calculateMeanRating()));
        break;
      case SortOption.nameAZ:
        sortedBeans.sort((a, b) => '${a.beanMaker} ${a.beanType}'.compareTo('${b.beanMaker} ${b.beanType}'));
        break;
      case SortOption.nameZA:
        sortedBeans.sort((a, b) => '${b.beanMaker} ${b.beanType}'.compareTo('${a.beanMaker} ${a.beanType}'));
        break;
      case SortOption.maker:
        sortedBeans.sort((a, b) => a.beanMaker.compareTo(b.beanMaker));
        break;
    }
    
    return sortedBeans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NordicColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(context),
            
            // Sort dropdown
            _buildSortSection(),
            
            // Coffee beans list
            Expanded(
              child: Consumer<CoffeBeanDBProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
                      ),
                    );
                  }
                  
                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: NordicSpacing.md),
                          Text(
                            'Error loading coffee beans',
                            style: NordicTypography.titleMedium.copyWith(
                              color: NordicColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: NordicSpacing.xs),
                          Text(
                            provider.error!,
                            style: NordicTypography.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (provider.coffeeBeans.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  final sortedBeans = _sortCoffeeBeans(provider.coffeeBeans);
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
                    itemCount: sortedBeans.length,
                    itemBuilder: (context, index) {
                      final bean = sortedBeans[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: NordicSpacing.xs),
                        child: NordicCoffeBeanListItem(
                          bean: bean,
                          onTap: () => _showBeanOptions(context, bean),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(context),
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
              'My Roasts',
              style: NordicTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), // Balance for centering
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NordicSpacing.md,
        vertical: NordicSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: NordicSpacing.sm,
              vertical: NordicSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: NordicColors.surface,
              borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
              border: Border.all(
                color: NordicColors.clay.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SortOption>(
                value: _currentSort,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: NordicColors.textSecondary,
                  size: 20,
                ),
                style: NordicTypography.bodyMedium.copyWith(
                  color: NordicColors.textSecondary,
                ),
                dropdownColor: NordicColors.surface,
                borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                items: SortOption.values.map((option) {
                  return DropdownMenuItem<SortOption>(
                    value: option,
                    child: Text(
                      option.label,
                      style: NordicTypography.bodyMedium.copyWith(
                        color: NordicColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (SortOption? value) {
                  if (value != null) {
                    setState(() {
                      _currentSort = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
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
          const SizedBox(height: NordicSpacing.lg),
          Text(
            'No coffee beans yet',
            style: NordicTypography.titleMedium.copyWith(
              color: NordicColors.textSecondary,
            ),
          ),
          const SizedBox(height: NordicSpacing.xs),
          Text(
            'Add your first coffee bean to get started',
            style: NordicTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddBeanDialog(context),
      backgroundColor: NordicColors.caramel,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add),
      label: Text(
        'Add Bean',
        style: NordicTypography.labelLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showBeanOptions(BuildContext context, CoffeBeanType bean) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SetBeanInMachine(bean: bean),
    );
  }

  void _showAddBeanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddCoffeBean(),
    );
  }
}


