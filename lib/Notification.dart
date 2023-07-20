import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asterlabs/Widgets/BottomNavigation.dart';
import './PatientHome.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

TextEditingController CancelReaSON = TextEditingController();

class BookingINProgressNotification extends StatefulWidget {
  const BookingINProgressNotification({Key? key}) : super(key: key);

  @override
  State<BookingINProgressNotification> createState() =>
      _BookingINProgressNotification();
}

class _BookingINProgressNotification
    extends State<BookingINProgressNotification> {
  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    Future<List<ProgressNotification>> _FetchProgressNotification() async {
      Map data = {
        "MobileNo": globals.mobNO,
        "Flag": "INP_N",
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
            .map((managers) => ProgressNotification.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget ListProgressNotification = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<ProgressNotification>>(
            future: _FetchProgressNotification(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return SizedBox(
                    child: _ProgressNotiFicationListView(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xff123456),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PatientHome()));
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Row(
          children: [
            Text(
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            TextButton.icon(
                onPressed: () {
                  setState(() {});
                },
                label: Text("Refresh",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ))
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        ListProgressNotification,
      ])),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}

class ProgressNotification {
  final display_name;
  final bill_no;
  final bill_id;
  final bill_dt;
  final gender;
  final net_amt;
  final outstanding_due;
  final Assigned_DT;
  final Accepted_DT;
  final Started_DT;
  final Reached_DT;
  final Reject_DT;
  final Completed_DT;
  final Status;
  final Employee;
  final Employee_Mob_No;
  final Reject_Reason;
  final Uploaded_Prescription;
  final ReQuire_CancEl;
  ProgressNotification({
    required this.display_name,
    required this.bill_no,
    required this.bill_id,
    required this.bill_dt,
    required this.gender,
    required this.net_amt,
    required this.outstanding_due,
    required this.Assigned_DT,
    required this.Accepted_DT,
    required this.Started_DT,
    required this.Reached_DT,
    required this.Reject_DT,
    required this.Completed_DT,
    required this.Status,
    required this.Employee,
    required this.Employee_Mob_No,
    required this.Reject_Reason,
    required this.Uploaded_Prescription,
    required this.ReQuire_CancEl,
  });
  factory ProgressNotification.fromJson(Map<String, dynamic> json) {
    return ProgressNotification(
      display_name: json['DISPLAY_NAME'].toString(),
      bill_no: json['BILL_NO'].toString(),
      bill_id: json['BILL_ID'].toString(),
      bill_dt: json['BILL_DT'].toString(),
      gender: json['GENDER'].toString(),
      net_amt: json['NET_AMOUNT'].toString(),
      outstanding_due: json['OUTSTANDING_DUE'].toString(),
      Assigned_DT: json['ASSIGNED_DT'].toString(),
      Accepted_DT: json['ACCEPTED_DT'].toString(),
      Started_DT: json['START_DT'].toString(),
      Reached_DT: json['REACHED_DT'].toString(),
      Reject_DT: json['REJECT_DT'].toString(),
      Completed_DT: json['COMPLETED_DT'].toString(),
      Status: json['STATUS'].toString(),
      Employee: json['EMPLOYEE'].toString(),
      Employee_Mob_No: json['EMP_MOBILE'].toString(),
      Reject_Reason: json['REJECT_REASON'].toString(),
      Uploaded_Prescription: json['UPLOAD_PRESCRIPTION'].toString(),
      ReQuire_CancEl: json['IS_REQ_CANCEL'].toString(),
    );
  }
}

ListView _ProgressNotiFicationListView(data, BuildContext contex) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _ProgressNotiFication(data[index], context);
    },
  );
}

Widget _ProgressNotiFication(var data, BuildContext context) {
  final mediaQuery = MediaQuery.of(context);

  CanCELTesT(BILL_Number, CANcelReason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (globals.Session_ID == null || globals.Session_ID == "") {
      globals.Session_ID = prefs.getString('SeSSion_ID')!;
    }
    Map data = {
      "Bill_no": BILL_Number,
      "Session_id": globals.Session_ID,
      "connection": globals.Patient_App_Connection_String,
      "Service_id": CANcelReason,
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
          context,
          MaterialPageRoute(
              builder: ((context) => BookingINProgressNotification())));
      CancelReaSON.text = "";
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  void ShowUploadPrescripTIon(BuildContext context, String PrescripTIONImage) {
    // Decode the Base64 string
    //Uint8List bytes = base64.decode(PrescripTIONImage);
    Uint8List DecodedPresCRIPtion = base64Decode(PrescripTIONImage);

    // Convert the decoded bytes to a string
    // String DecodedPresCRIPtion = utf8.decode(bytes);
    showDialog(
        context: context,
        barrierDismissible: true,
        //context: _scaffoldKey.currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.only(left: 25, right: 25),
              title: Card(
                  color: Color(0xff123456),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey)),
                  elevation: 4.0,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
                      child: Center(
                        child: Text("Prescription ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ))),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: SizedBox(
                height: 240,
                width: 200,
                child: Image.memory(DecodedPresCRIPtion),
              ));
        });
  }

  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => SERvicEDEtailS(
                    data.Reject_DT,
                    data.Assigned_DT,
                    data.Accepted_DT,
                    data.Started_DT,
                    data.Reached_DT,
                    data.Completed_DT,
                    data.Employee,
                    data.Employee_Mob_No))));
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 1),
          child: ListTile(
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: BorderSide(
                  width: 1, color: Color.fromARGB(255, 149, 147, 147)),
              borderRadius: BorderRadius.circular(20),
            ),
            leading: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 24, 36, 113),
                child: Icon(Icons.difference_outlined)),
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(data.display_name.toString(),
                      style: TextStyle(
                          color: Color(0xff123456),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0)),
                  data.Uploaded_Prescription != "null" &&
                          data.Uploaded_Prescription != null &&
                          data.Uploaded_Prescription != ""
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                              onTap: () {
                                ShowUploadPrescripTIon(
                                    context, data.Uploaded_Prescription);
                              },
                              child: Icon(
                                Icons.image,
                                size: 18,
                                color: Colors.blueGrey,
                              )),
                        )
                      : Text(""),
                  Spacer(),
                  Text('\u{20B9} ' + data.net_amt.toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 218, 75, 65),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0)),
                  // (data.ReQuire_CancEl == "Y")
                  //     ? InkWell(
                  //         onTap: () {
                  //           showDialog<String>(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return StatefulBuilder(builder:
                  //                     (BuildContext context,
                  //                         StateSetter setState) {
                  //                   return AlertDialog(
                  //                       shape: const RoundedRectangleBorder(
                  //                           borderRadius: BorderRadius.all(
                  //                               Radius.circular(16.0))),
                  //                       title: const Text('Cancel Order :',
                  //                           style: TextStyle(
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w500)),
                  //                       content: SingleChildScrollView(
                  //                           child: ConstrainedBox(
                  //                         constraints: BoxConstraints(
                  //                           maxHeight: MediaQuery.of(context)
                  //                                   .size
                  //                                   .height *
                  //                               0.1, // Set the preferred height here
                  //                         ),
                  //                         child: Column(
                  //                           children: [
                  //                             TextFormField(
                  //                               autofocus: true,
                  //                               keyboardType:
                  //                                   TextInputType.text,
                  //                               controller: CancelReaSON,
                  //                               decoration: InputDecoration(
                  //                                 border: OutlineInputBorder(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             50)),
                  //                                 // prefixIcon:
                  //                                 //     Icon(Icons
                  //                                 //         .phone_android),
                  //                                 focusColor: Color(0xff123456),
                  //                                 hintText: 'Cancel Reason',
                  //                               ),
                  //                             ),
                  //                             Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.end,
                  //                               children: [
                  //                                 InkWell(
                  //                                   child: SizedBox(
                  //                                     width: 50,
                  //                                     height: 30,
                  //                                     child: Card(
                  //                                       color: Color.fromARGB(
                  //                                           255, 21, 50, 179),
                  //                                       elevation: 2.0,
                  //                                       shape:
                  //                                           RoundedRectangleBorder(
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           4)),
                  //                                       child: Padding(
                  //                                         padding:
                  //                                             const EdgeInsets
                  //                                                 .all(3.0),
                  //                                         child: Center(
                  //                                             child: Text("ok",
                  //                                                 style: TextStyle(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     fontSize: 14 *
                  //                                                         mediaQuery
                  //                                                             .textScaleFactor,
                  //                                                     fontWeight:
                  //                                                         FontWeight
                  //                                                             .w600))),
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   onTap: () {
                  //                                     CanCELTesT(data.bill_no,
                  //                                         CancelReaSON.text);
                  //                                   },
                  //                                 ),
                  //                               ],
                  //                             )
                  //                           ],
                  //                         ),
                  //                       )));
                  //                 });
                  //               });
                  //         },
                  //         child: Card(
                  //             color: Color.fromARGB(255, 216, 33, 20),
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(8)),
                  //             child: Padding(
                  //                 padding:
                  //                     const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                  //                 child: Center(
                  //                   child: Text("Cancel",
                  //                       style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 11.0)),
                  //                 ))),
                  //       )
                  //     : SizedBox(),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(data.bill_no.toString(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 90, 133, 173),
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 4),
                    child: Row(
                      children: [
                        Text(data.bill_dt.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 90, 133, 173),
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0)),
                        Spacer(),
                        if (data.Status == "Assigned")
                          Card(
                              color: Color.fromARGB(255, 221, 180, 65),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Assigned",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Accepted")
                          Card(
                              color: Color.fromARGB(255, 25, 160, 66),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Accepted",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Started")
                          Card(
                              color: Color.fromARGB(255, 174, 178, 178),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Started",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Reached")
                          Card(
                              color: Color.fromARGB(255, 191, 76, 176),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Reached",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Completed")
                          Card(
                              color: Color.fromARGB(255, 108, 86, 214),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Completed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else if (data.Status == "Rejected")
                          Card(
                              color: Color.fromARGB(255, 235, 30, 26),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Rejected",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  )))
                        else
                          Card(
                              color: Color.fromARGB(255, 233, 117, 28),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6.0, 4, 6, 4),
                                  child: Center(
                                    child: Text("Pending",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.0)),
                                  ))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            trailing: Icon(Icons.arrow_circle_right),
          )));
}

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}

