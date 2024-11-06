import 'package:flutter/material.dart';

class RestaurantDetails extends StatelessWidget {
  final String description;
  const RestaurantDetails({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            description
          )
        ],
      ),
    );
  }
}