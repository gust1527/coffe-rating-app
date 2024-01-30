import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/material.dart';

class CoffeeBeanListItem extends StatelessWidget {
  final CoffeBeanType bean;

  const CoffeeBeanListItem({super.key, required this.bean});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text(bean.beanType),
                trailing: Column(
                  children: [
                    Text(bean.calculateMeanRating().toString()),
                    const Icon(Icons.star),
                  ],
                ),
                dense: false,
              ),
            ],
          ).toList(),
        ),
      ],
    );
  }
}