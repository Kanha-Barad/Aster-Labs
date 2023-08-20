import 'dart:convert';

import 'package:asterlabs/TestBooking.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import './UserProfile.dart';
import './PatientLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyTrends.dart';
import 'Notification.dart';
import 'OrdersHistory.dart';

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
  bool isLoading = false;
  PatientOTP() async {
    //globals.logindata = await SharedPreferences.getInstance();
    if (OTPController.text.toString() == "" ||
        OTPController.text.toString() == null) {
      return OTPError();
    }
    setState(() {
      isLoading = true; // Show loading indicator
    });

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
      if (resposne["Data"].length == 0) {
        loginerror();
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

      if (globals.umr_no.isNotEmpty == true ) {
        if (ValiDate_Flag == "B") {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => bookATeSt("0")));
        } else if (ValiDate_Flag == "T") {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyTrends()));
        } else if (ValiDate_Flag == "H") {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Book_Home_Visit(0)));
        } else if (ValiDate_Flag == "UP") {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UsersProfile()));
        } else if (ValiDate_Flag == "N") {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingINProgressNotification()));
        } else {
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OredersHistory()));
          OTPController.text = '';
          MobileNocontroller.text = '';
        }
      }
      throw Exception('Failed to load jobs from API');
      // OTPController.text = '';
    }
  }

  bool isButtonDisabled = false;

  Future<void> ValidateOTPFunTion() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
        isLoading = true; // Show loading indicator
      });

      // Call your API here to validate OTP
      await PatientOTP();

      // No need for delay, the button will be re-enabled automatically after the API call
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[500],
        body: Stack(children: [
      AlertDialog(
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
                  activeColor: Color.fromARGB(255, 7, 185, 141),
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
                },
                beforeTextPaste: (text) {
                  return true;
                },
                appContext: context,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print(MobileNocontroller.text);
                        print(OTPController.text);
                        ValidateOTPFunTion();
                      },
                      child: Card(
                          color: Color.fromARGB(255, 7, 185, 141),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(255, 215, 242, 243)),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text('Validate OTP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          )),
                    ),
                    InkWell(
                      onTap: () async {
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
                                builder: (context) => PatientLogin("")));
                      },
                      child: Card(
                          color: Color.fromARGB(255, 178, 236, 239),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(255, 33, 208, 199)),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 9, 25, 9),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )),
      if (isLoading)
        Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
              colors: [
                // Color.fromARGB(255, 49, 213, 169),
                // Color.fromARGB(255, 246, 246, 246),
                Color.fromARGB(255, 49, 114, 179),
              ],
              strokeWidth: 4.0,
            ),
          ),
        ),
    ]));
  }
}

OTPError() {
  return Fluttertoast.showToast(
      msg: "Please enter OTP",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}

loginerror() {
  return Fluttertoast.showToast(
      msg: "Enter valid OTP",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}
