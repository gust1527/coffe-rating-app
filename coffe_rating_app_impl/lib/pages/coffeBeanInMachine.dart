import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeAppBar.dart';
import 'package:flutter/material.dart';

class CoffeBeanInMachine extends StatefulWidget {
  const CoffeBeanInMachine({super.key});

  @override
  _CoffeBeanInMachineState createState() => _CoffeBeanInMachineState();
}

class _CoffeBeanInMachineState extends State<CoffeBeanInMachine> {
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();
  late final Stream<QuerySnapshot> beanStream = db_provider.getDBStream();

  double beanRating = 0; // Default bean rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CoffeAppBar(appBarTitle: 'Current Coffe',),
      body: StreamBuilder(
        stream: beanStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Named boolean expressions for readability
          bool docsHasData = snapshot.hasData;
          bool docsIsNotEmpty = snapshot.data != null && snapshot.data!.docs.isNotEmpty;
          bool docsIsLoading = snapshot.connectionState == ConnectionState.waiting;

          // Return a widget based on the state of the stream
          if (docsIsLoading) { // If the stream is loading, then show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (!docsHasData || !docsIsNotEmpty) { // If the stream has no data, then show a message
            return const Center(
              child: Text('Error fetching current bean in machine'),
            );
          } else {
            // Get the document from the snapshot
            DocumentSnapshot document = snapshot.data!.docs.firstWhere((element) => (element.data() as Map<String, dynamic>)['is_in_machine'] == true);

            // Create a CoffeeBeanType from the data
            CoffeBeanType currentBean = CoffeBeanType.fromJson(document.data() as Map<String, dynamic>, document.id);

            // If all the other checks are false, then the stream is ready to be displayed
            return Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.coffee,
                  size: 100,
                  color: Colors.brown,
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(
                    currentBean.beanMaker,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    currentBean.beanType,
                    style: const TextStyle(fontSize: 24),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 40),
                Slider(
                  value: beanRating,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label: beanRating.toString(),
                  onChanged: (value) {
                    setState(() {
                      beanRating = value;
                    });
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    // Boolean expression for readability
                    bool beanRatingIsZero = beanRating == 0;

                    // If the bean rating is zero, then show a snackbar
                    if (beanRatingIsZero) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a rating greater than 0'),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    } else {
                    // Update the bean in the database
                    db_provider.addRatingsToCoffeBeanType(currentBean.id, beanRating.toInt());
                    // Reset the bean ratingr
                    setState(() {
                      beanRating = 0;
                    });
                    // Show a snackbarss
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rating added to bean: ${currentBean.beanMaker} - ${currentBean.beanType}'),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                    }
                  },
                  child: const Text('Submit Rating'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}