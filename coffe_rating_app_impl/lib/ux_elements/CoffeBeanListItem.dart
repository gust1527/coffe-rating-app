import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeBeanRatingBar.dart';
import 'package:flutter/material.dart';

class CoffeeBeanListItem extends StatelessWidget {
  final CoffeBeanType bean;

  const CoffeeBeanListItem({Key? key, required this.bean}) : super(key: key);

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
      ),
    );
  }
}
