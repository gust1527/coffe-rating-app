import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/material.dart';

class CoffeBeanInMachine extends StatefulWidget {
  const CoffeBeanInMachine({Key? key}) : super(key: key);

  @override
  _CoffeBeanInMachineState createState() => _CoffeBeanInMachineState();
}

class _CoffeBeanInMachineState extends State<CoffeBeanInMachine> {
  final CoffeBeanProvider dbProvider = CoffeBeanProvider();
  late final Stream<QuerySnapshot> beanStream = dbProvider.getDBStream();

  double beanRating = 1; // Default bean rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffe Bean in Machine'),
        backgroundColor: Colors.white, // Add a valid color value here
      ),
      body: StreamBuilder(
        stream: beanStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Named boolean expressions for readability
          bool docsHasData = snapshot.hasData;
          bool docsIsNotEmpty = snapshot.data != null && snapshot.data!.docs.isNotEmpty;
          bool docsIsLoading = snapshot.connectionState == ConnectionState.waiting;

          // Return a widget based on the state of the stream
          if (docsIsLoading) {
            return const CircularProgressIndicator();
          } else if (!docsHasData || !docsIsNotEmpty) {
            // If the stream is loading, then show a Progress indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
              
              final DocumentSnapshot document = snapshot.data!.docs.firstWhere((doc) => doc['is_in_machine'] == true);
              // Cast document?.data() to Map<String, dynamic>
              final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

              // Create a CoffeeBeanType from the data
              CoffeBeanType beanType = CoffeBeanType.fromJson(data, document.id);

              

            // If all the other checks are false, then the stream is ready to be displayed
            return Column(
              children: [
                SizedBox(height: 20),
                Icon(
                  Icons.coffee,
                  size: 100,
                  color: Colors.brown,
                ),
                SizedBox(height: 20),
                Text(
                  beanType.beanType,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                Slider(
                  value: beanRating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: beanRating.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      beanRating = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Update the bean in the database
                    dbProvider.addRatingsToCoffeBeanType(beanType.id, beanRating.toInt());
                    // Show a snackbarss
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rating added to bean: ${beanType.id}'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  },
                  child: Text('Submit Rating'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}