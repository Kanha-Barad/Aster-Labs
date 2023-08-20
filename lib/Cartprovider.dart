import 'package:flutter/material.dart';

import 'CartModel.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    cartItems.forEach((cartItem) {
      total += cartItem.price;
    });
    return total;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Add other methods like removing from cart, calculating total, etc.
}
