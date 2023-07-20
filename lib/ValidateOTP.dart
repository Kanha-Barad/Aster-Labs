import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import './UserProfile.dart';
import './PatientLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyTrends.dart';
import 'Notification.dart';
import 'OrdersHistory.dart';

import 'PatientHome.dart';
import 'Screens/Book_Test_screen.dart';
import 'book_home_visit.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

TextEditingController MobileNocontroller = TextEditingController();
TextEditingController OTPController = TextEditingController();
var ValiDate_Flag = '';

class ValidateOTP extends StatefulWidget {
  ValidateOTP(vld_flg) {
    ValiDate_Flag = '';
    ValiDate_Flag = vld_flg;
  }

  @override
  State<ValidateOTP> createState() => _ValidateOTPState();
}

class _ValidateOTPState extends State<ValidateOTP> {
  PatientOTP() async {
    //globals.logindata = await SharedPreferences.getInstance();
    if (OTPController.text.toString() == "" ||
        OTPController.text.toString() == null) {
      return OTPError();
    }

    Map data = {
      "msg_id": globals.MsgId.split('.')[0],
      "otp": OTPController.text,
      "connection": globals.Patient_App_Connection_String
      //"Server_Flag":""
    };
    final response = await http.post(
        Uri.parse(
            globals.Global_Patient_Api_URL + '/PatinetMobileApp/ValidateOtp'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      OTPController.text = '';
      if (resposne["Data"].length == 0)
      // && resposne["Data"] == ""
      {
        //   Successtoaster();
        loginerror();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OredersHistory()));
      }
      globals.Booking_Status_Flag =
          resposne["Data"][0]['STATUS_FLAG'].toString();
      globals.Session_ID = resposne["Data"][0]['SESSION_ID'].toString();
      globals.selectedLogin_Data = jsonDecode(response.body);
      globals.umr_no = resposne["Data"][0]['UMR_NO'].toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        //  prefs.setString('Status_FLag', globals.Booking_Status_Flag).toString();
        prefs.setString('SeSSion_ID', globals.Session_ID).toString();
        prefs.setString('singleUMr_No', globals.umr_no).toString();
        prefs.setString('email', globals.Session_ID).toString();

        prefs.setString("Otp", OTPController.text);
        // prefs.getStringList('data1') ?? [];
        (prefs.setString('data1', json.encode(map)));
      });

      // prefs.setInt('counter', int.parse(globals.sesson_Id));
      //globals.logindata.setString('username', globals.sesson_Id);

      if (globals.umr_no != "") {
        if (ValiDate_Flag == "B") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductOverviewPage()));
        } else if (ValiDate_Flag == "T") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTrends()));
        } else if (ValiDate_Flag == "H") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Book_Home_Visit(0)));
        } else if (ValiDate_Flag == "UP") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UsersProfile()));
        } else if (ValiDate_Flag == "N") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingINProgressNotification()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OredersHistory()));
          OTPController.text = '';
          MobileNocontroller.text = '';
        }
      }
      // else {
      //   return loginerror();
      // }

      throw Exception('Failed to load jobs from API');
      // OTPController.text = '';
    }
//     else if(response.statusCode == 200 && response.body:"{"status":"401","message":"Please Check The Details","Data":[]}"
// )
// {

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[500],
        body: AlertDialog(
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: [
                PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(20),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeColor: Color(0xff123456),
                    inactiveColor: Colors.blueGrey,
                    activeFillColor: Colors.black,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  // backgroundColor: Colors.blue.shade50,
                  // enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  controller: OTPController,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {
                    debugPrint(value);
                    // setState(() {
                    //   //      currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 120,
                      child: Card(
                          color: Color(0xff123456),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                              onPressed: () {
                                print(MobileNocontroller.text);
                                print(OTPController.text);

                                PatientOTP();
                              },
                              child: Text('Validate OTP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)))),
                    ),
                    SizedBox(
                      height: 45,
                      width: 100,
                      child: Card(
                          color: Color(0xffc4d8ec),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("Msg_id", "");
                                prefs.setString('Mobileno', "");

                                prefs.setString('email', "");

                                prefs.setString("Otp", "");
                                // prefs.getStringList('data1') ?? [];
                                (prefs.setString('data1', ""));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PatientLogin("")));
                              },
                              child: Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)))),
                    ),
                  ],
                ),
              ],
            )));
  }
}

OTPError() {
  return Fluttertoast.showToast(
      msg: "Please enter OTP",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 206, 19, 12),
      textColor: Colors.white,
      fontSize: 16.0);
}

loginerror() {
  return Fluttertoast.showToast(
      msg: "Enter valid OTP",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(230, 228, 55, 32),
      textColor: Colors.white,
      fontSize: 16.0);
}
