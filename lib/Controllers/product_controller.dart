import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asterlabs/Coupons.dart';
import '../Models/product.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxList<Product> productList = <Product>[].obs;
  RxList<Product> productTempList = <Product>[].obs;
  var totalAmount = RxDouble(0);
  Set<int> addedProductIds = <int>{}.obs;

  RxBool isAdded = RxBool(false);
  setIsAdded(bool value) => isAdded.value = value;

  RxBool isFavourite = RxBool(false);
  setIsFavourite(bool value) => isFavourite.value = value;

  @override
  void onInit() {
    super.onInit();
    // Call API here and populate the productList
    fetchProducts(globals.Preferedsrvs);
  }

  List<Product> newProductList = [];

  fetchProducts(Map<String, dynamic> responseBody) async {
    //   if (globals.Is_search == "") {
    productList.clear();
    productTempList.clear();
    Map data = {
      "IP_LOCATION_ID": globals.SelectedlocationId,
      "IP_SESSION_ID": "1",
      "connection": globals.Patient_App_Connection_String
    };
    print(data.toString());

    final response = await http.post(
      Uri.parse(globals.Global_Patient_Api_URL +
          '/PatinetMobileApp/PreferedServices'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      if (responseJson.containsKey("Data")) {
        List<dynamic> responseData = responseJson["Data"];
        List<Product> tempList = [];

        for (int i = 0; i < responseData.length; i++) {
          tempList.add(
            Product(
              id: i + 1,
              title: responseData[i]["SERVICE_NAME"].toString(),
              price: responseData[i]["PRICE"],
              Service_Id: responseData[i]["SERVICE_ID"],
              Service_Type_Id: responseData[i]["SERVICE_TYPE_ID"].toString(),
            ),
          );
        }

        productList.value = tempList;
        productTempList.value = tempList;
        newProductList =
            tempList; // Assign the fetched products to newProductList

        update();
      } else {
        throw Exception('No data found in API response');
      }
    } else {
      throw Exception('Failed to load products from API');
    }
    // }
  }

  productNameSearch(String name) {
    //  globals.Is_search = "Y";

    if (name.isEmpty) {
      // If the search query is empty, reset the productList to the original list
      productList.value = newProductList;
    } else {
      // Filter the newProductList based on the search query
      List<Product> filteredList = newProductList
          .where((element) =>
              element.title.toLowerCase().contains(name.toLowerCase()))
          .toList();
      productList.value = filteredList;
      // productList.addAll(newProductList);
    }

    update();
  }

  void resetAll() {
    for (int i = 0; i < productList.length; i++) {
      productList[i].isAdded.value = false;
    }
  }

  Product findProductById(int id) {
    return productList.firstWhere((element) => element.id == id);
  }

  void clear() {
    searchController.clear();
    productList.clear();
    productTempList.clear();
  }

  void toggleAddRemove(int index) {
    final product = productList[index];
    final productId = product.id;

    if (addedProductIds.contains(productId)) {
      addedProductIds.remove(productId);
    } else {
      addedProductIds.add(productId);
    }

    // Update the isAdded value of the product
    product.isAdded.value = addedProductIds.contains(productId);

    update();
  }
}
