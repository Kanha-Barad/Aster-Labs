import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asterlabs/Widgets/BottomNavigation.dart';
import './MyTrends.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

TextEditingController CancelReason = TextEditingController();

class OredersHistory extends StatefulWidget {
  const OredersHistory({Key? key}) : super(key: key);

  @override
  State<OredersHistory> createState() => _OredersHistoryState();
}

class _OredersHistoryState extends State<OredersHistory> {
  //  abc(index) {
  //   setState(() {
  //     _selectedColorIndex = index;
  //   });
  // }
  ListView PatientIconListView(var data, BuildContext contex, String FLAG) {
    var myData = data["Data"].length;
    //jsonEncode(data, toEncodable: (e) => e.toJsonAttr());
    //Object.entries(data);

    //final c = json.decode(data).toString();

    return ListView.builder(
        itemCount: myData,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // return  Text(myData[index]["Frequency"].toString());
          return _buildPatientIconCard(
              data["Data"][index], index, context, FLAG);
        });
  }

  Widget _buildPatientIconCard(data, index, context, FLAG) {
    int _selectedIndex = int.parse(globals.flag_index);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: EdgeInsets.all(1.6),
          child: InkWell(
            child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                color: _selectedIndex == index
                    ? Color.fromARGB(255, 30, 92, 153)
                    : Color.fromARGB(192, 221, 194, 193),
                child: _selectedIndex == index
                    ? Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 3, 1, 0),
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              // SizedBox(
                              //   width: 5,
                              // ),
                            ],
                          ),
                          Column(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 8.0, 2.0, 0.0),
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    data["DISPLAY_NAME"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    data["UMR_NO"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 3, 1, 0),
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              // SizedBox(
                              //   width: 5,
                              // ),
                            ],
                          ),
                          Column(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 8.0, 2.0, 0.0),
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    data["DISPLAY_NAME"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    data["UMR_NO"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
            onTap: () {
              globals.selectedIcon = data;
              globals.dis_name = data["DISPLAY_NAME"];
              globals.flag_index = index.toString();
              globals.umr_no = data["UMR_NO"];
              var datsetvalues = [];
              datsetvalues = globals.selectedLogin_Data["Data"];
              //_updateItems(datsetvalues, index, 0);
              globals.selectedLogin_Data["Data"] = datsetvalues;

              setState(() {});
              CompletedTab();
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CompletedTab()));
            },
          )),
    );
  }

  Widget build(BuildContext context) {
    Future<List<Orderhistory>> _fetchManagerDetails() async {
      Map data = {
        "MobileNo": globals.mobNO,
        "Flag": "INP_" + globals.flag_index + "",
        // "UMR_NO": umr_No
        "UMR_NO": "umr_No",
        "connection": globals.Patient_App_Connection_String

        //"Server_Flag":""
      };
      final jobsListAPIUrl =
          // Uri.parse(
          //     'http://115.112.254.129/MobileSalesApi/PatinetMobileApp/OrderList');
          Uri.parse(
              globals.Global_Patient_Api_URL + '/PatinetMobileApp/OrderList');
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
            .map((managers) => Orderhistory.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget PatientSelection = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Orderhistory>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty == true) {
                  //return NoContent();
                  return PatientIconListView(
                      globals.selectedLogin_Data, context, "INC");
                } else {
                  return PatientIconListView(
                      globals.selectedLogin_Data, context, "INC");
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 7, 185, 141),
          toolbarHeight: 115,
          leadingWidth: 0,
          bottom: TabBar(
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              unselectedLabelColor: Color.fromARGB(255, 73, 71, 71),
              tabs: [
                Tab(text: 'Completed'),
                Tab(text: 'In Progress'),

                Tab(text: 'Cancelled')

                //  isScrollable: true,
              ]),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    'My Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyTrends()));
                        },
                        icon: Icon(
                          Icons.legend_toggle_rounded,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 0.0),
                child: Row(
                  children: [
                    Text(
                      'Family Members',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              //  Divider(thickness: 1, color: Colors.black38),
              SizedBox(
                height: 1,
              ),
              SizedBox(height: 56, child: PatientSelection),
            ],
          ),
        ),

        // drawer: Drawer(

        body: TabBarView(
          //   physics: NeverScrollableScrollPhysics(),
          children: [
            CompletedTab(),
            InProgressTab(),
            CancelledTab(),
          ],
        ),
        bottomNavigationBar: AllBottOMNaviGAtionBar(),
      ),
    );
  }
}

