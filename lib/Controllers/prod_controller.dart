import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'prod_response.dart';
import '../Models/product.dart';
import '../globals.dart' as globals;

class Product_Controller extends GetxController {
  TextEditingController searchController = TextEditingController();

  var productList = <Product>[].obs;
  var productTempList = <Product>[];
  var totalAmount = RxDouble(0);
  RxBool isFavourite = RxBool(false);
  setIsFavourite(bool value) => isFavourite.value = value;

  @override
  void onInit() {
    super.onInit();
    //Get data
    var productData = _items;

    //Store data
    productList.value = productData;
    productTempList = productData;
  }

  productNameSearch(String name) {
    if (name.isEmpty) {
      productList.value = productTempList;
      update();
    } else {
      productList.value = productTempList
          .where((element) =>
              element.title.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  // productNameSearch(String name) {
  //   if (name.isEmpty) {
  //     _items = productTempList;
  //   } else {
  //     _items = productTempList
  //         .where((element) =>
  //         element.title.toLowerCase().contains(name.toLowerCase()))
  //         .toList();
  //   }
  // }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items
        .where((productItem) => productItem.isFavourite.value)
        .toList();
  }

  Product findProductById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct() {
    update();
  }

  void toggleFavouriteStatus(int id) {
    items[id].isFavourite.value = !items[id].isFavourite.value;
  }
  //
  // quantityAdd(ProductResponse productResponse) {
  //   productResponse.quantity++;
  //   //_totalAmountGet();
  // }

  // favourite(ProductResponse productResponse) {
  //   productResponse.isFavourite.value = !productResponse.isFavourite.value;
  // }
  //
  // quantityAdd(ProductResponse productResponse) {
  //   productResponse.quantity++;
  //   //_totalAmountGet();
  // }
  //
  // quantityMinus(ProductResponse productResponse) {
  //   if (productResponse.quantity.value > 0) {
  //     productResponse.quantity--;
  //     //_totalAmountGet();
  //   }
  // }
  //
  // productNameSearch(String name) {
  //   if (name.isEmpty) {
  //     productList.value = productTempList;
  //   } else {
  //     productList.value = productTempList
  //         .where((element) =>
  //         element.title.toLowerCase().contains(name.toLowerCase()))
  //         .toList();
  //   }
  // }

  // _totalAmountGet() {
  //   totalAmount.value = productList.fold(0, (previous, current) => previous + current.price * current.quantity.value);
  // }

  List<Product> _items = [];
}
