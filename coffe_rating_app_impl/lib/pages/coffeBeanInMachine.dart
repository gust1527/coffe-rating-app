import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/material.dart';

class CoffeBeanInMachine extends StatefulWidget {
  const CoffeBeanInMachine({Key? key}) : super(key: key);

  @override
  _CoffeBeanInMachineState createState() => _CoffeBeanInMachineState();
}

class _CoffeBeanInMachineState extends State<CoffeBeanInMachine> {
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();
  late final Stream<QuerySnapshot> beanStream = db_provider.getDBStream();

  double beanRating = 1; // Default bean rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffe Bean in Machine'),
        backgroundColor: Colors.yellow[700], // Add a valid color value here
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

            // Get the document from the snapshot
            DocumentSnapshot document = snapshot.data!.docs.firstWhere((element) => (element.data() as Map<String, dynamic>)['is_in_machine'] == true);

            // Create a CoffeeBeanType from the data
            CoffeBeanType beanType = CoffeBeanType.fromJson(document.data() as Map<String, dynamic>, document.id);

            // If all the other checks are false, then the stream is ready to be displayed
            return Column(
              children: [
                SizedBox(height: 20),
                const Icon(
                  Icons.coffee,
                  size: 100,
                  color: Colors.brown,
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(
                    beanType.beanMaker,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    beanType.beanType,
                    style: const TextStyle(fontSize: 24),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 40),
                Slider(
                  value: beanRating,
                  min: 1.0,
                  max: 5.0,
                  divisions: 8,
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
                    // Update the bean in the database
                    db_provider.addRatingsToCoffeBeanType(beanType.id, beanRating.toInt());

                    // Reset the bean ratingr
                    setState(() {
                      beanRating = 1;
                    });
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