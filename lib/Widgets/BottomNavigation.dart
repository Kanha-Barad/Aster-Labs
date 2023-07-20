import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asterlabs/Controllers/product_controller.dart';
import 'package:asterlabs/Coupons.dart';

import '../ClientCodeLogin.dart';
import '../PatientHome.dart';
import '../PatientLogin.dart';
import '../UserProfile.dart';
import '../globals.dart' as globals;

class AllBottOMNaviGAtionBar extends StatefulWidget {
  const AllBottOMNaviGAtionBar({super.key});

  @override
  State<AllBottOMNaviGAtionBar> createState() => _AllBottOMNaviGAtionBarState();
}

class _AllBottOMNaviGAtionBarState extends State<AllBottOMNaviGAtionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 63,
        color: Color(0xff123456),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
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
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.getString('Mobileno') == "" ||
                        prefs.getString('Mobileno') == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientLogin("")),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UsersProfile()),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 19,
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
                    // globals.umr_no = "";
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
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
                    // (prefs.setString('Status_FLag', ''));
                    (prefs.setString('SeSSion_ID', ''));
                    (prefs.setString('singleUMr_No', ''));
                    cartController.items.clear();
//ProductController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("")),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => AccessClientCodeLogin()),
                    // );
                  },
                  child: Column(children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ]),
                ),
              )
            ],
          ),
        ));
  }
}
