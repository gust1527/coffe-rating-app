import 'package:coffe_rating_app_impl/ux_elements/AddCoffeBean.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee List Page'),
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

              // If all the other checks are false, then the stream is ready to be displayed
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                  height: 0,
                  child: Divider(),
                ),
                itemBuilder: (context, index) {
                  // Get the document from the snapshot
                  final DocumentSnapshot document = snapshot.data!.docs[index];

                  // Cast document?.data() to Map<String, dynamic>
                  final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                  // Create a CoffeeBeanType from the data
                  final beanType = CoffeBeanType.fromJson(data, document.id);

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
