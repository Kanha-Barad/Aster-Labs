import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../PatientHome.dart';
import '../UserProfile.dart';
import 'dart:math' as math;
import 'package:asterlabs/globals.dart' as globals;
import '../MyBookings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var DAta = globals.selectedLogin_Data;
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Padding(
              padding: const EdgeInsets.only(top: 22,left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DAta["Data"][0]["DISPLAY_NAME"],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DAta["Data"][0]["MOBILE_NO1"],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            accountEmail: Text((DAta["Data"][0]["EMAIL_ID"] == null)
                ? ''
                : DAta["Data"][0]["EMAIL_ID"].toString()),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  AssetImage("assets/images/asterlabs.png"), // Your image path
              backgroundColor: Color.fromARGB(255, 210, 233, 228),
            ),
            decoration: BoxDecoration(
              color:
                  Color.fromARGB(255, 7, 185, 141), // Desired background color
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("My Orders"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyBooking()));
              //  Get.to(() => PatientHome());
            },
          ),
        ],
      ),
    );
  }
}
