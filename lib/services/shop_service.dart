import 'package:flutter/material.dart';
import 'package:scan_in/shop/shop_models.dart/shopItem.dart';

class ShopService extends StatefulWidget {
  @override
  _ShopServiceState createState() => _ShopServiceState();

  List<ShopItem>? cart;
  late bool cartStatus;

  void addToCart(ShopItem s, cart) {
    cart.add(s);
  }

  void removeFromCart(ShopItem s, List<ShopItem> cart) {
    cart.remove(s);
  }
}

class _ShopServiceState extends State<ShopService> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
