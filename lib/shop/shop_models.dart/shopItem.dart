import 'package:flutter/material.dart';

class ShopItem extends StatefulWidget {
  @override
  _ShopItemState createState() => _ShopItemState();

  final String description;
  final double price;
  final String name;
  final String imageUrl;
  final int id;
  ShopItem(
      {required this.description,
      required this.price,
      required this.name,
      required this.imageUrl,
      required this.id});
}

class _ShopItemState extends State<ShopItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