class InProgressTab extends StatefulWidget {
  const InProgressTab({Key? key}) : super(key: key);

  @override
  State<InProgressTab> createState() => _InProgressTabState();
}

class _InProgressTabState extends State<InProgressTab> {
  @override
  Widget build(BuildContext context) {
    Future<List<Orderhistory>> _fetchManagerDetails() async {
      Map data = {
        "MobileNo": globals.mobNO,
        "Flag": "INP_" + globals.flag_index + "",

        "UMR_NO": globals.umr_no,
        "connection": globals.Patient_App_Connection_String

        //"Server_Flag":""
      };
      final jobsListAPIUrl =
          // Uri.parse(
          //     'http://115.112.254.129/MobileSalesApi/PatinetMobileApp/OrderList');
          Uri.parse(
              globals.Global_Patient_Api_URL + '/PatinetMobileApp/OrderList');

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
            .map((managers) => Orderhistory.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget InProgressDetails = Container(
        // height: MediaQuery.of(context).size.height,
        // height: 100,
        child: FutureBuilder<List<Orderhistory>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();
                } else {
                  return OrderListListView(data, context, 'INP');
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.70,
                child: InProgressDetails),
          ],
        ),
      ),
    );
  }
}

class CompletedTab extends StatefulWidget {
  const CompletedTab({Key? key}) : super(key: key);

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  Widget build(BuildContext context) {
    Future<List<Orderhistory>> _fetchManagerDetails() async {
      Map data = {
        "MobileNo": globals.mobNO,

        "Flag": "A_" + globals.flag_index + "",
        "UMR_NO": globals.umr_no,
        "connection": globals.Patient_App_Connection_String

        //"Server_Flag":""
      };
      final jobsListAPIUrl =
          // Uri.parse(
          //     'http://115.112.254.129/MobileSalesApi/PatinetMobileApp/OrderList');
          Uri.parse(
              globals.Global_Patient_Api_URL + '/PatinetMobileApp/OrderList');
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
            .map((managers) => Orderhistory.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget CompletedDetails = Container(
        // height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Orderhistory>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();
                } else {
                  return SizedBox(child: OrderListListView(data, context, 'A'));
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: CompletedDetails),
      ])),
    );
  }
}

class CancelledTab extends StatefulWidget {
  const CancelledTab({Key? key}) : super(key: key);

  @override
  State<CancelledTab> createState() => _CancelledTabState();
}

class _CancelledTabState extends State<CancelledTab> {
  @override
  Widget build(BuildContext context) {
    Future<List<Orderhistory>> _fetchManagerDetails() async {
      Map data = {
        "MobileNo": globals.mobNO,
        "Flag": "C_" + globals.flag_index + "",

        "UMR_NO": globals.umr_no,
        "connection": globals.Patient_App_Connection_String

        //"Server_Flag":""
      };
      final jobsListAPIUrl =
          // Uri.parse(
          //     'http://115.112.254.129/MobileSalesApi/PatinetMobileApp/OrderList');
          Uri.parse(
              globals.Global_Patient_Api_URL + '/PatinetMobileApp/OrderList');
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
            .map((managers) => Orderhistory.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget CancelledDetails = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<Orderhistory>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();
                } else {
                  return SizedBox(child: OrderListListView(data, context, 'C'));
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: CancelledDetails),
      ])),
    );
  }
}

