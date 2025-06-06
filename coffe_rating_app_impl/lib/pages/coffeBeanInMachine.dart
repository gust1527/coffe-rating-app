import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeBeanInMachine extends StatefulWidget {
  const CoffeBeanInMachine({super.key});

  @override
  _CoffeBeanInMachineState createState() => _CoffeBeanInMachineState();
}

class _CoffeBeanInMachineState extends State<CoffeBeanInMachine> {
  double beanRating = 0; // Default bean rating

  @override
  void initState() {
    super.initState();
    // Initialize the provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoffeBeanDBProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CoffeAppBar(appBarTitle: 'Current Coffee'),
      body: Consumer<CoffeBeanDBProvider>(
        builder: (context, provider, child) {
          // Handle loading state
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.error}',
                    style: TextStyle(color: Colors.red[300]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.initialize();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Get current coffee bean
          CoffeBeanType? currentBean = provider.currentCoffeeBean;

          // Handle case where no bean is in machine
          if (currentBean == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.coffee_maker_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No coffee bean in machine',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a coffee bean from the coffee list',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );

          }

          // Display the current coffee bean
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.coffee,
                  size: 100,
                  color: Colors.brown,
                ),
                const SizedBox(height: 20),
                Text(
                  currentBean.beanMaker,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  currentBean.beanType,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (currentBean.beanRating.isNotEmpty) ...[
                  Text(
                    'Average Rating: ${currentBean.calculateMeanRating().toStringAsFixed(1)} ⭐',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Total Ratings: ${currentBean.beanRating.length}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Rate this coffee:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: beanRating,
                  min: 0.0,
                  max: 5.0,
                  divisions: 5,
                  label: beanRating == 0 ? 'Select rating' : '${beanRating.toInt()} ⭐',
                  onChanged: (value) {
                    setState(() {
                      beanRating = value;
                    });
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : () async {
                      // Boolean expression for readability
                      bool beanRatingIsZero = beanRating == 0;

                      // If the bean rating is zero, then show a snackbar
                      if (beanRatingIsZero) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a rating greater than 0'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        try {
                          // Update the bean in the database
                          await provider.addRatingsToCoffeBeanType(currentBean.id, beanRating.toInt());
                          
                          // Reset the bean rating
                          setState(() {
                            beanRating = 0;
                          });
                          
                          // Show success snackbar
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Rating ${beanRating.toInt()} ⭐ added to ${currentBean.beanMaker} - ${currentBean.beanType}'),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add rating: $e'),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Submit Rating', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}