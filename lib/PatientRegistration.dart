import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
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
  bool isRegistering = false;

  Future<void> RegisterPatient() async {
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

      Fluttertoast.showToast(
          msg: "Registered Sucessfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(189, 59, 227, 180),
          textColor: Colors.white,
          fontSize: 16.0);

      print("Before navigation");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientLogin(MobNoController.text),
        ),
      );
      print("After navigation");
    } else {
      Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 235, 103, 93),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  bool isButtonDisabled = false;

  Future<void> PatientREGIstraTIoN() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true;
        isRegistering = true; // Show the indicator
      });

      // Call your API here to register the patient
      await RegisterPatient();

      setState(() {
        isButtonDisabled = false;
        isRegistering = false; // Hide the indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GenderDropDown = Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
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
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 40),
            child: SizedBox(
                height: 150.0,
                width: 150.0,
                child: Image.asset(globals.All_Client_Logo)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
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
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (NameController.text == null ||
                        NameController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Enter Name",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 235, 103, 93),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (MobNoController.text == null ||
                        MobNoController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Enter Mobile No",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 235, 103, 93),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (selectedSalutation == null ||
                        selectedSalutation == "") {
                      Fluttertoast.showToast(
                          msg: "Please Enter Gender",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 235, 103, 93),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (AgeController.text == null ||
                        AgeController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Enter Age",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 235, 103, 93),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (MailIdController.text == null ||
                        MailIdController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Enter Mail Id",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 235, 103, 93),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (AddressController.text == null ||
                        AddressController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Enter Address",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 235, 103, 93),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      PatientREGIstraTIoN();
                    }
                    // RegisterPatient();
                    //PatientREGIstraTIoN();
                  },
                  child: Card(
                      color: Color.fromARGB(255, 7, 185, 141),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 216, 248, 247)),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                        child: Text('Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientLogin("")));
                  },
                  child: Card(
                      color: Color.fromARGB(255, 167, 236, 237),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 50, 224, 212)),
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
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
        ])),
        if (isRegistering)
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
      ]),
    );
  }
}

RegistrationError() {
  return Fluttertoast.showToast(
      msg: "Please Enter Details",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}



  

  //FutureBuilder<void>(
    //   future: RegisterPatient(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none:
    //         return SizedBox(); // Placeholder, could be an empty container
    //       case ConnectionState.waiting:
    //       case ConnectionState.active:
    //         return CircularProgressIndicator(); // Show a loading indicator
    //       case ConnectionState.done:
    //         // Registration is complete, handle the UI accordingly
    //         if (snapshot.hasError) {
    //           // Error occurred during registration
    //           return Text('Registration Failed',
    //               style: TextStyle(color: Colors.red, fontSize: 16));
    //         } else {
    //           // Registration is successful
    //           return Text('Registration Successful!',
    //               style: TextStyle(color: Colors.green, fontSize: 16));
    //         }
    //       default:
    //         return SizedBox(); // Placeholder, could be an empty container
    //     }
    //   },
    // );