String Reject_DaTe = "";
String Assigned_DaTe = "";
String Accepted_DaTe = "";
String Started_DaTe = "";
String Reached_DaTe = "";
String Completed_DaTe = "";
String Employee_PhleBO = "";
String Employee_MobILe_No = "";

class SERvicEDEtailS extends StatefulWidget {
  SERvicEDEtailS(RJCT_DT, ASIGN_DT, ACCPT_DT, STRT_DT, RCHD_DT, CMPL_DT,
      EMPL_PHLBO, EMP_MO_NO) {
    Reject_DaTe = "";
    Assigned_DaTe = "";
    Accepted_DaTe = "";
    Started_DaTe = "";
    Reached_DaTe = "";
    Completed_DaTe = "";
    Employee_PhleBO = "";
    Employee_MobILe_No = "";
    Reject_DaTe = RJCT_DT;
    Assigned_DaTe = ASIGN_DT;
    Accepted_DaTe = ACCPT_DT;
    Started_DaTe = STRT_DT;
    Reached_DaTe = RCHD_DT;
    Completed_DaTe = CMPL_DT;
    Employee_PhleBO = EMPL_PHLBO;
    Employee_MobILe_No = EMP_MO_NO;
  }

  @override
  State<SERvicEDEtailS> createState() => _SERvicEDEtailSState();
}

