import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'PatientHome.dart';
import 'globals.dart' as globals;

TextEditingController AccessCodeController = TextEditingController();

class AccessClientCodeLogin extends StatefulWidget {
  @override
  State<AccessClientCodeLogin> createState() => _AccessClientCodeLoginState();
}

class _AccessClientCodeLoginState extends State<AccessClientCodeLogin> {
  @override
  Widget build(BuildContext context) {
    AccessCodeLogin(AccessCode, BuildContext context) async {
      var isLoading = true;
      Map data = {
        "IP_USER_NAME": "",
        "IP_PASSWORD": "",
        "IP_ACCESS_CODE": AccessCode,
        "connection": "7"
      };
      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.Global_All_Client_Api_URL +
              '/Logistics/APP_VALIDATION_MOBILE'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (resposne["message"] == "success") {
          Successtoaster();
        } else {
          errormsg1();
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(prefs.getString('AppCODE'));
        //setState(() {
          prefs
              .setString(
                  'AppCODE', jsonDecode(response.body)['Data'][0]['APP_CD'])
              .toString();
          prefs
              .setString(
                  'PatientAppApiURL',
                  utf8.decode(base64
                      .decode(jsonDecode(response.body)['Data'][0]['API_URL'])))
              .toString();
          prefs.setString(
              "ConnectionString",
              utf8.decode(base64.decode(
                  jsonDecode(response.body)['Data'][0]['CONNECTION_STRING'])));

          prefs.setString(
              "CompanyLogo",
              utf8.decode(base64.decode(
                  jsonDecode(response.body)['Data'][0]['COMPANY_LOGO'])));

          prefs.setString(
              "ReportURL",
              utf8.decode(base64
                  .decode(jsonDecode(response.body)['Data'][0]['REPORT_URL'])));
          prefs.setString(
              "OTPURL",
              utf8.decode(base64
                  .decode(jsonDecode(response.body)['Data'][0]['OTP_URL'])));
       // });
        globals.Client_App_Code = (prefs.getString('AppCODE') ?? '');
        globals.Global_Patient_Api_URL =
            (prefs.getString('PatientAppApiURL') ?? '');
        globals.Patient_App_Connection_String =
            (prefs.getString('ConnectionString') ?? '');
        globals.All_Client_Logo = (prefs.getString('CompanyLogo') ?? '');
        globals.Patient_report_URL = (prefs.getString('ReportURL') ?? '');
        globals.Patient_OTP_URL = (prefs.getString('OTPURL') ?? '');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PatientHome()));
        AccessCodeController.text = "";
      } else {
        errormsg1();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Stack(alignment: Alignment.center, children: <Widget>[
        // SizedBox(
        //   height: 80,
        //   child: Image.asset(
        //     'assets/images/suvarna-logo.png',
        //     fit: BoxFit.cover,
        //   ),
        // ),

        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 40),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      "Welcome to Your EMR",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  // height: 340,
                  //width: 400,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(232, 110, 168, 224),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(18),
                        bottomRight: Radius.circular(60),
                        bottomLeft: Radius.circular(18),
                      )),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 15, 25, 5),
                      child: Column(children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/EMRAccessCodeLogo.png"),
                                  fit: BoxFit.fitWidth)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(95, 213, 228, 231),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(),
                                child: TextField(
                                  controller: AccessCodeController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Access Code",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            AccessCodeLogin(AccessCodeController.text, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: 40,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]))),
              Padding(
                padding: const EdgeInsets.only(top: 190),
                child: Center(
                    child: Text(
                  "Powered by  \u00a9 Suvarna TechnoSoft Pvt Ltd.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                )),
              )
            ],
          ),
        )
      ])),
    );
  }
}

errormsg1() {
  return Fluttertoast.showToast(
      msg: "Invalid Access Code",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

Successtoaster() {
  return Fluttertoast.showToast(
      msg: "Access Code Verified Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}
