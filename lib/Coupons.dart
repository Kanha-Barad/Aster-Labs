import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'Controllers/cart_controller.dart';
import 'Screens/Test_Cart_screen.dart';
import 'globals.dart' as globals;

import 'dart:math' as math;

class CouponsCardApply extends StatefulWidget {
  const CouponsCardApply({Key? key}) : super(key: key);

  @override
  State<CouponsCardApply> createState() => _CouponsCardApplyState();
}

class _CouponsCardApplyState extends State<CouponsCardApply> {
  @override
  Widget build(BuildContext context) {
    Future<List<GetDisCountCoupons>> _fetchManagerDetails() async {
      Map data = {
        "referal_source_id": "1",
        "refrl_id": "0",
        "loc_id": "107",
        "session_id": "1",
        "adv_search": "",
        "page_num": "",
        "page_size": "300",
        "op_count": "200",
        "dicount_policy_id": "",
        "bill_id": "",
        "connectionnew": "",
        "connection": globals.Patient_App_Connection_String
      };

      final jobsListAPIUrl =
          Uri.parse(globals.Global_Patient_Api_URL + '/PatinetMobileApp/GetDiscountpolicys');

      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne["Data"];
        globals.Preferedsrvs = jsonDecode(response.body);
        return jsonResponse
            .map((managers) => GetDisCountCoupons.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget DisCountCouponsListDetails = FutureBuilder<List<GetDisCountCoupons>>(
        future: _fetchManagerDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return SizedBox(child: DisCountCouponsList(data, context));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
              child: const CircularProgressIndicator(
            strokeWidth: 4.0,
          ));
        });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Discount Coupons', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(240, 18, 69, 121),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: DisCountCouponsListDetails),
    );
  }
}

ListView DisCountCouponsList(var data, BuildContext contex) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _buildDisCountCoupons(data[index], context);
    },
    scrollDirection: Axis.vertical,
  );
}

var cartController = Get.put(CartController());
Widget _buildDisCountCoupons(data, BuildContext context) {
  ApplyDiscount(DiscountPercentage) {
    var discount = DiscountPercentage;
    var Discount_Amount =
        double.parse(cartController.totalAmount.toString()) * discount / 100;

    globals.Discount_Amount_Coupon = Discount_Amount.toString();
    globals.Net_Amount_Coupon =
        double.parse(cartController.totalAmount.toString()) -
            double.parse(Discount_Amount.toString());
    var sag_discnt =
        (Discount_Amount / int.parse(cartController.itemCount.toString()))
            .round();
    globals.GlobalDiscountCoupons = sag_discnt.toString();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CartScreen()));
    // GrossPaymentCard(context);
  }

  return GestureDetector(
      child: Padding(
    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
    child: Card(
        elevation: 3.0,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color.fromARGB(255, 75, 145, 214),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 3, 15),
                      child: RichText(
                        text: TextSpan(
                          text: "10% Off",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                          children: [
                            WidgetSpan(
                              child:
                                  RotatedBox(quarterTurns: -1, child: Text('')),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.Discount_Policy_Name),
                      TextButton(
                          onPressed: () {
                            // ApplyDiscount(data.Percentage);
                            globals.Coupon_Policy_Id =
                                data.DisCount_Policy_Id.toString();
                          },
                          child: Text("Apply",
                              style: TextStyle(color: Colors.blue))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Use this code & get 10% off on orders'),
                    ],
                  ),
                )
              ],
            ),
          ],
        )),
  ));
}

class GetDisCountCoupons {
  // final Row;
  // final Referal_Disc_Id;
  // final Referal_Id;
  // final Referal_Name;
  // final Referal_Source_Name;
  // final Referal_Source_Id;
  final Location_Id;
  final Location_Name;
  final DisCount_Policy_Id;
  final Discount_Policy_Name;
  final Percentage;
  // final Create_By;
  // final Create_Date;
  // final Modify_By;
  // final Modify_Date;
  // final Record_Status;
  // final Concession_Percent;
  GetDisCountCoupons({
    // required this.Row,
    // required this.Referal_Disc_Id,
    // required this.Referal_Id,
    // required this.Referal_Name,
    // required this.Referal_Source_Name,
    // required this.Referal_Source_Id,
    required this.Location_Id,
    required this.Location_Name,
    required this.DisCount_Policy_Id,
    required this.Discount_Policy_Name,
    required this.Percentage,
    // required this.Create_By,
    // required this.Create_Date,
    // required this.Modify_By,
    // required this.Modify_Date,
    // required this.Record_Status,
    // required this.Concession_Percent,
  });
  factory GetDisCountCoupons.fromJson(Map<String, dynamic> json) {
    return GetDisCountCoupons(
      // Row: json['ROW'].toString(),
      // Referal_Disc_Id: json['REFERAL_DISCOUNT_ID'].toString(),
      // Referal_Id: json['REFERAL_ID'].toString(),
      // Referal_Name: json['REFERAL_NAME'].toString(),
      // Referal_Source_Name: json['REFERAL_SOURCE_NAME'].toString(),
      // Referal_Source_Id: json['REFERAL_SOURCE_ID'].toString(),
      Location_Id: json['LOCATION_ID'],
      Location_Name: json['LOCATION_NAME'].toString(),
      DisCount_Policy_Id: json['DISCOUNT_POLICY_ID'],
      Discount_Policy_Name: json['DISCOUNT_POLICY_NAME'].toString(),
      Percentage: json['PERCENTAGE'],
      // Create_By: json['CREATE_BY'].toString(),
      // Create_Date: json['CREATE_DT'].toString(),
      // Modify_By: json['MODIFY_BY'].toString(),
      // Modify_Date: json['MODIFY_DT'].toString(),
      // Record_Status: json['RECORD_STATUS'].toString(),
      // Concession_Percent: json['CONCESSION_PRCNT'].toString()
    );
  }
}
