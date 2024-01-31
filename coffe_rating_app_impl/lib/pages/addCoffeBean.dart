import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:flutter/material.dart';

class AddCoffeBean extends StatelessWidget {
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();
  String input;

  AddCoffeBean({super.key}) : input = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Coffee Bean'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              input = value;
            },
            decoration: const InputDecoration(
              labelText: 'Enter name of bean type',
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
                child: Text('Cancel'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  db_provider.addCoffeBeanType(input);
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
