import 'dart:convert';

import 'package:asterlabs/CartModel.dart';
import 'package:asterlabs/thankYou_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'Cartprovider.dart';
import 'Coupons.dart';
import 'globals.dart' as globals;
import 'dart:math' as math;

List LOCATIONDATA = [];
var Device_token_ID = "";
String LocatioNID = "";

class CartPage extends StatefulWidget {
  CartPage(LOCID) {
    LocatioNID = "";
    LocatioNID = LOCID;
  }
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  bool canClick = true;
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) {
      Device_token_ID = value!;
      print(Device_token_ID);
      // Update or store the token as needed
    });
    var cartItems = Provider.of<CartProvider>(context).cartItems;
    var cartProvider =
        Provider.of<CartProvider>(context); // Obtain the CartProvider instance
    var _selectedLocItem;

    DateTime selectedDate = DateTime.now();
    late Map<String, dynamic> map;
    late Map<String, dynamic> params;
    Select_State_Wise_Services() async {
      params = {
        "IP_SESSION_ID": globals.Session_ID,
        "connection": globals.Patient_App_Connection_String,
        //"Server_Flag":""
      };

      final response = await http.post(
          Uri.parse(globals.Global_Patient_Api_URL +
              '/PatinetMobileApp/Location_list'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: params,
          encoding: Encoding.getByName("utf-8"));
      map = json.decode(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne["Data"];
      } else {
        throw Exception('Failed to load jobs from API');
      }
      setState(() {
        LOCATIONDATA = map["Data"] as List;
      });
    }

    if (LOCATIONDATA == "" || LOCATIONDATA.length == 0) {
      Select_State_Wise_Services();
    }

    final Location_Dropdwon = Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: DropdownButtonFormField(
        hint: Text(
          'Select Location',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            //<-- SEE HERE
            borderSide:
                BorderSide(color: Color.fromARGB(255, 183, 181, 181), width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            //<-- SEE HERE
            borderSide:
                BorderSide(color: Color.fromARGB(255, 183, 181, 181), width: 1),
          ),
          filled: true,
          // fillColor: Color.fromARGB(255, 243, 247, 245),
        ),
        dropdownColor: Color.fromARGB(255, 232, 240, 242),
        value: _selectedLocItem,
        onChanged: (newValue) {
          setState(() {
            _selectedLocItem = newValue;
            globals.SelectedlocationId = _selectedLocItem;
          });
        },
        isExpanded: true,
        items: LOCATIONDATA.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value['LOC_ID'].toString(),
            child: Text(
              value['LOCATION_NAME'].toString(),
              style: TextStyle(fontSize: 11.4, fontWeight: FontWeight.w600),
            ),
          );
        }).toList(),
      ),
    );

    bool isPageLoading = false;

    bool isButtonLoading = false;

    UserOrderBookingTest() async {
      if (globals.SelectedlocationId == "" ||
          globals.SelectedlocationId == "0") {
        return Fluttertoast.showToast(
            msg: "Please Select the Location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 235, 103, 93),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      String testIds = '';
      String testAmount = '';
      String testConcession = '';
      String testNet = '';

      for (var cartItem in cartItems) {
        testIds += '${cartItem.id},';
        testAmount += '${cartItem.price},';

        // Assuming you have a global discount coupons variable
        if (globals.GlobalDiscountCoupons == "") {
          globals.GlobalDiscountCoupons = "0";
        }
        testConcession += '${globals.GlobalDiscountCoupons},';

        double netAmount =
            cartItem.price - double.parse(globals.GlobalDiscountCoupons);
        testNet += '$netAmount,';
      }
      // dataset = cartController.items;
      // for (i = 0; i <= dataset.length; i++) {
      //   test_ids += dataset[i];
      // }
      if (globals.Discount_Amount_Coupon == "" ||
          globals.Discount_Amount_Coupon == null) {
        globals.Discount_Amount_Coupon = "0";
      }
      if (globals.Coupon_Policy_Id == "" || globals.Coupon_Policy_Id == null) {
        globals.Coupon_Policy_Id = "0";
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (globals.Session_ID == null || globals.Session_ID == "") {
        globals.Session_ID = prefs.getString('SeSSion_ID')!;
      }

      if (globals.umr_no == null || globals.umr_no == "") {
        globals.umr_no = prefs.getString('singleUMr_No')!;
      }

      Map data = {
        "PATIENT_ID": "1",
        "UMR_NO": globals.umr_no,
        "TEST_IDS": testIds,
        "TEST_AMOUNTS": testAmount,
        "CONSESSION_AMOUNT": globals.Discount_Amount_Coupon.toString(),
        "BILL_AMOUNT": cartProvider.totalAmount.toStringAsFixed(0),
        "DUE_AMOUNT": cartProvider.totalAmount.toStringAsFixed(0),
        "MOBILE_NO": globals.mobNO,
        "MOBILE_REG_FLAG": "y",
        "SESSION_ID": globals.Session_ID,
        "PAYMENT_MODE_ID": "1",
        "IP_NET_AMOUNT": cartProvider.totalAmount.toStringAsFixed(0),
        "IP_TEST_CONCESSION": testConcession,
        "IP_TEST_NET_AMOUNTS": testNet,
        "IP_POLICY_ID": globals.Coupon_Policy_Id,
        "IP_PAID_AMOUNT": "0",
        "IP_OUTSTANDING_DUE": cartProvider.totalAmount.toStringAsFixed(0),
        "connection": globals.Patient_App_Connection_String,
        "loc_id": LocatioNID.toString(),
        "IP_SLOT": globals.Slot_id,
        "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_UPLOAD_IMG": "",
        "IP_PRESCRIPTION": "",
        "IP_REMARKS": "",
        "Mobile_Device_Id": Device_token_ID,
        //"Server_Flag":""
      };

      final jobsListAPIUrl = Uri.parse(
          globals.Global_Patient_Api_URL + '/PatinetMobileApp/NewRegistration');

      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        globals.SelectedlocationId = "";
        var bill_NUmber = resposne["Data"][0]["BILL_NO"].toString();
        var Bill_Date = resposne["Data"][0]["CREATE_DT"].toString();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ThankYouScreenOFUploadPrescripTIOn(
                    bill_NUmber, Bill_Date, "TBNO")));
        cartProvider.clearCart();
      } else {
        throw Exception('Failed to load data from API');
      }
    }

    void _UserListBookingsBottomPicker(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
            height: 400, // Set the desired fixed height for the bottom popup
            child: Scaffold(
              appBar: AppBar(
                title: Text('Family Members',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Color.fromARGB(255, 7, 185, 141),
                leading: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    )),
              ),
              body: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display users based on global data here
                    // Each user should be a ListTile with an onTap callback
                    for (var userData in globals.selectedLogin_Data["Data"])
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.grey)),
                          child: ListTile(
                            leading: Icon(
                              Icons.account_circle_outlined,
                              size: 32,
                              color: Color.fromARGB(255, 49, 114, 179),
                            ),
                            title: Text(
                              userData["DISPLAY_NAME"],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              userData["UMR_NO"],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              setState(() {
                                isLoading = true; // Show loading indicator
                              });

                              Navigator.pop(context); // Close the popup
                              await UserOrderBookingTest(); // Call the API for selected user

                              setState(() {
                                isLoading = false; // Hide loading indicator
                                canClick = true;
                              });
                            },
                          ),
                        ),
                      ),
                    // if (isLoading)
                    //   Center(
                    //     child:
                    //         CircularProgressIndicator(), // Show loading indicator in center
                    //   ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Future<void> UsersTestBooking() async {
      setState(() {
        isLoading = true;
        canClick = false;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? encodedJson = prefs.getString('data1');

        if (globals.selectedLogin_Data == null) {
          globals.selectedLogin_Data = json.decode(encodedJson!);
        }

        if (globals.selectedLogin_Data["Data"].length > 1) {
          _UserListBookingsBottomPicker(context);
        } else if (globals.Booking_Status_Flag == "0") {
          Fluttertoast.showToast(
            msg: "Booking In Progress",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 235, 103, 93),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          await UserOrderBookingTest();
        }
      } catch (error) {
        print(error); // Handle errors here...
      }

      setState(() {
        isLoading = false;
        canClick = true;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white)),
            backgroundColor: Color.fromARGB(255, 7, 185, 141),
            title: Text("Test Cart", style: TextStyle(color: Colors.white)),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      // Navigate to the cart page
                    },
                  ),
                  Positioned(
                    top: 3,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 36, 101, 181),
                      ),
                      child: Text(
                        cartItems.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
        body: Stack(children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Adjust the radius as needed
                            side: BorderSide(
                                color: Color.fromARGB(255, 231, 231, 231))),
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Transform.rotate(
                                      angle: -180 * math.pi / 180,
                                      child: Icon(
                                        Icons.filter_alt_outlined,
                                        color:
                                            Color.fromARGB(255, 49, 114, 179),
                                      )),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 6, top: 4),
                                          child: Text(
                                            cartItems[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.4,
                                                fontWeight: FontWeight.w400),
                                          )))
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 33, right: 6),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rs. \u{20B9} ${cartItems[index].price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.deepOrange),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color:
                                            Color.fromARGB(255, 245, 107, 86),
                                      ),
                                      onPressed: () {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCart(cartItems[index]);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
              globals.Location_BookedTest == ""
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                          child: Text(
                            'Offers & Benifits',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              globals.Location_BookedTest == ""
                  ? InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0.0, 9, 8.0),
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Apply Coupon',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        globals.SelectedlocationId = "";
                        _CouponsBottomPicker(context);
                      })
                  : Container(),
              globals.Location_BookedTest == ""
                  ? Location_Dropdwon
                  : Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 120,
                        width: 340,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 150,
                                      child: Text(
                                        "Slot Date And Time:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  globals.selectDate == ""
                                      ? Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          globals.selectDate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  Text("/"),
                                  Text(
                                    globals.SlotsBooked,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 16.0, right: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 150,
                                      child: Text("Location:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(
                                    width: 150,
                                    child: Text(globals.Location_BookedTest,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              globals.Location_BookedTest == ""
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(17, 4, 0, 0),
                              child: Text(
                                'Payments Instruction',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: Colors.white,
                              // margin: EdgeInsets.all(15),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Amount :',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '\u{20B9} ' +
                                              '${cartProvider.totalAmount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Discount Amount :',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        (globals.Discount_Amount_Coupon
                                                        .toString() ==
                                                    null ||
                                                globals.Discount_Amount_Coupon
                                                        .toString() ==
                                                    "null")
                                            ? Text(
                                                '\u{20B9} ' + '0',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text(
                                                '\u{20B9} ' +
                                                    globals.Discount_Amount_Coupon
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Net. Amount :',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        (globals.Net_Amount_Coupon.toString() ==
                                                    null ||
                                                globals.Net_Amount_Coupon
                                                        .toString() ==
                                                    "null")
                                            ? Text(
                                                '\u{20B9} ' + '0',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text(
                                                '\u{20B9} ' +
                                                    globals.Net_Amount_Coupon
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 120,
                                          child: Card(
                                            color: Color.fromARGB(
                                                255, 49, 114, 179),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: TextButton(
                                              onPressed: canClick
                                                  ? UsersTestBooking
                                                  : null,
                                              child: Text(
                                                'Pay Later',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 120,
                                          child: Card(
                                            color: Color.fromARGB(
                                                255, 49, 114, 179),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Pay Now',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 14),
                      child: GestureDetector(
                        onTap: canClick ? UsersTestBooking : null,
                        child: Card(
                          color: const Color.fromARGB(255, 49, 114, 179),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 230, 228, 228))),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                            child: Center(
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
          if (isLoading)
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [
                    Color.fromARGB(255, 49, 114, 179),
                  ],
                  strokeWidth: 4.0,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

// _UserListBookingsBottomPicker(BuildContext context) {
//   var res = showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => Container(
//           // color: Color.fromARGB(255, 236, 235, 235),
//           height: MediaQuery.of(context).size.height * 0.4,
//           child: UserlistBottomPopup()
//           // UserListBookings(globals.selectedLogin_Data, context),
//           ));
//   print(res);
// }

// class UserlistBottomPopup extends StatefulWidget {
//   const UserlistBottomPopup({Key? key}) : super(key: key);

//   @override
//   State<UserlistBottomPopup> createState() => _UserlistBottomPopupState();
// }

// class _UserlistBottomPopupState extends State<UserlistBottomPopup> {
//       var cartItems = Provider.of<CartProvider>(context).cartItems;

//   ListView UserListBookings(var data, BuildContext contex) {
//     var myData = data["Data"].length;
//     return ListView.builder(
//         itemCount: myData,
//         scrollDirection: Axis.vertical,
//         //  globals.selectedLogin_Data["Data"].length
//         itemBuilder: (context, index) {
//           return Container(
//               //  color: Color.fromARGB(255, 236, 235, 235),
//               // height: MediaQuery.of(context).size.height * 0.16,
//               child: userBookings(data["Data"][index], index, context));
//         });
//   }

//   MultiUserOrderPayments() async {
//     bool _isLoading = false;

//     DateTime selectedDate = DateTime.now();
//     if (globals.SelectedlocationId == "" || globals.SelectedlocationId == "0") {
//       return Fluttertoast.showToast(
//           msg: "Select the Location",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Color.fromARGB(255, 235, 103, 93),
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }

//      String testIds = '';
//       String testAmount = '';
//       String testConcession = '';
//       String testNet = '';

//       for (var cartItem in cartItems) {
//         testIds += '${cartItem.id},';
//         testAmount += '${cartItem.price},';

//         // Assuming you have a global discount coupons variable
//         if (globals.GlobalDiscountCoupons == "") {
//           globals.GlobalDiscountCoupons = "0";
//         }
//         testConcession += '${globals.GlobalDiscountCoupons},';

//         double netAmount =
//             cartItem.price - double.parse(globals.GlobalDiscountCoupons);
//         testNet += '$netAmount,';
//       }

//     if (globals.Discount_Amount_Coupon == "" ||
//         globals.Discount_Amount_Coupon == null) {
//       globals.Discount_Amount_Coupon = "0";
//     }
//     if (globals.Coupon_Policy_Id == "" || globals.Coupon_Policy_Id == null) {
//       globals.Coupon_Policy_Id = "0";
//     }
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (globals.Session_ID == null || globals.Session_ID == "") {
//       globals.Session_ID = prefs.getString('SeSSion_ID')!;
//     }
//     Map data = {
//       "PATIENT_ID": "1",
//       "UMR_NO": globals.umr_no,
//       "TEST_IDS": test_ids,
//       "TEST_AMOUNTS": test_amount,
//       "CONSESSION_AMOUNT": globals.Discount_Amount_Coupon.toString(),
//       "BILL_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
//       "DUE_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
//       "MOBILE_NO": globals.mobNO,
//       "MOBILE_REG_FLAG": "y",
//       "SESSION_ID": globals.Session_ID,
//       "PAYMENT_MODE_ID": "1",
//       "IP_NET_AMOUNT": cartController.totalAmount.toStringAsFixed(0),
//       "IP_TEST_CONCESSION": test_concession,
//       "IP_TEST_NET_AMOUNTS": Test_net,
//       "IP_POLICY_ID": globals.Coupon_Policy_Id,
//       "IP_PAID_AMOUNT": "0",
//       "IP_OUTSTANDING_DUE": cartController.totalAmount.toStringAsFixed(0),
//       "loc_id": globals.SelectedlocationId,
//       "IP_SLOT": globals.Slot_id,
//       "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
//       "connection": globals.Patient_App_Connection_String,
//       "IP_UPLOAD_IMG": "",
//       "IP_PRESCRIPTION": "",
//       "IP_REMARKS": "",
//       "Mobile_Device_Id": Device_token_ID,
//     };

//     final jobsListAPIUrl = Uri.parse(
//         globals.Global_Patient_Api_URL + '/PatinetMobileApp/NewRegistration');

//     var response = await http.post(jobsListAPIUrl,
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: data,
//         encoding: Encoding.getByName("utf-8"));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> resposne = jsonDecode(response.body);
//       List jsonResponse = resposne["Data"];
//       // globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
//       // Push_Notification_Message(context, globals.Bill_No);
//       globals.Slot_id = "";
//       globals.SelectedlocationId = "";
//       var bill_NUmber = resposne["Data"][0]["BILL_NO"].toString();
//       var Bill_Date = resposne["Data"][0]["CREATE_DT"].toString();
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ThankYouScreenOFUploadPrescripTIOn(
//                   bill_NUmber, Bill_Date, "TBNO")));

//       cartController.clear();
//       productcontroller.resetAll();
//     } else {
//       throw Exception('Failed to load jobs from API');
//     }
//   }

//   bool isPageLoading = false;

//   bool isButtonDisabled = false;
//   Future<void> MultiUserOrderPaymentsBooking() async {
//     if (!isButtonDisabled) {
//       setState(() {
//         isButtonDisabled = true;
//         isPageLoading = true; // Show the loading indicator
//       });

//       try {
//         // Call your API here to book the test
//         await MultiUserOrderPayments();
//       } catch (error) {
//         // Handle any errors that occur during the API call
//       }

//       // Example delay to simulate API call
//       await Future.delayed(Duration(seconds: 5));

//       // Reset the flags after the delay
//       setState(() {
//         isButtonDisabled = false;
//         isPageLoading = false; // Hide the loading indicator
//       });
//     }
//   }

//   Widget userBookings(
//     data,
//     index,
//     context,
//   ) {
//     return InkWell(
//       onTap: () {
//         bool _isLoading = false;
//         globals.umr_no = data["UMR_NO"].toString();
//         (globals.Booking_Status_Flag == "0")
//             ? Fluttertoast.showToast(
//                 msg: "Booking InProgress",
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.CENTER,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: Color.fromARGB(255, 235, 103, 93),
//                 textColor: Colors.white,
//                 fontSize: 16.0)
//             : MultiUserOrderPaymentsBooking();

//         //MultiUserOrderPayments();
//       },
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
//             child: Card(
//               elevation: 3.0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(16.0))),
//               child: Row(
//                 children: [
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(6.0),
//                         child: Icon(
//                           Icons.account_circle_rounded,
//                           color: Colors.indigoAccent,
//                           size: 40,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
//                         child: Text(
//                           data["DISPLAY_NAME"].toString(),
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 1, 0, 2),
//                         child: Text(
//                           data["UMR_NO"].toString(),
//                           style:
//                               TextStyle(fontSize: 14, color: Colors.red[400]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 SharedPreferences prefs = await SharedPreferences.getInstance();

//                 String? encodedJson = prefs.getString('data1');
//                 // List<dynamic> decodedJson = json.decode(encodedJson!);
//                 if (globals.selectedLogin_Data == null) {
//                   globals.selectedLogin_Data = json.decode(encodedJson!);
//                 }
//               },
//               icon: Icon(
//                 Icons.arrow_back_rounded,
//                 color: Colors.white,
//               )),
//           // automaticallyImplyLeading: false,
//           title: Text('Family Members', style: TextStyle(color: Colors.white)),
//           backgroundColor: Color.fromARGB(255, 7, 185, 141),
//         ),
//         body: Stack(children: [
//           UserListBookings(globals.selectedLogin_Data, context),
//           // Show the loading indicator in the center of the page
//           if (isPageLoading)
//             Center(
//               child: SizedBox(
//                 height: 100,
//                 width: 100,
//                 child: LoadingIndicator(
//                   indicatorType: Indicator.ballClipRotateMultiple,
//                   colors: [Color.fromARGB(255, 49, 114, 179)],
//                   strokeWidth: 4.0,
//                 ),
//               ), // Show a loading spinner,
//             ),
//         ]),
//       ),
//     );
//   }
// }

_CouponsBottomPicker(BuildContext context) {
  var res = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
          // color: Color.fromARGB(255, 236, 235, 235),
          height: MediaQuery.of(context).size.height * 0.8,
          child: CouponsCardApply()
          // UserListBookings(globals.selectedLogin_Data, context),
          ));
  print(res);
}

/**--------------------multiuserAPI--------------------------------------- */
// MultiUserOrderPayments() async {
//   bool isLoading = false;

//   DateTime selectedDate = DateTime.now();
//   if (globals.SelectedlocationId == "" ||
//       globals.SelectedlocationId == "0") {
//     return Fluttertoast.showToast(
//         msg: "Select the Location",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Color.fromARGB(255, 235, 103, 93),
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   String testIds = '';
//   String testAmount = '';
//   String testConcession = '';
//   String testNet = '';

//   for (var cartItem in cartItems) {
//     testIds += '${cartItem.id},';
//     testAmount += '${cartItem.price},';

//     // Assuming you have a global discount coupons variable
//     if (globals.GlobalDiscountCoupons == "") {
//       globals.GlobalDiscountCoupons = "0";
//     }
//     testConcession += '${globals.GlobalDiscountCoupons},';

//     double netAmount =
//         cartItem.price - double.parse(globals.GlobalDiscountCoupons);
//     testNet += '$netAmount,';
//   }

//   if (globals.Discount_Amount_Coupon == "" ||
//       globals.Discount_Amount_Coupon == null) {
//     globals.Discount_Amount_Coupon = "0";
//   }
//   if (globals.Coupon_Policy_Id == "") {
//     globals.Coupon_Policy_Id = "0";
//   }
//   // SharedPreferences prefs = await SharedPreferences.getInstance();

//   // if (globals.Session_ID == "") {
//   //   globals.Session_ID = prefs.getString('SeSSion_ID')!;
//   // }
//   Map data = {
//     "PATIENT_ID": "1",
//     "UMR_NO": "PR0966834",
//     "TEST_IDS": testIds,
//     "TEST_AMOUNTS": testAmount,
//     "CONSESSION_AMOUNT": "0",
//     "BILL_AMOUNT": cartProvider.totalAmount.toStringAsFixed(0),
//     "DUE_AMOUNT": cartProvider.totalAmount.toStringAsFixed(0),
//     "MOBILE_NO": "9090909090",
//     "MOBILE_REG_FLAG": "y",
//     "SESSION_ID": "2965860",
//     "PAYMENT_MODE_ID": "1",
//     "IP_NET_AMOUNT": cartProvider.totalAmount.toStringAsFixed(0),
//     "IP_TEST_CONCESSION": "0",
//     "IP_TEST_NET_AMOUNTS": testNet,
//     "IP_POLICY_ID": globals.Coupon_Policy_Id,
//     "IP_PAID_AMOUNT": "0",
//     "IP_OUTSTANDING_DUE": cartProvider.totalAmount.toStringAsFixed(0),
//     "loc_id": "38",
//     "IP_SLOT": "2056",
//     "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
//     "connection":
//         "Server=172.24.248.12;User id=ALUATDB.SVCA;Password=DSFg45THFD;Database=P_ASTER_LIMS_UAT_2023",
//     "IP_UPLOAD_IMG": "",
//     "IP_PRESCRIPTION": "",
//     "IP_REMARKS": "",
//     "Mobile_Device_Id":
//         "esXDUjwQT7m5NhfO9oCH9o:APA91bHH1u-tGysk7F_9YcrkVEuG0b2qBDSCXD-4QdvqCkaBBkAF6ae6Sn-G7QSensmgWwcCKEDxk37h0bVfclFb2ht0Wy9cGh_4oFP-50e-IsybM3fjwlQO4-s7tQJfXRg-RpJYE_lf",
//   };

//   final jobsListAPIUrl = Uri.parse(
//       'https://asterlabs.asterdmhealthcare.com/MOBILEAPPAPI/PatinetMobileApp/NewRegistration');

//   var response = await http.post(jobsListAPIUrl,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded"
//       },
//       body: data,
//       encoding: Encoding.getByName("utf-8"));

//   if (response.statusCode == 200) {
//     Map<String, dynamic> resposne = jsonDecode(response.body);
//     List jsonResponse = resposne["Data"];
//     // globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
//     // Push_Notification_Message(context, globals.Bill_No);
//     // globals.Slot_id = "";
//     // globals.SelectedlocationId = "";
//     var billNUmber = resposne["Data"][0]["BILL_NO"].toString();
//     var BillDate = resposne["Data"][0]["CREATE_DT"].toString();

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ThankYouScreenOFUploadPrescripTIOn(
//                 billNUmber, BillDate, "TBNO")));

//     // cartController.clear();
//     // productcontroller.resetAll();
//   } else {
//     throw Exception('Failed to load jobs from API');
//   }
// }

/**-----------------------------------UIPArt--------------------------------- */

//globals.Location_BookedTest == ""
//     ? Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
//             child: Text(
//               'Offers & Benifits',
//               style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       )
//     : Container(),
// globals.Location_BookedTest == ""
//     ? InkWell(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(10, 0.0, 9, 8.0),
//           child: Card(
//             elevation: 2.0,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15)),
//             child: Padding(
//               padding: const EdgeInsets.all(13.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Apply Coupon',
//                       style: TextStyle(
//                           fontSize: 15, fontWeight: FontWeight.w500)),
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 12,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         onTap: () {
//           globals.SelectedlocationId = "";
//           _CouponsBottomPicker(context);
//         })
//     : Container(),
// globals.Location_BookedTest == ""
//     ? Location_Dropdwon
//     : Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(20))),
//           height: 120,
//           width: 340,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                     top: 16.0, left: 16.0, right: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                         width: 150,
//                         child: Text(
//                           "Slot Date And Time:",
//                           style:
//                               TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     globals.selectDate == ""
//                         ? Text(
//                             "${selectedDate.toLocal()}".split(' ')[0],
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold),
//                           )
//                         : Text(
//                             globals.selectDate,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold),
//                           ),
//                     Text("/"),
//                     Text(
//                       globals.SlotsBooked,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     top: 10, left: 16.0, right: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                         width: 150,
//                         child: Text("Location:",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold))),
//                     SizedBox(
//                       width: 150,
//                       child: Text(globals.Location_BookedTest,
//                           style:
//                               TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
