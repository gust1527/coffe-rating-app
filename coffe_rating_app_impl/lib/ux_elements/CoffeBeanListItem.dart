import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProvider.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:coffe_rating_app_impl/ux_elements/CoffeBeanRatingBar.dart';
import 'package:coffe_rating_app_impl/ux_elements/SetBeanInMachine.dart';
import 'package:flutter/material.dart';

class CoffeeBeanListItem extends StatelessWidget {
  final CoffeBeanType bean;
  final CoffeBeanDBProvider dbProvider = CoffeBeanDBProvider();

  CoffeeBeanListItem({super.key, required this.bean});

  @override
  Widget build(BuildContext context) {
    final double rating = bean.calculateMeanRating();
    return ListTile(
      title: Wrap(
        direction: Axis.horizontal,
        children: [
          Text(
            '${bean.beanMaker} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Text('${bean.beanType}: '),
          const SizedBox(width: 5),
          Text(bean.calculateMeanRating().toStringAsFixed(1)),
        ],
      ),
      trailing: Container(
        alignment: Alignment.centerRight,
        width: 120,
        child: CoffeeBeanRatingBar(rating: rating),
      ),
      dense: true,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => SetBeanInMachine(bean: bean),
      ),
      onLongPress: () {
        // To DO: Add a dialog to show all ratings for bean type
      },
      selected: bean.isInMachine,
      selectedTileColor: Colors.grey[300],
    );
  }
}
