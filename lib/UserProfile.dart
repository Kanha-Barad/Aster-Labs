import 'dart:convert';

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
    // Future<List<UserProfile>> _fetchSaleTransaction() async {
    //   // var jobsListAPIUrl = null;
    //   // var dsetName = '';

    //   // Map data = {

    //   //   "msg_id": globals.MsgId.split('.')[0],
    //   //   "otp": OTPController.text
    //   // };
    //   // dsetName = 'Data';
    //   // jobsListAPIUrl = Uri.parse("");
    //   //    // 'http://115.112.254.129/MobileSalesApi/PatinetMobileApp/ValidateOtp');
    //   // var response = await http.post(jobsListAPIUrl,
    //   //     headers: {
    //   //       "Accept": "application/json",
    //   //       "Content-Type": "application/x-www-form-urlencoded"
    //   //     },
    //   //     body: data,
    //   //     encoding: Encoding.getByName("utf-8"));

    //   // if (response.statusCode == 200) {
    //   //   Map<String, dynamic> resposne = jsonDecode(response.body);
    //   //   List jsonResponse = resposne[dsetName];

    //   //   return jsonResponse
    //   //       .map((strans) => new UserProfile.fromJson(strans))
    //   //       .toList();
    //   // } else {
    //   //   throw Exception('Failed to load jobs from API');
    //   // }
    // }

    Widget UserProfileverticalLists =
        //if(globals.selectedLogin_Data!=""){
        UserProfileListView(globals.selectedLogin_Data);
    //     }  ;
    // Container(
    //   // height: MediaQuery.of(context).size.height * 0.4,
    //   margin: EdgeInsets.symmetric(vertical: 2.0),
    //   child: FutureBuilder<List<UserProfile>>(
    //       future: _fetchSaleTransaction(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           var data = snapshot.data;
    //           if (snapshot.data!.isEmpty == true) {
    //             return NoContent();
    //           } else {
    //             return UserProfileListView(data);
    //           }
    //         } else if (snapshot.hasError) {
    //           return Text("${snapshot.error}");
    //         }
    //          if(globals.selectedLogin_Data!=""){
    //          return UserProfileListView(globals.selectedLogin_Data);
    //       }
    //         return Center(
    //             child: CircularProgressIndicator(
    //           strokeWidth: 4.0,
    //         ));

    //       }),

    // );
    Widget myBottomNavigationBar = Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Color.fromARGB(255, 7, 185, 141),
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

                  if (prefs.getString('Mobileno') != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientLogin("")),
                    );
                  } else {
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
        bottomNavigationBar: myBottomNavigationBar);
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
                              color: Color.fromARGB(255, 7, 185, 141),
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
                                  color: Color(0xff123456),
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
                                color: Color(0xff123456),
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

class UserProfile {
  final mob_no;
  final display_name;
  final gender;
  final email_id;
  final address;
  final date_of_birth;
  UserProfile({
    required this.mob_no,
    required this.display_name,
    required this.gender,
    required this.email_id,
    required this.address,
    required this.date_of_birth,
  });
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    if (json['EMAIL_ID'] == null || json['EMAIL_ID'] == "") {
      json['EMAIL_ID'] = 'Not Specified.';
    }
    if (json['ADDRESS1'] == null || json['EMAIL_ID'] == "") {
      json['ADDRESS1'] = 'Not Specified.';
    }
    return UserProfile(
      mob_no: json['MOBILE_NO1'].toString(),
      display_name: json['DISPLAY_NAME'].toString(),
      gender: json['GENDER'].toString(),
      email_id: json['EMAIL_ID'].toString(),
      address: json['ADDRESS1'].toString(),
      date_of_birth: json['DOB'].toString(),
    );
  }
}
