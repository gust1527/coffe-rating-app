import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/material.dart';

class SetBeanInMachine extends StatelessWidget {
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();
  final CoffeBeanType bean;

  SetBeanInMachine({super.key, required this.bean});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Put ${bean.beanType} in the machine?'),
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
                          db_provider.setCoffeBeanToMachine(bean.id);
                          Navigator.pop(context);
                          // Show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${bean.beanType} to the machine'),
                      duration: const Duration(seconds: 1),
                    ),
                  ); // Add missing semicolon here
                }, // Add missing closing parentheses here
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
