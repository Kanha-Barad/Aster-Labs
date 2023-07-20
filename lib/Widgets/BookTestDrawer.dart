import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../PatientHome.dart';
import '../Screens/Book_Test_screen.dart';
import '../UserProfile.dart';
import 'dart:math' as math;

import '../MyBookings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Color(0xff123456),
            title: Text("Book Test", style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: false,
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
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.home),
          //   title: Text("Home Page"),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => PatientHome()));
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Transform.rotate(
          //       angle: -180 * math.pi / 180, child: Icon(Icons.filter_alt)),
          //   title: Text("Book A Test"),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => ProductOverviewPage())
          //             );
          //   },
          // ),
        ],
      ),
    );
  }
}
