import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:flutter/material.dart';

class AddCoffeBean extends StatelessWidget {
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();
  String beanMakerInput;
  String beanTypeInput;

  AddCoffeBean({super.key}) : beanMakerInput = '', beanTypeInput = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Coffee Bean'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              beanMakerInput = value;
            },
            decoration: const InputDecoration(
              labelText: 'Enter name of bean maker',
              contentPadding: EdgeInsets.only(top: 8.0), // Adjust the top padding here
            ),
          ),
          TextField(
            onChanged: (value) {
              beanTypeInput = value;
            },
            decoration: const InputDecoration(
              labelText: 'Enter name of bean type',
              contentPadding: EdgeInsets.only(top: 8.0), // Adjust the top padding here
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  db_provider.addCoffeBeanType(beanMakerInput, beanTypeInput);
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
