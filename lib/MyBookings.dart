import 'dart:convert';

import 'package:flutter/material.dart';
import './OrdersHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PatientHome.dart';
import 'PatientLogin.dart';
import 'UserProfile.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class MyBooking extends StatefulWidget {
  const MyBooking({Key? key}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  Widget build(BuildContext context) {
    Widget myBottomNavigationBar = Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Color(0xff123456),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: InkWell(
                onTap: () {
                  globals.SelectedlocationId = "";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PatientHome()));
                },
                child: Column(children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersProfile()),
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 30, 0),
              child: InkWell(
                onTap: () async {
                  globals.umr_no = "";
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("Msg_id", "");
                  prefs.setString('Mobileno', "");

                  prefs.setString('email', "");
                  //     prefs.setString('Mobileno', MobNocontroller.text.toString()).toString();
                  prefs.setString("Otp", "");
                  // prefs.getStringList('data1') ?? [];
                  (prefs.setString('data1', ""));
                  (prefs.setString('AppCODE', ''));
                  (prefs.setString('CompanyLogo', ''));
                  (prefs.setString('ReportURL', ''));
                  (prefs.setString('OTPURL', ''));
                  (prefs.setString('PatientAppApiURL', ''));
                  (prefs.setString('ConnectionString', ''));
                  if (prefs.getString('Mobileno') != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("")),
                    );
                  }
                },
                child: Column(children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ]),
              ),
            )
          ],
        ));
    Future<List<UserBOOKINGs>> _fetchManagerDetails() async {
      Map data = {
        "umr_no": globals.umr_no,
        "bill_no": '0',
        "flag": "",
        "session_id": "1",
        "connection": globals.Patient_App_Connection_String
        //"Server_Flag":""
      };
      final jobsListAPIUrl = Uri.parse(
          globals.Global_Patient_Api_URL + '/PatinetMobileApp/BillsOrderList');
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
        return jsonResponse
            .map((managers) => UserBOOKINGs.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    abc(bill_no) async {
      if (bill_no != '' && bill_no != null) {
        Map data = {
          "umr_no": globals.umr_no,
          "bill_no": bill_no.toString(),
          "flag": "",
          "session_id": "1",
          "connection": globals.Patient_App_Connection_String
          //"Server_Flag":""
        };
        final jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
            '/PatinetMobileApp/BillsOrderList');
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
          globals.TestDetails = jsonDecode(response.body);
          // globals.Booking_Test_Name = resposne["Data"][0]["SERVICE_NAME"].toString();
          // globals.Booking_Test_Amount = resposne["Data"][0]["AMOUNT"].toString();
          return showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Color.fromARGB(255, 236, 235, 235),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  //  title: const Text('Ordered Sucessfully'),
                  content: SizedBox(
                    // color: Colors.grey,
                    height: MediaQuery.of(context).size.height * 0.18,
                    child:
                        //   Text("Booking Id : " + globals.BillNo_For_Test_popup),
                        UserListTestNameAmountBookings(
                            globals.TestDetails, context),
                  )));
        } else {
          throw Exception('Failed to load jobs from API');
        }
      }
    }

    Widget _userBookingsDetails(var data, BuildContext context) {
      var _isExpanded = true;
      return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: InkWell(
            onTap: () {
              globals.BillNo_For_Test_popup = data.Patient_Bill_No.toString();
              globals.Bill_amount_Test_popup = data.Patient_Bill_Amt.toString();
              // _buildTestAmountPopup(context);
              abc(data.Patient_Bill_No.toString());
            },
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 3.0,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 8, 17, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.Patient_Bill_Amt,
                            style: TextStyle(fontSize: 16, color: Colors.red)),
                        Text("Booking Id : " + data.Patient_Bill_No,
                            style:
                                TextStyle(fontSize: 15, color: Colors.indigo)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 4, 0, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.Patient_Bill_Dt,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        // Text(data.Patient_Age,
                        //     style: TextStyle(
                        //         fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 4, 0, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.Patient_Name + '/' + data.Patient_Age,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        // Text(data.Patient_Age,
                        //     style: TextStyle(
                        //         fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 1, 17, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.Patient_Address1,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        // Text(data.Patient_Age,
                        //     style: TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ),
                ])),
          ));
    }

    ListView MyBookingsListView(data, BuildContext context) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return
              //   height: MediaQuery.of(context).size.height * 0.2,
              _userBookingsDetails(data[index], context);
        },
        // scrollDirection: Axis.horizontal,
      );
    }

    Widget BookTestDetails = FutureBuilder<List<UserBOOKINGs>>(
        future: _fetchManagerDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return SizedBox(child: MyBookingsListView(data, context));
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
        backgroundColor: Color(0xff123456),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Your Bookings', style: TextStyle(color: Colors.white)),
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: Icon(Icons.menu_rounded, color: Colors.white),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
      ),
      // drawer: Drawer(
      //   child: Column(
      //     children: <Widget>[
      //       AppBar(
      //         backgroundColor: Color(0xff123456),
      //         title: Text("My Bookings", style: TextStyle(color: Colors.white)),
      //         automaticallyImplyLeading: false,
      //       ),
      //       Divider(),
      //       ListTile(
      //         leading: Icon(Icons.shopping_cart),
      //         title: Text("My Reports"),
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => OredersHistory()));
      //           //  Get.to(() => PatientHome());
      //         },
      //       ),
      //       Divider(),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text("Home Page"),
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => PatientHome()));
      //         },
      //       ),
      //       Divider(),
      //       ListTile(
      //         leading: Transform.rotate(
      //             angle: -180 * math.pi / 180, child: Icon(Icons.filter_alt)),
      //         title: Text("Book A Test"),
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => ProductOverviewPage()));
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
          color: Color.fromARGB(255, 236, 236, 236), child: BookTestDetails),
      bottomNavigationBar: myBottomNavigationBar,
    );
  }
}

