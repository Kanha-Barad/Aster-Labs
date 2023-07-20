import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import './PatientLogin.dart';
import './PatientLogin.dart';
import 'globals.dart' as globals;

TextEditingController NameController = TextEditingController();
TextEditingController MobNoController = TextEditingController();
TextEditingController AgeController = TextEditingController();
TextEditingController MailIdController = TextEditingController();
TextEditingController AddressController = TextEditingController();

class PatientRegister extends StatefulWidget {
  const PatientRegister({Key? key}) : super(key: key);

  @override
  State<PatientRegister> createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  var selectedSalutation;
  var Gender_Id = '';
  RegisterPatient() async {
    if (selectedSalutation == 'Male') {
      Gender_Id = '1';
    } else {
      Gender_Id = '2';
    }
    Map data = {
      "pat_name": NameController.text,
      "gender_id": Gender_Id.toString(),
      "age": AgeController.text,
      "pincode": '',
      "address": AddressController.text,
      "Mob_no": MobNoController.text,
      "location": "",
      "email_id": MailIdController.text,
      "connection": globals.Patient_App_Connection_String
      //"Server_Flag":""
    };
    print(data.toString());

    final response = await http.post(
        Uri.parse(globals.Global_Patient_Api_URL +
            '/PatinetMobileApp/Savepatirntreg'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      //   List jsonResponse = resposne["Data"];

      globals.patient_id =
          resposne["Data"][0]['PATIENT_ID'].toString().split('.')[0];
      globals.Session_ID = resposne["Data"][0]['SESSION_ID'].toString();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      //     setState(() {
      //       prefs.setString('Patient_ID',
      //           jsonDecode(response.body)['PATIENT_ID'].toString().split('.')[0]);
      //       prefs.setString(
      //           'SeSSion_ID', jsonDecode(response.body)['Data'][0]['SESSION_ID'].toString());
      //           });
      // globals.patient_id = (prefs.getString('Patient_ID') ?? '');
      //   //  resposne["Data"][0]['PATIENT_ID'].toString().split('.')[0];
      // globals.Session_ID = (prefs.getString('SeSSion_ID') ?? '');

      // globals.selectedLogin_Data = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg: "Registered Sucessfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 27, 165, 114),
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PatientLogin(MobNoController.text)));
    } else {
      Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(232, 243, 49, 24),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GenderDropDown = Container(
      height: 50,
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedSalutation,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.male),
        ),
        hint: Text(
          'Enter Gender',
        ),
        onChanged: (salutation) =>
            setState(() => selectedSalutation = salutation!),
        validator: (value) => value == null ? 'field required' : null,
        items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Column(children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
            child: SizedBox(
                height: 90.0,
                width: 200.0,
                child: Image(image: AssetImage(globals.All_Client_Logo))),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            width: 300,
            //  padding: EdgeInsets.symmetric(vertical: 2),
            child: TextField(
              //   focusNode: myFocusNode,
              keyboardType: TextInputType.name,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter.digitsOnly
              // ],
              // obscureText: true,
              controller: NameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_pin_rounded),
                focusColor: Color(0xff123456),
                hintText: 'Enter Your Name',
              ),
            ),
          ),
          Container(
            height: 50,
            width: 300,
            padding: EdgeInsets.symmetric(vertical: 2),
            child: TextField(
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: MobNoController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_android),
                focusColor: Color(0xff123456),
                hintText: 'Enter mobile number',
              ),
            ),
          ),
          GenderDropDown,
          Container(
            height: 50,
            width: 300,
            padding: EdgeInsets.symmetric(vertical: 2),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: AgeController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.today),
                hintText: 'Enter Age',
              ),
            ),
          ),
          Container(
            height: 50,
            width: 300,
            padding: EdgeInsets.symmetric(vertical: 2),
            child: TextField(
              keyboardType: TextInputType.emailAddress,

              // obscureText: true,
              controller: MailIdController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline_outlined),
                focusColor: Color(0xff123456),
                hintText: 'Enter Your Mail',
              ),
            ),
          ),
          Container(
            height: 50,
            width: 300,
            padding: EdgeInsets.symmetric(vertical: 2),
            child: TextField(
              keyboardType: TextInputType.streetAddress,

              // obscureText: true,
              controller: AddressController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business_rounded),
                focusColor: Color(0xff123456),
                hintText: 'Enter Your Address',
              ),
            ),
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 110,
                child: Card(
                    color: Color(0xff123456),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                        onPressed: () {
                          bool isButtonDisabled = false;

                          void PatientREGIstraTIoN() {
                            if (!isButtonDisabled) {
                              setState(() {
                                isButtonDisabled = true; // Disable the button
                              });

                              // Call your API here to book the test
                              RegisterPatient();
                              // Example delay to simulate API call
                              Future.delayed(Duration(seconds: 2), () {
                                // Enable the button again after the delay
                                setState(() {
                                  isButtonDisabled = false;
                                });
                              });
                            }
                          }

                          if (NameController.text == null ||
                              NameController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Name",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (MobNoController.text == null ||
                              MobNoController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Mobile No",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (selectedSalutation == null ||
                              selectedSalutation == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Gender",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (AgeController.text == null ||
                              AgeController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Age",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (MailIdController.text == null ||
                              MailIdController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Mail Id",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (AddressController.text == null ||
                              AddressController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Address",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            return PatientREGIstraTIoN();
                          }
                        },
                        child: Text('Register',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)))),
              ),
              SizedBox(
                height: 50,
                width: 110,
                child: Card(
                    color: Color.fromARGB(237, 198, 219, 239),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientLogin("")));
                        },
                        child: Text('Cancel',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)))),
              ),
            ],
          )
        ]),
      )),
    );
  }
}

RegistrationError() {
  return Fluttertoast.showToast(
      msg: "Please Enter Details",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(232, 243, 49, 24),
      textColor: Colors.white,
      fontSize: 16.0);
}
