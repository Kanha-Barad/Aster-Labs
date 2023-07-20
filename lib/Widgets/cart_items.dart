import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../Controllers/cart_controller.dart';
import '../Controllers/product_controller.dart';
import 'dart:math' as math;
import '../globals.dart' as globals;

final productcontroller = Get.put(ProductController());
final cartController = Get.put(CartController());

class CartItem extends StatelessWidget {
  final String id;
  final int productId;
  final double price;
  final int quantity;
  final String title;
  final int Service_Id;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId,
      this.Service_Id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cartController.removeitem(productId, price, title, Service_Id, 1);
          productcontroller.productList[Service_Id - 1].isAdded.value = false;
          globals.Discount_Amount_Coupon = 0;
          globals.Net_Amount_Coupon = 0;
          globals.Coupon_Policy_Id = 'null';
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 1.0, 10, 1.0),
            child: Card(
                // color: Color.fromARGB(209, 246, 250, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 2.5,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(children: [
                      Row(children: [
                        //  CircleAvatar(radius: 25),
                        SizedBox(width: 7),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 10.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 4, 0),
                                        child: Transform.rotate(
                                            angle: -180 * math.pi / 180,
                                            child: Icon(Icons.filter_alt)),
                                        // child: Icon(
                                        //   Icons.alarm_sharp,
                                        //   size: 20,
                                        //   color:
                                        //       Color.fromARGB(255, 56, 108, 187),
                                        // ),
                                      ),
                                      Text(
                                          title.length <= 43
                                              ? title
                                              : title.substring(0, 43),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black)),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),

                                // Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 0.0, 0.0, 3.0),
                                  child: Row(children: [
                                    Text('Rs.  \u{20B9} ${price}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.deepOrange)),
                                    Spacer(),
                                    // Text('$quantity'),
                                    Card(
                                        color:
                                            Color.fromARGB(255, 27, 165, 114),
                                        child: Icon(
                                          Icons.download_done_outlined,
                                          size: 15,
                                          color: Colors.white,
                                        ))
                                  ]),
                                ),
                              ]),
                        )
                      ])
                    ])))));
  }
}
