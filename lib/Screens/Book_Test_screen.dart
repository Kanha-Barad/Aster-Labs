import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asterlabs/Widgets/BottomNavigation.dart';
import '../ClientCodeLogin.dart';
import '../Controllers/cart_controller.dart';
import '../Controllers/product_controller.dart';
import 'Test_Cart_screen.dart';
import '../Widgets/BookTestDrawer.dart';

import '../Widgets/Book_Test.dart';
import '../Widgets/Test_Search.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../PatientHome.dart';
import '../PatientLogin.dart';
import '../UserProfile.dart';

enum FilterOptions {
  FAVOURITES,
  ALL,
}

class ProductOverviewPage extends StatefulWidget {
  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  final controller = Get.put(ProductController());

// Call fetchProducts to refresh the data
  @override
  void initState() {
    // TODO: implement initState
    controller.fetchProducts(globals.Preferedsrvs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  bookCart();

    // Get.put(ProductController());
    // Get.put(CartController());
    // Get.appUpdate();
    //setState(() {});
    
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff123456),
          title: Text('Book A Test', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              onPressed: () {
                //   Get.find<ProductController>().onClose();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))

          // Builder(
          //   builder: (context) => IconButton(
          //     icon: Icon(Icons.menu_rounded, color: Colors.white),
          //     onPressed: () => Scaffold.of(context).openDrawer(),
          //   ),
          // ),
          ),
      endDrawer: AppDrawer(),
      body: ProductsGrid(),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}
