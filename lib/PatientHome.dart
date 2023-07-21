import 'dart:convert';

import 'package:badges/badges.dart';

import './OrdersHistory.dart';
import './UserProfile.dart';

import 'ClientCodeLogin.dart';
import 'Screens/Book_Test_screen.dart';
import 'Upload_Prescription.dart';
import 'Widgets/BottomNavigation.dart';
import 'Widgets/cart_items.dart';
import 'book_home_visit.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import './PatientLogin.dart';
import './MyTrends.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Notification.dart';

class PatientHome extends StatefulWidget {
  String empID = "0";
  Dashboard(String iEmpid) {
    empID = iEmpid;
    this.empID = iEmpid;
  }

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  // @override
  // void initState() {
  //   super.initState();
  //   //_loadCounter();
  // }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  _SaveOrderHIStroy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OredersHistory()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("")));
    }
  }

  _SaveLoginDataTrends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }

    if (globals.mobNO != "" && globals.mobNO != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyTrends()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("T")));
    }
  }

  _SaveLoginDataBookATest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');

    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      // (globals.Session_ID != "0" &&
      //     globals.Session_ID != "" &&
      //     globals.Session_ID != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProductOverviewPage()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("B")));
    }
  }

  HomeVisitBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      // (globals.Session_ID != "0" &&
      //     globals.Session_ID != "" &&
      //     globals.Session_ID != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Book_Home_Visit(0)));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("H")));
    }
  }

  InProgressNotofication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globals.logindata1 = (prefs.getString('email') ?? '');
    globals.mobNO = (prefs.getString('Mobileno') ?? '');
    if (prefs.getString('data1') != null && prefs.getString('data1') != "") {
      Map<String, dynamic> resposne =
          (jsonDecode(prefs.getString('data1') ?? ''));
      globals.selectedLogin_Data = resposne;
    }
    if (globals.mobNO != "" && globals.mobNO != null) {
      // (globals.Session_ID != "0" &&
      //     globals.Session_ID != "" &&
      //     globals.Session_ID != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookingINProgressNotification()));
    } else if (globals.mobNO == "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PatientLogin("N")));
    }
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    Future<List<PreferredServices>> _fetchManagerDetails() async {
      Map data = {
        "connection": globals.Patient_App_Connection_String,
        //  "employee_id": "",
        // "mobile": globals.mobNO,
        //  "session_id": globals.sesson_Id
        //"Server_Flag":""
      };
      final jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
          '/PatinetMobileApp/PreferedServices');

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
            .map((managers) => PreferredServices.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget PreferredServicesDetails = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<PreferredServices>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return SizedBox(
                    child: PreferredServicesListView(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff123456),
          // backgroundColor: Color.fromARGB(179, 239, 243, 247),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Image.asset("assets/images/asterlabs.png"),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: <Widget>[
            new Stack(
              children: <Widget>[
                new IconButton(
                    icon: Icon(
                      Icons.notifications,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      InProgressNotofication();
                      setState(() {
                        counter = 0;
                      });
                    }),
                counter != 0
                    ? new Positioned(
                        right: 11,
                        top: 11,
                        child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$counter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : new Container()
              ],
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xff123456),
                ),
                child: Container(
                  child: Column(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: SizedBox(
                            height: 55.0,
                            width: 100.0,
                            child: Image.asset("assets/images/asterlabs.png")),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
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
                  leading: const Icon(Icons.person),
                  title: const Text("Profile")),
              ListTile(
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
                        MaterialPageRoute(
                            builder: (context) => OredersHistory()),
                      );
                    }
                  },
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text("Order History")),
              SizedBox(
                height: 380,
              ),
              ListTile(
                  onTap: () {},
                  // trailing: const Icon(Icons.phone),
                  title: Text("Powered by \u00a9 Suvarna TechnoSoft"))
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: ListView(
                  children: [
                    CarouselSlider(
                      items: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            //  margin: EdgeInsets.all(0.0),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/slider1.jpg",
                                ),
                              ),
                            ),
                          ),
                        ),

                        //2nd Image of Slider
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            //   margin: EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/slider2.jpg",
                                ),
                              ),
                            ),
                          ),
                        ),

                        //3rd Image of Slider
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            //   margin: EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/slider3.jpg",
                                ),
                              ),
                            ),
                          ),
                        ),

                        //4th Image of Slider
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            //    margin: EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/slider4.jpg",
                                ),
                              ),
                            ),
                          ),
                        ),

                        //5th Image of Slider
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            //     margin: EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/slider5.jpg",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 150.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        // aspectRatio: 16 / 40,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color.fromARGB(179, 168, 185, 202),
                // height: 60,
                // width: MediaQuery.of(context).size.width * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      // height: 55,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                        child: TextButton(
                          onPressed: () {
                            _SaveOrderHIStroy();
                          },
                          child: Text(
                            'My Reports',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              backgroundColor: Colors.white),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                    //   child: SizedBox(
                    //       height: 43.0,
                    //       width: 80.0,
                    //       child: Image.asset("assets/images/asterlabs.png")),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                      child: Container(
                        height: 50.0,
                        width: 70.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/asterlabs.png"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      // height: 55,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                        child: TextButton(
                          onPressed: () {
                            _SaveLoginDataTrends();
                          },
                          child: Text('My Trends',
                              style: TextStyle(color: Colors.black)),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              backgroundColor: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Our Services",
                    style: TextStyle(
                        color: Color(0xff123456),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (() {
                          globals.Location_BookedTest = "";
                          _SaveLoginDataBookATest();
                          cartController.clear();
                          productcontroller.resetAll();
                          globals.GlobalDiscountCoupons = '';
                        }),
                        child: ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFA18875),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Icon(Icons.account_circle_outlined,
                                  color: Color(
                                      0xFFA18875))), // You can replace this with your own icon or image
                          title: Text(
                            'Book a Test',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          // subtitle: Text('Description of first content'),
                        ),
                      ),
                      Divider(), // Optional: add a divider between the two pieces of content
                      GestureDetector(
                          onTap: (() {
                            globals.selectDate = "";
                            globals.SelectedlocationId = "";
                            HomeVisitBook();
                            globals.GlobalDiscountCoupons = '';
                          }),
                          child: ListTile(
                            leading: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFEC407A),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Icon(Icons.home_outlined,
                                    color: Color(
                                        0xFFEC407A))), // You can replace this with your own icon or image
                            title: Text(
                              'Book a Home Visit',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            // subtitle: Text('Description of second content'),
                          )),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text('Health Packages',
                      style: TextStyle(
                          color: Color(0xff123456),
                          fontWeight: FontWeight.bold,
                          fontSize: 20))
                ],
              ),
              SizedBox(height: 8),
              Container(
                  color: Color.fromARGB(179, 168, 185, 202),
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PreferredServicesDetails,
                  )),
            ],
          ),
        ),
        bottomNavigationBar: AllBottOMNaviGAtionBar(),
      ),
    );
  }
}

