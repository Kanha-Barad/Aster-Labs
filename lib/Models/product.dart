import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Product {
   int id;
  final String title;
  //  final int quantity;
  final double price;
  // bool isFavourite;
  final int Service_Id;
  final String Service_Type_Id;

  Product(
      {required this.id,
      required this.title,
      //  required this.quantity,
      required this.price,
      required this.Service_Id,
      required this.Service_Type_Id,
      bool isFavourite = false,
      bool isAdded = false});

  RxBool isFavourite = RxBool(false);
  setIsFavourite(bool value) => isFavourite.value = value;

  RxBool isAdded = RxBool(false);
  setIsAdded(bool value) => isAdded.value = value;

  // RxBool isRemoved = RxBool(false);
  // setIsRemoved(bool value) => isRemoved.value = value;
}
