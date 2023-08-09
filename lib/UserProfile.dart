import 'dart:convert';

import 'package:asterlabs/Widgets/BottomNavigation.dart';
import 'package:flutter/material.dart';
import './OrdersHistory.dart';
import './PatientHome.dart';
import './PatientLogin.dart';
import 'package:http/http.dart' as http;
import 'ClientCodeLogin.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class UsersProfile extends StatefulWidget {
  const UsersProfile({Key? key}) : super(key: key);

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  @override
  Widget build(BuildContext context) {
    Widget UserProfileverticalLists =
        //if(globals.selectedLogin_Data!=""){
        UserProfileListView(globals.selectedLogin_Data);
    //     }  ;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 7, 185, 141),
          centerTitle: true,
          //  backgroundColor: Color.fromARGB(179, 239, 243, 247),
          automaticallyImplyLeading: false,
          // leading: Builder(
          //   builder: (context) => IconButton(
          //     icon: Icon(Icons.menu_rounded, color: Colors.white),
          //     onPressed: () => Scaffold.of(context).openDrawer(),
          //   ),
          // ),
        ),
        body: Container(
          child: UserProfileverticalLists,
        ),
        bottomNavigationBar: AllBottOMNaviGAtionBar());
  }
}

Widget UserProfileListView(data) {
  int i = 0;
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (data[index] != null) {
          return _UserProfileCard(data[index], context, index);
        } else {
          return _UserProfileCard(data["Data"], context, index);
        }
      });
}

Widget _UserProfileCard(data, BuildContext context, index) {
  return GestureDetector(
      onTap: () {},
      child: (index == 0)
          ? Column(
              children: [
                Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Color.fromARGB(216, 223, 223, 223),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 90,
                              color: Color.fromARGB(255, 90, 133, 173),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              // data[0]{['.display_name,']}
                              data[0]["DISPLAY_NAME"].toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              data[0]["GENDER"].toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 11),
                            )
                          ],
                        ))),
                Card(
                  child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 90, 133, 173),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                width: 25,
                                height: 25,
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('Contact Information')
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(35, 12, 0.0, 5.0),
                            child: Text(data[0]["MOBILE_NO1"].toString()),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(35, 5.0, 0.0, 5.0),
                            child: Text(
                              (data[0]["EMAIL_ID"].toString() == null)
                                  ? ''
                                  : data[0]["EMAIL_ID"].toString(),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ),
                        ],
                      )),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 90, 133, 173),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                              ),
                              width: 25,
                              height: 25,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Personal InFormation')
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 12, 0.0, 5.0),
                          child: Text(data[0]["DOB"].toString()),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 5.0, 0.0, 5.0),
                          child: Text(
                            data[0]["ADDRESS1"].toString(),
                            style: TextStyle(fontSize: 11, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Column());
}

// class UserProfile {
//   final mob_no;
//   final display_name;
//   final gender;
//   final email_id;
//   final address;
//   final date_of_birth;
//   UserProfile({
//     required this.mob_no,
//     required this.display_name,
//     required this.gender,
//     required this.email_id,
//     required this.address,
//     required this.date_of_birth,
//   });
//   factory UserProfile.fromJson(Map<String, dynamic> json) {
//     if (json['EMAIL_ID'] == null || json['EMAIL_ID'] == "") {
//       json['EMAIL_ID'] = 'Not Specified.';
//     }
//     if (json['ADDRESS1'] == null || json['EMAIL_ID'] == "") {
//       json['ADDRESS1'] = 'Not Specified.';
//     }
//     return UserProfile(
//       mob_no: json['MOBILE_NO1'].toString(),
//       display_name: json['DISPLAY_NAME'].toString(),
//       gender: json['GENDER'].toString(),
//       email_id: json['EMAIL_ID'].toString(),
//       address: json['ADDRESS1'].toString(),
//       date_of_birth: json['DOB'].toString(),
//     );
//   }
// }
