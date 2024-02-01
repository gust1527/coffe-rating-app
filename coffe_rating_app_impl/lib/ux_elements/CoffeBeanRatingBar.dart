import 'package:flutter/material.dart';

class CoffeeBeanRatingBar extends StatelessWidget {
  final double rating;

  const CoffeeBeanRatingBar({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating.floor() ? Icons.coffee_rounded : Icons.coffee_outlined,
          color: Colors.amber,
        ),
      ),
    );
  }
}
