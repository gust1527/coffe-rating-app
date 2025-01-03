import 'package:coffe_rating_app_impl/ux_elements/AddCoffeBean.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeBeanListItem.dart';

class CoffeBeanTypeList extends StatefulWidget {
  const CoffeBeanTypeList({super.key});

  @override
  _CoffeBeanTypeListState createState() => _CoffeBeanTypeListState();
}

class _CoffeBeanTypeListState extends State<CoffeBeanTypeList> {
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();
  late final Stream<QuerySnapshot> beanStream = db_provider.getDBStream();
  late List<CoffeBeanType> beanList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CoffeAppBar(appBarTitle: 'List of coffe beans',),
        backgroundColor: Colors.yellow[700],
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: beanStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Named boolean expressions for readability
              bool docsHasData = snapshot.hasData;
              bool docsIsNotEmpty = snapshot.data != null && snapshot.data!.docs.isNotEmpty;
              bool docsIsLoading = snapshot.connectionState == ConnectionState.waiting;

              // Return a widget based on the state of the stream
              if (docsIsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (!docsHasData || !docsIsNotEmpty) {
                // If the stream is empty, then show a message
                return const Center(
                  child: Text('No coffee beans found'),
                );
              }
              // Create a list of CoffeeBeanType objects from the snapshot
              // and display them in a ListView
              snapshot.data!.docs.forEach((DocumentSnapshot document) {
                final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                final CoffeBeanType beanType = CoffeBeanType.fromJson(data, document.id);
                beanList.add(beanType);
              });

              // Sort the list of CoffeeBeanType objects by the mean rating
              beanList.sort((a, b) => a.calculateMeanRating().compareTo(b.calculateMeanRating()));

              // If all the other checks are false, then the stream is ready to be displayed
              return ListView.separated(
                itemCount: beanList.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                  height: 0,
                  child: Divider(),
                ),
                itemBuilder: (context, index) {
                  // Create a CoffeeBeanType from the data
                  final beanType = beanList[index];

                  // Pass the beanType to the CoffeeBeanListItem, and return a list item
                  return CoffeeBeanListItem(bean: beanType);
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AddCoffeBean(),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8), // Add some spacing between the icon and the label
                  Text('Add Coffee Bean'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
