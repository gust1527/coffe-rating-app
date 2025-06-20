import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/widgets/nordic_coffee_bean_list_item.dart';
import 'package:coffe_rating_app_impl/ux_elements/AddCoffeBean.dart';
import 'package:coffe_rating_app_impl/ux_elements/SetBeanInMachine.dart';
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';

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
  bool _isLoading = false;
  bool _disposed = false;
  
  @override
  void initState() {
    super.initState();
    CoffeeLogger.ui('Initializing coffee bean type list');
    _loadCoffeeBeans();
  }

  @override
  void dispose() {
    CoffeeLogger.ui('Disposing coffee bean type list');
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadCoffeeBeans() async {
    if (_disposed) return;
    CoffeeLogger.ui('Loading coffee beans');
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<FirebaseDBStrategy>(context, listen: false);
      await provider.initialize();
      CoffeeLogger.ui('Successfully loaded coffee beans');
    } catch (e, stackTrace) {
      CoffeeLogger.error('Failed to load coffee beans', e, stackTrace);
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load coffee beans: $e'),
            backgroundColor: NordicColors.error,
          ),
        );
      }
    } finally {
      if (!_disposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  void _handleBeanTap(CoffeBeanType bean) {
    CoffeeLogger.ui('Bean tapped: ${bean.beanMaker} ${bean.beanType}');
    Navigator.pushNamed(
      context,
      '/bean-details',
      arguments: bean.id,
    );
  }

  void _handleSetInMachine(CoffeBeanType bean) async {
    if (_disposed) return;
    CoffeeLogger.ui('Setting bean in machine: ${bean.beanMaker} ${bean.beanType}');

    try {
      final provider = Provider.of<FirebaseDBStrategy>(context, listen: false);
      await provider.setCoffeBeanToMachine(bean.id);
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${bean.beanType} is now in the machine'),
            backgroundColor: NordicColors.success,
          ),
        );
      }
    } catch (e, stackTrace) {
      CoffeeLogger.error('Failed to set bean in machine', e, stackTrace);
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set bean in machine: $e'),
            backgroundColor: NordicColors.error,
          ),
        );
      }
    }
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
              child: Consumer<FirebaseDBStrategy>(
                builder: (context, provider, child) {
                  if (_isLoading) {
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
                    CoffeeLogger.ui('No coffee beans found');
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
                          onTap: () => _handleBeanTap(bean),
                          showMachineActions: true,
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
      child: Text(
        'My Roasts',
        style: NordicTypography.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
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