class UserBOOKINGs {
  final Patient_Name;
  final Patient_Age;
  final Patient_DOB;
  final Patient_Bill_No;
  final Patient_Bill_Dt;
  final Patient_Address1;
  final Patient_Bill_Amt;
  UserBOOKINGs(
      {required this.Patient_Name,
      required this.Patient_Age,
      required this.Patient_DOB,
      required this.Patient_Bill_No,
      required this.Patient_Bill_Dt,
      required this.Patient_Address1,
      required this.Patient_Bill_Amt});
  factory UserBOOKINGs.fromJson(Map<String, dynamic> json) {
    return UserBOOKINGs(
        Patient_Name: json['DISPLAY_NAME'].toString(),
        Patient_Age: json['AGE'].toString(),
        Patient_DOB: json['DOB'].toString(),
        Patient_Bill_No: json['BILL_NO'].toString(),
        Patient_Bill_Dt: json['BILL_DT'].toString(),
        Patient_Address1: json['ADDRESS1'].toString(),
        Patient_Bill_Amt: json['bill_amount'].toString());
  }
}

/*---------------------------------------------------User TsetAnd Amount Popup------------------------------------------ */

Widget userTestNameAmountBookings(data, index, context) {
  return GestureDetector(
      child: Column(
    children: [
      (index == 0)
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 9),
              child: Row(children: [
                Text(globals.BillNo_For_Test_popup,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                Spacer(),
                Text(globals.Bill_amount_Test_popup,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17))
              ]),
            )
          : Row(),
      Row(
        children: [
          SizedBox(
              width: 185,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 1),
                child: Text(data["SERVICE_NAME"].toString(),
                    style: TextStyle(color: Colors.indigo)),
              )),
          Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 1),
            child: Text(data["AMOUNT"].toString(),
                style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    ],
  ));
}

ListView UserListTestNameAmountBookings(var data, BuildContext contex) {
  var myData = data["Data"].length;
  return ListView.builder(
      itemCount: myData,
      //  scrollDirection: Axis.vertical,
      //  globals.selectedLogin_Data["Data"].length
      itemBuilder: (context, index) {
        return userTestNameAmountBookings(data["Data"][index], index, context);
      });
}

/*---------------------------------------------------User TsetAnd Amount Popup------------------------------------------ */