ListView PreferredServicesListView(data, BuildContext context) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _PreferredServicesDetails(data[index], context);
    },
    scrollDirection: Axis.horizontal,
  );
}

Widget _PreferredServicesDetails(var data, BuildContext context) {
  return GestureDetector(
      child: (data.SERVICE_TYPE_ID == '6' || data.SERVICE_TYPE_ID == '7')
          ? SizedBox(
              width: 135,
              // height: 130,
              child: Card(
                  color: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 6),
                            child: Text(
                              data.srv_grp_name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 18),
                            child: Text(
                              '\u{20B9} ' + data.srv_price,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 2, 2),
                          child: Text(
                            data.srv_name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ])),
            )
          : Card());
}

class PreferredServices {
  final srv_name;
  final srv_grp_name;
  final srv_price;
  final srv_type;
  final SERVICE_TYPE_ID;
  PreferredServices({
    required this.srv_name,
    required this.srv_grp_name,
    required this.srv_price,
    required this.srv_type,
    required this.SERVICE_TYPE_ID,
  });
  factory PreferredServices.fromJson(Map<String, dynamic> json) {
    return PreferredServices(
      srv_name: json['SERVICE_NAME'].toString(),
      srv_grp_name: json['SERVICE_GROUP_NAME'].toString(),
      srv_price: json['PRICE'].toString(),
      srv_type: json['SERVICE_TYPE'].toString(),
      SERVICE_TYPE_ID: json['SERVICE_TYPE_ID'].toString(),
    );
  }
}