class Orderhistory {
  final display_name;
  final bill_no;
  final bill_id;
  final bill_dt;
  final gender;
  final net_amt;
  final outstanding_due;
  final ReQuire_CancEl;
  Orderhistory({
    required this.display_name,
    required this.bill_no,
    required this.bill_id,
    required this.bill_dt,
    required this.gender,
    required this.net_amt,
    required this.outstanding_due,
    required this.ReQuire_CancEl,
  });
  factory Orderhistory.fromJson(Map<String, dynamic> json) {
    return Orderhistory(
      display_name: json['DISPLAY_NAME'].toString(),
      bill_no: json['BILL_NO'].toString(),
      bill_id: json['BILL_ID'].toString(),
      bill_dt: json['BILL_DT'].toString(),
      gender: json['GENDER'].toString(),
      net_amt: json['NET_AMOUNT'].toString(),
      outstanding_due: json['OUTSTANDING_DUE'].toString(),
      ReQuire_CancEl: json['IS_REQ_CANCEL'].toString(),
    );
  }
}

ListView OrderListListView(data, BuildContext contex, String flg) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _OrderListDetails(data[index], context, flg);
    },
  );
}

Widget _OrderListDetails(var data, BuildContext context, flg) {
  final mediaQuery = MediaQuery.of(context);

  CanCELTesT(BILL_Number, cancelREASON) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (globals.Session_ID == null || globals.Session_ID == "") {
      globals.Session_ID = prefs.getString('SeSSion_ID')!;
    }
    Map data = {
      "Bill_no": BILL_Number,
      "Session_id": globals.Session_ID,
      "connection": globals.Patient_App_Connection_String,
      "Service_id": cancelREASON,
      //"Server_Flag":""
    };
    print(data.toString());

    final response = await http.post(
        Uri.parse(globals.Global_Patient_Api_URL +
            '/PatinetMobileApp/CancelPatientBill'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      List jsonResponse = resposne["Data"];
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => OredersHistory())));
      CancelReason.text = "";
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  return GestureDetector(
    onTap: () {
      // globals.SelectedPatientDetails = data;
      // _BottomPicker(context, data.bill_no.toString());
    },
    child: Container(
        child: Column(
      children: [
        (flg == 'INP')
            ? GestureDetector(
                onTap: () {
                  globals.SelectedPatientDetails = data;
                  _BottomPicker(context, data.bill_no.toString(), 'INP');
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 1, 8, 0),
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    //height: 85,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 5.0),
                            child: Row(
                              children: [
                                Text(
                                  data.display_name,
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Text(
                                  data.gender.toString(),
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 1.0),
                            child: Row(
                              children: [
                                Text(
                                  data.bill_no,
                                  style: TextStyle(fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  data.bill_dt,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\u{20B9} ' + data.net_amt,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Text(
                                //   'Track',
                                //   style: TextStyle(fontSize: 12),
                                // ),
                                (data.ReQuire_CancEl == "Y")
                                    ? SizedBox(
                                        height: 33,
                                        width: 62,
                                        child: InkWell(
                                            child: Card(
                                              color: Color.fromARGB(
                                                  255, 30, 92, 153),
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Center(
                                                    child: Text("Cancel",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14 *
                                                                mediaQuery
                                                                    .textScaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                      return AlertDialog(
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16.0))),
                                                          title: const Text(
                                                              'Cancel Order :',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          content:
                                                              SingleChildScrollView(
                                                                  child:
                                                                      ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.12, // Set the preferred height here
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                TextFormField(
                                                                  autofocus:
                                                                      true,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  controller:
                                                                      CancelReason,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50)),
                                                                    // prefixIcon:
                                                                    //     Icon(Icons
                                                                    //         .phone_android),
                                                                    focusColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            30,
                                                                            92,
                                                                            153),
                                                                    hintText:
                                                                        'Cancel Reason',
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                          Card(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            21,
                                                                            50,
                                                                            179),
                                                                        elevation:
                                                                            2.0,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(4)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3.0),
                                                                          child:
                                                                              Center(child: Text("ok", style: TextStyle(color: Colors.white, fontSize: 14 * mediaQuery.textScaleFactor, fontWeight: FontWeight.w600))),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        CanCELTesT(
                                                                            data.bill_no,
                                                                            CancelReason.text);
                                                                      },
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )));
                                                    });
                                                  });
                                            }),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 72,
                            width: 380,
                            child: SizedBox(
                                child: Theme(
                              data: ThemeData(
                                  accentColor: Color.fromARGB(255, 7, 185, 141),
                                  //primarySwatch: Colors.greenAccent,
                                  colorScheme: ColorScheme.light(
                                      primary:
                                          Color.fromARGB(255, 7, 185, 141))),
                              child: Stepper(
                                type: StepperType.horizontal,
                                physics: const ScrollPhysics(),
                                // currentStep: _currentStep,
                                // onStepTapped: (step) => _stepTapped(step),
                                // onStepContinue: _stepContinue,
                                // onStepCancel: _stepCancel,
                                steps: [
                                  // The first step: Name
                                  Step(
                                      title: Column(
                                        children: [
                                          Text('Billed'),
                                          // "data.billdate" != "null"
                                          //     ? Text("data.billdate")
                                          //     : Text(''),
                                        ],
                                      ),
                                      content: Text(""),
                                      isActive: "data.billdate" != "null",
                                      state: "data.billdate" != "null"
                                          ? StepState.complete
                                          : StepState.editing
                                      //state: StepState.error,
                                      ),
                                  Step(
                                      title: Column(
                                        children: [
                                          Text('In Progress'),
                                          // "data.billdate" != "null"
                                          //     ? Text("data.billdate")
                                          //     : Text(''),
                                        ],
                                      ),
                                      content: Text(""),
                                      isActive: "data.billdate" != "null",
                                      state: "data.billdate" != "null"
                                          ? StepState.complete
                                          : StepState.editing
                                      //state: StepState.error,
                                      ),
                                  Step(
                                      title: Column(
                                        children: [
                                          Text('Completed'),
                                          // "data.billdate" != "null"
                                          //     ? Text("data.billdate")
                                          //     : Text(''),
                                        ],
                                      ),
                                      content: Text(""),
                                      //  isActive: "data.billdate" != "null",
                                      state: "data.billdate" != "null"
                                          ? StepState.complete
                                          : StepState.editing
                                      //state: StepState.error,
                                      ),
                                ],
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        (flg == 'A')
            ? GestureDetector(
                onTap: () {
                  globals.SelectedPatientDetails = data;
                  _BottomPicker(context, data.bill_no.toString(), 'A');
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 1, 8, 0),
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    //height: 85,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 5.0),
                            child: Row(
                              children: [
                                Text(
                                  data.display_name,
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Text(
                                  data.gender.toString(),
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 1.0),
                            child: Row(
                              children: [
                                Text(
                                  data.bill_no,
                                  style: TextStyle(fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  data.bill_dt,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\u{20B9} ' + data.net_amt,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                // (double.parse(data.outstanding_due) > 0)
                                //     ? SizedBox(
                                //         height: 33,
                                //         width: 69,
                                //         child: InkWell(
                                //             child: Card(
                                //               color: Color.fromARGB(
                                //                   255, 226, 145, 24),
                                //               elevation: 2.0,
                                //               shape: RoundedRectangleBorder(
                                //                   borderRadius:
                                //                       BorderRadius.circular(4)),
                                //               child: Padding(
                                //                 padding:
                                //                     const EdgeInsets.all(3.0),
                                //                 child: Center(
                                //                     child: Text("Pay Now",
                                //                         style: TextStyle(
                                //                             color: Colors.white,
                                //                             fontSize: 14,
                                //                             fontWeight:
                                //                                 FontWeight
                                //                                     .w500))),
                                //               ),
                                //             ),
                                //             onTap: () {}),
                                //       )
                                //     : SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 72,
                            width: 380,
                            child: SizedBox(
                                child: Theme(
                              data: ThemeData(
                                  accentColor: Colors.green,
                                  primarySwatch: Colors.green,
                                  colorScheme:
                                      ColorScheme.light(primary: Colors.green)),
                              child: Stepper(
                                type: StepperType.horizontal,
                                physics: const ScrollPhysics(),
                                // currentStep: _currentStep,
                                // onStepTapped: (step) => _stepTapped(step),
                                // onStepContinue: _stepContinue,
                                // onStepCancel: _stepCancel,
                                steps: [
                                  // The first step: Name
                                  Step(
                                      title: Column(
                                        children: [
                                          Text('Billed'),
                                          // "data.billdate" != "null"
                                          //     ? Text("data.billdate")
                                          //     : Text(''),
                                        ],
                                      ),
                                      content: Text(""),
                                      isActive: "data.billdate" != "null",
                                      state: "data.billdate" != "null"
                                          ? StepState.complete
                                          : StepState.editing
                                      //state: StepState.error,
                                      ),
                                  Step(
                                      title: Column(
                                        children: [
                                          Text('In Progress'),
                                          // "data.billdate" != "null"
                                          //     ? Text("data.billdate")
                                          //     : Text(''),
                                        ],
                                      ),
                                      content: Text(""),
                                      isActive: "data.billdate" != "null",
                                      state: "data.billdate" != "null"
                                          ? StepState.complete
                                          : StepState.editing
                                      //state: StepState.error,
                                      ),
                                  Step(
                                      title: Column(
                                        children: [
                                          Text('Completed'),
                                          // "data.billdate" != "null"
                                          //     ? Text("data.billdate")
                                          //     : Text(''),
                                        ],
                                      ),
                                      content: Text(""),
                                      isActive: "data.billdate" != "null",
                                      state: "data.billdate" != "null"
                                          ? StepState.complete
                                          : StepState.editing
                                      //state: StepState.error,
                                      ),
                                ],
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        (flg == 'C')
            ? GestureDetector(
                onTap: () {
                  globals.SelectedPatientDetails = data;
                  _BottomPicker(context, data.bill_no.toString(), 'C');
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 1, 8, 0),
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    //   height: 85,
                    child: Container(
                      //
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 5.0),
                            child: Row(
                              children: [
                                Text(
                                  data.display_name,
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Text(
                                  data.gender.toString(),
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 1.0),
                            child: Row(
                              children: [
                                Text(
                                  data.bill_no,
                                  style: TextStyle(fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  data.bill_dt,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                            child: Row(
                              children: [
                                Text(
                                  '\u{20B9} ' + data.net_amt,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 12),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ],
    )),
  );
}

/*---------------------------------Bottom PopUp---------------------------------------*/
String Bill_noval = '';
String repeat_Flag = "";

class PatientBottomPopup extends StatefulWidget {
  PatientBottomPopup(billno, Repeat_flg) {
    Bill_noval = "";
    repeat_Flag = "";
    Bill_noval = billno.toString();
    repeat_Flag = Repeat_flg.toString();
  }
  @override
  State<PatientBottomPopup> createState() => _PatientBottomPopupState();
}

class _PatientBottomPopupState extends State<PatientBottomPopup> {
  @override
  Widget build(BuildContext context) {
    Future<List<patientDetails>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';

      Map data = {
        "bill_id": Bill_noval,
        "connection": globals.Patient_App_Connection_String
      };
      dsetName = 'Data';
      jobsListAPIUrl = Uri.parse(
          globals.Global_Patient_Api_URL + '/PatinetMobileApp/BillServices');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne[dsetName];
        globals.PatientRepeatOrder = jsonDecode(response.body);

        return jsonResponse
            .map((strans) => new patientDetails.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget PatientDataverticalLists = Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: FutureBuilder<List<patientDetails>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return NoContent();
              } else {
                return PatientDataListView(data);
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                    globals.SelectedPatientDetails.display_name.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Spacer(),
              // (repeat_Flag == 'A')
              //     ? SizedBox(
              //         height: 33,
              //         width: 69,
              //         child: InkWell(
              //             child: Card(
              //               color: Color.fromARGB(255, 26, 177, 122),
              //               elevation: 2.0,
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(4)),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Center(
              //                     child: Text("Repeat",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 15,
              //                             fontWeight: FontWeight.w500))),
              //               ),
              //             ),
              //             onTap: () {
              //               print(globals.PatientRepeatOrder["Data"]);
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => CartScreen()));
              //             }),
              //       )
              //     : Text(
              //         // globals.PatientDetails.age.split(',')[0].toString() +
              //         //     '/' +
              //         globals.SelectedPatientDetails.gender.toString(),
              //         style: TextStyle(
              //             fontSize: 15,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white),
              //       ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 7, 185, 141),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: PatientDataverticalLists,
          ),
        ));
  }
}

Widget PatientDataListView(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _PatientDataCard(data[index], context, index);
      });
}

Widget _PatientDataCard(data, BuildContext context, index) {
  return GestureDetector(
      onTap: () {
        //   globals.PatientDetails = data;
        // globals.PatientRepeatOrder = data;
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey, width: 0.6)),
          color: MaterialStateColor.resolveWith(
              (states) => Color.fromARGB(255, 248, 248, 248)),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
                  child: Text(data.srvname,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                Spacer(),
                Text(
                  data.srvstats1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                (data.srvstats1 == "Completed" || data.srvstats1 == "Dispatch")
                    ? IconButton(
                        onPressed: () {
                          (globals.SelectedPatientDetails.outstanding_due ==
                                  '0.0')
                              ? _launchURL(data.reportCd.toString())
                              : AlertError();
                        },
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ))
                    : IconButton(onPressed: () {}, icon: Icon(null))
              ],
            ),
          ]),
        ),
      ));
}

class patientDetails {
  final srvname;
  final srvstats1;
  final billNo;
  final displyName;
  final mobNo1;
  final age;
  final gendr;
  final reportCd;

  patientDetails(
      {required this.srvname,
      required this.srvstats1,
      required this.billNo,
      required this.displyName,
      required this.mobNo1,
      required this.age,
      required this.gendr,
      required this.reportCd});

  factory patientDetails.fromJson(Map<String, dynamic> json) {
    // var pdfdownloader =
    //     json['REPORT_CD'].toString() + json['BILL_NO'].toString();
    return patientDetails(
        srvname: json['SERVICE_NAME'].toString(),
        srvstats1: json['SERVICE_STATUS1'].toString(),
        billNo: json['BILL_NO'].toString(),
        displyName: json['DISPLAY_NAME'].toString(),
        mobNo1: json['MOBILE_NO1'].toString(),
        age: json['AGE'].toString(),
        gendr: json['GENDER'].toString(),
        reportCd: json['REPORT_CD'].toString());
  }
}

void _BottomPicker(BuildContext context, billno, flg) {
  var res = showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Container(
      //  width: ,
      //  height: MediaQuery.of(context).size.height * 0.4,
      //  color: Color(0xff123456),
      //  width: 300,
      height: MediaQuery.of(context).size.height * 0.4,
      child: PatientBottomPopup(billno.toString(), flg),
    ),
  );
  print(res);
}

_launchURL(reportCd) async {
  var url = globals.Patient_report_URL + reportCd;
//NM live
  //"http://115.112.254.129/NM_SRV_GRP_MERGE_PDFS/" + reportCd + ".pdf"
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class NoContent extends StatelessWidget {
  const NoContent();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Color.fromARGB(255, 30, 92, 153),
              size: 30,
            ),
            const Text('No Data Found', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

AlertError() {
  return Fluttertoast.showToast(
      msg: "Please Pay the Outstanding due",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}

/*---------------------------------Bottom PopUp---------------------------------------*/

