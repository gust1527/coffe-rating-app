import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeBeanRatingBar.dart';
import 'package:flutter/material.dart';

class CoffeeBeanListItem extends StatelessWidget {
  final CoffeBeanType bean;
  final CoffeBeanDBProvider db_provider = CoffeBeanDBProvider();

  CoffeeBeanListItem({super.key, required this.bean});

  @override
  Widget build(BuildContext context) {
    final double rating = bean.calculateMeanRating();
    return SizedBox(// Set a fixed height for the container
      child: ListTile(
        title: Row(
          children: [
            Text('${bean.beanType}: '),
            Text(bean.calculateMeanRating().toString()),
          ],
        ),
        trailing: Container(
          alignment: Alignment.centerRight,
            width: 120,
          child: CoffeeBeanRatingBar(rating: rating)),
        dense: false,
        onTap: () {
          // Add the coffee bean to the machine
          db_provider.setCoffeBeanToMachine(bean.id);

          // Show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${bean.beanType} to the machine'),
              duration: const Duration(seconds: 1),
            ),
          );
          
        },
      ),
    );
  }
}
