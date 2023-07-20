import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/cart_item.dart';
import '../Widgets/Book_Test.dart';

class CartController extends GetxController {
  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    // return  _items?.length?? 0;
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  //get Service_Id => null;

  void addItem(
      int productId, double price, String title, int Service_Id, int quantity) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price,
              Service_Id: existingCartItem.Service_Id,
              productId: existingCartItem.productId));
      update();
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: productId.toString(),
            title: title,
            price: price,
            quantity: 1,
            Service_Id: Service_Id,
            productId: productId),
      );
    }
    update();
  }

  void removeitem(productId, double price, String title, int serviceId, int i) {
    dynamic res = _items.remove(serviceId);

    update();
  }

  void clear() {
    _items = {};
    update();
  }
}