class _SERvicEDEtailSState extends State<SERvicEDEtailS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xff123456),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context, true);
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Row(
          children: [
            Text(
              'Booking Details',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            TextButton.icon(
                onPressed: () {
                  setState(() {});
                },
                label: Text("Refresh",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ))
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Reject_DaTe == null || Reject_DaTe == "null"
            ? Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey)),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Container(
                            height: 38,
                            width: MediaQuery.of(context).size.width,
                            // color: Color.fromARGB(255, 16, 59, 135),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 176, 185, 193),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                                bottomLeft: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0),
                              ),
                            ),
                            child: Center(
                                child: Text(
                              "Booking Status",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                        ),
                        Row(
                          children: [
                            Assigned_DaTe != null && Assigned_DaTe != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                " Assigned :",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Assigned_DaTe != null && Assigned_DaTe != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(Assigned_DaTe,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 128, 125, 125))),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Accepted_DaTe != null && Accepted_DaTe != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Accepted :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ),
                            Accepted_DaTe != null && Accepted_DaTe != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(Accepted_DaTe,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 128, 125, 125))),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Started_DaTe != null && Started_DaTe != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Started :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ),
                            Started_DaTe != null && Started_DaTe != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(Started_DaTe,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 128, 125, 125))),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Reached_DaTe != null && Reached_DaTe != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "4",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Reached :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ),
                            Reached_DaTe != null && Reached_DaTe != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 22.0),
                                    child: Text(Reached_DaTe,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 128, 125, 125))),
                                  )
                                : Text("")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Completed_DaTe != null && Completed_DaTe != "null"
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                : Container(
                                    height: 20,
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 33, 94, 150),
                                        radius: 9.0,
                                        child: ClipRRect(
                                          child: Text(
                                            "5",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(" Completed :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ),
                            Completed_DaTe != null && Completed_DaTe != "null"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(Completed_DaTe,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 128, 125, 125))),
                                  )
                                : Text("")
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0.0),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey)),
                    elevation: 4.0,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Container(
                                  height: 38,
                                  width: MediaQuery.of(context).size.width,
                                  // color: Color.fromARGB(255, 16, 59, 135),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 176, 185, 193),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Booking Status",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                              Row(
                                children: [
                                  Reject_DaTe != null && Reject_DaTe != "null"
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 20,
                                        )
                                      : Container(
                                          height: 20,
                                          child: CircleAvatar(
                                              backgroundColor: Color.fromARGB(
                                                  255, 33, 94, 150),
                                              radius: 9.0,
                                              child: ClipRRect(
                                                child: Text(
                                                  "6",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                ),
                                              ))),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(" Rejected :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black)),
                                  ),
                                  Reject_DaTe != null && Reject_DaTe != "null"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(Reject_DaTe,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      255, 128, 125, 125))),
                                        )
                                      : Text("")
                                ],
                              ),
                            ])))),
        Assigned_DaTe != null && Assigned_DaTe != "null" ||
                Completed_DaTe != "null" && Completed_DaTe != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey)),
                  elevation: 4.0,
                  child: Column(
                    children: [
                      Container(
                        height: 36,
                        // color: Color.fromARGB(255, 16, 59, 135),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 176, 185, 193),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.0),
                            topLeft: Radius.circular(12.0),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          "Phlebotomist",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                            child: Icon(Icons.person,
                                color: Color.fromARGB(255, 153, 182, 209)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(Employee_PhleBO.toString(),
                                style: TextStyle(
                                    color: Color(0xff123456),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
                              child: Text(
                                "Make a Phone Call",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 15, 103, 170),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            InkWell(
                              child: Icon(
                                Icons.call,
                                size: 18,
                                color: Colors.green,
                              ),
                              onTap: () {
                                String Number = Employee_MobILe_No.toString();
                                _callNumber(Number);
                                // UrlLauncher.launch('tel:+ $Number');
                                //launchDialer(Number);
                                // callNumber();
                                // _launchPhoneURL("8456849320");
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            : Text("")
      ])),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}
