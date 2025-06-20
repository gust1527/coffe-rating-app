import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';
import 'package:coffe_rating_app_impl/core/widgets/coffee_rating_popup.dart';

class CoffeBeanInMachine extends StatefulWidget {
  const CoffeBeanInMachine({super.key});

  @override
  State<CoffeBeanInMachine> createState() => _CoffeBeanInMachineState();
}

class _CoffeBeanInMachineState extends State<CoffeBeanInMachine> {
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    CoffeeLogger.ui('Initializing CoffeBeanInMachine view');
    _loadBeanInMachine();
  }

  @override
  void dispose() {
    CoffeeLogger.ui('Disposing CoffeBeanInMachine view');
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadBeanInMachine() async {
    if (_disposed) return;
    CoffeeLogger.ui('Loading bean currently in machine');
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<FirebaseDBStrategy>(context, listen: false);
      await provider.initialize();
      CoffeeLogger.ui('Successfully loaded bean in machine');
    } catch (e, stackTrace) {
      CoffeeLogger.error('Failed to load bean in machine', e, stackTrace);
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load bean: $e'),
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

  void _showRatingDialog(CoffeBeanType bean) {
    if (_disposed) return;
    CoffeeLogger.ui('Opening rating dialog for bean: ${bean.beanMaker} ${bean.beanType}');
    showDialog(
      context: context,
      builder: (context) => CoffeeRatingPopup(
        beanId: bean.id,
        beanName: '${bean.beanMaker} ${bean.beanType}',
        onSubmit: (rating) async {
          CoffeeLogger.ui('Submitting rating $rating for bean: ${bean.id}');
          final provider = Provider.of<FirebaseDBStrategy>(context, listen: false);
          await provider.addRatingsToCoffeBeanType(bean.id, rating);
          if (!_disposed) {
            Navigator.of(context).pop();
          }
        },
        onClose: () {
          CoffeeLogger.ui('Closing rating dialog');
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseDBStrategy>(
      builder: (context, provider, child) {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
            ),
          );
        }

        final currentBean = provider.currentCoffeeBean;

        if (currentBean == null) {
          CoffeeLogger.ui('No bean currently in machine');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.coffee_maker_outlined,
                  size: 64,
                  color: NordicColors.textSecondary,
                ),
                const SizedBox(height: NordicSpacing.md),
                Text(
                  'No coffee bean in machine',
                  style: NordicTypography.titleMedium.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                ),
                const SizedBox(height: NordicSpacing.sm),
                Text(
                  'Add a bean to start brewing',
                  style: NordicTypography.bodyMedium.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(NordicSpacing.lg),
                children: [
                  // Bean image
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: NordicColors.surface,
                      borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                      image: currentBean.imageUrl?.isNotEmpty == true
                          ? DecorationImage(
                              image: NetworkImage(currentBean.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: currentBean.imageUrl?.isEmpty != false
                        ? const Icon(
                            Icons.coffee,
                            size: 64,
                            color: NordicColors.caramel,
                          )
                        : null,
                  ),
                  const SizedBox(height: NordicSpacing.lg),

                  // Bean info
                  Text(
                    currentBean.beanType,
                    style: NordicTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NordicSpacing.sm),
                  Text(
                    'by ${currentBean.beanMaker}',
                    style: NordicTypography.bodyMedium.copyWith(
                      color: NordicColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NordicSpacing.lg),

                  // Rating info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Average Rating: ',
                        style: NordicTypography.bodyMedium,
                      ),
                      const Icon(
                        Icons.star,
                        color: NordicColors.caramel,
                        size: 20,
                      ),
                      const SizedBox(width: NordicSpacing.xs),
                      Text(
                        currentBean.calculateMeanRating().toStringAsFixed(1),
                        style: NordicTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${currentBean.beanRating.length} ratings)',
                        style: NordicTypography.bodyMedium.copyWith(
                          color: NordicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(NordicSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        CoffeeLogger.ui('Removing bean from machine');
                        provider.setCoffeBeanToMachine('');
                      },
                      icon: const Icon(Icons.coffee_maker_outlined),
                      label: const Text('Remove Bean'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: NordicColors.error,
                        side: const BorderSide(color: NordicColors.error),
                        padding: const EdgeInsets.symmetric(
                          vertical: NordicSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: NordicSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRatingDialog(currentBean),
                      icon: const Icon(Icons.star_outline),
                      label: const Text('Rate Bean'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NordicColors.caramel,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: NordicSpacing.md,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}