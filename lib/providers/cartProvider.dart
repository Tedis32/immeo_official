import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan_in/shop/shop_models.dart/shopItem.dart';

class CartProvider with ChangeNotifier {
  List<ShopItem>? cart;
  late bool cartStatus;

  void addToCart(ShopItem s, cart) {
    cart.add(s);
  }

  void removeFromCart(ShopItem s, List<ShopItem> cart){
    
    cart.remove(s);
  }
}
