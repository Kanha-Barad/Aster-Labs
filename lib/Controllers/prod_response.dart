import 'package:get/get.dart';

class ProductResponse {
  String id, productName, productDescription;
  double price;

  ProductResponse(
      {required this.id,
        required this.productName,
        required this.productDescription,
        required this.price,
        int quantity = 0,
        bool isFavourite = false}) {
    this.setQuantity(quantity);
    this.setIsFavourite(isFavourite);
  }

  RxInt quantity = RxInt(0);
  setQuantity(int value) => quantity.value = value;

  RxBool isFavourite = RxBool(false);
  setIsFavourite(bool value) => isFavourite.value = value;
}