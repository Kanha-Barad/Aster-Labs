import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asterlabs/Widgets/BottomNavigation.dart';
import 'package:asterlabs/thankYou_screen.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

String base64Image = "";
var Device_token_ID = "";

class UpLoadPrescrIPtioN extends StatefulWidget {
  const UpLoadPrescrIPtioN({Key? key}) : super(key: key);

  @override
  _UpLoadPrescrIPtioNState createState() => _UpLoadPrescrIPtioNState();
}

class _UpLoadPrescrIPtioNState extends State<UpLoadPrescrIPtioN> {
  final ImagePicker _picker = ImagePicker();
  File? file;
  DateTime selectedDate = DateTime.now();

  List<File?> files = [];
  // late Uint8List BYTes;
  bool isLoading = false;
  bool canClick = true;
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) {
      Device_token_ID = value!;
      print(value);
    });
    SavingBase64ImageSingleUser(BilLNuMbEr, billDATE) async {
      Map data = {
        "Bill_no": BilLNuMbEr,
        "connection": globals.Patient_App_Connection_String,
        "Base64string": globals.PresCripTion_Image_Converter,
      };
      final jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
          '/PatinetMobileApp/UpdateBytesimage');

      var bodys = json.encode(data);

      var response = await http.post(jobsListAPIUrl,
          headers: {"Content-Type": "application/json"}, body: bodys);
      print("${response.statusCode}");
      print("${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne["Data"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ThankYouScreenOFUploadPrescripTIOn(
                    BilLNuMbEr, billDATE, ""))));
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    UploadUserPrescriptionBooking() async {
      if (globals.SelectedlocationId == "" ||
          globals.SelectedlocationId == "0") {
        return Fluttertoast.showToast(
            msg: "Please Select the Location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 235, 103, 93),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (globals.Session_ID == null || globals.Session_ID == "") {
        globals.Session_ID = prefs.getString('SeSSion_ID')!;
      }
      if (globals.umr_no == null || globals.umr_no == "") {
        globals.umr_no = prefs.getString('singleUMr_No')!;
      }
      Map data = {
        "PATIENT_ID": "1",
        "UMR_NO": globals.umr_no,
        "TEST_IDS": "",
        "TEST_AMOUNTS": "0",
        "CONSESSION_AMOUNT": "0",
        "BILL_AMOUNT": "0",
        "DUE_AMOUNT": "0",
        "MOBILE_NO": globals.mobNO,
        "MOBILE_REG_FLAG": "y",
        "SESSION_ID": globals.Session_ID,
        "PAYMENT_MODE_ID": "1",
        "IP_NET_AMOUNT": "0",
        "IP_TEST_CONCESSION": "0",
        "IP_TEST_NET_AMOUNTS": "0",
        "IP_POLICY_ID": "",
        "IP_PAID_AMOUNT": "0",
        "IP_OUTSTANDING_DUE": "0",
        "connection": globals.Patient_App_Connection_String,
        "loc_id": globals.SelectedlocationId,
        "IP_SLOT": globals.Slot_id,
        "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_UPLOAD_IMG": globals.PresCripTion_Image_Converter.toString(),
        "IP_PRESCRIPTION": "",
        "IP_REMARKS": "",
        "Mobile_Device_Id": Device_token_ID,
      };

      final jobsListAPIUrl = Uri.parse(
          globals.Global_Patient_Api_URL + '/PatinetMobileApp/NewRegistration');

      var bodys = json.encode(data);

      var response = await http.post(jobsListAPIUrl,
          headers: {"Content-Type": "application/json"}, body: bodys);
      print("${response.statusCode}");
      print("${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne["Data"];
        globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();
        var bill_NUmber = resposne["Data"][0]["BILL_NO"].toString();
        var Bill_Date = resposne["Data"][0]["CREATE_DT"].toString();

        //  Push_Notification(context);
        SavingBase64ImageSingleUser(bill_NUmber, Bill_Date);
        globals.SelectedlocationId = "";
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    void _UserListBookingsBottomPicker(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
            height: 400, // Set the desired fixed height for the bottom popup
            child: Scaffold(
              appBar: AppBar(
                title: Text('Family Members',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Color.fromARGB(255, 7, 185, 141),
                leading: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    )),
              ),
              body: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display users based on global data here
                    // Each user should be a ListTile with an onTap callback
                    for (var userData in globals.selectedLogin_Data["Data"])
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.grey)),
                          child: ListTile(
                            leading: Icon(
                              Icons.account_circle_outlined,
                              size: 32,
                              color: Color.fromARGB(255, 49, 114, 179),
                            ),
                            title: Text(
                              userData["DISPLAY_NAME"],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              userData["UMR_NO"],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              setState(() {
                                isLoading = true; // Show loading indicator
                              });

                              Navigator.pop(context); // Close the popup
                              await UploadUserPrescriptionBooking(); // Call the API for selected user

                              setState(() {
                                isLoading = false; // Hide loading indicator
                                canClick = true;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Future<void> UsersUploadPrescriptionBooking() async {
      setState(() {
        isLoading = true;
        canClick = false;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String? encodedJson = prefs.getString('data1');
        // List<dynamic> decodedJson = json.decode(encodedJson!);
        if (globals.selectedLogin_Data == null) {
          globals.selectedLogin_Data = json.decode(encodedJson!);
        }
        globals.PresCripTion_Image_Converter = base64Image;
        if (files.length == 0) {
          UploadError();
        } else if (globals.selectedLogin_Data["Data"].length > 1) {
          _UserListBookingsBottomPicker(context);
        } else
          await UploadUserPrescriptionBooking();
      } catch (error) {
        print(error); // Handle errors here...
      }

      setState(() {
        isLoading = false;
        canClick = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color.fromARGB(255, 7, 185, 141),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          "Upload Prescription",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    maxHeight: 1920,
                    maxWidth: 1080,
                    // imageQuality: 100,
                    preferredCameraDevice: CameraDevice.rear);

                if (photo == null) {
                } else {
                  setState(() {
                    file = File(photo.path);
                    files.add(File(photo.path));
                    final BYTes = File(photo.path).readAsBytesSync();
                    base64Image = base64Encode(BYTes);
                    //  BYTes= base64.decode(base64Image);
                  });
                }
              },
              icon: Icon(Icons.camera_alt_outlined)),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            ListView.builder(
                itemCount: files.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return files[index] == null
                      ? const Text("No Image Selected")
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 83, 115, 148))),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(children: <Widget>[
                                Image.file(
                                  files[index]!,
                                  fit: BoxFit.cover,
                                  height: 480,
                                ),
                              ])),
                        );
                }),
            Spacer(),
            InkWell(
              onTap: canClick ? UsersUploadPrescriptionBooking : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 6),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Color.fromARGB(255, 49, 114, 179),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                          child: Text("Upload",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))),
                    )),
              ),
            )
          ],
        ),
        if (isLoading)
          Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: [
                  Color.fromARGB(255, 49, 114, 179),
                ],
                strokeWidth: 4.0,
              ),
            ),
          ),
      ]),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}

// _MultiUserListBookingsBottomPicker(BuildContext context) {
//   var res = showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => Container(
//           // color: Color.fromARGB(255, 236, 235, 235),
//           height: MediaQuery.of(context).size.height * 0.4,
//           child: MultiUserBookingsPopup()
//           // UserListBookings(globals.selectedLogin_Data, context),
//           ));
//   print(res);
// }

// class MultiUserBookingsPopup extends StatefulWidget {
//   const MultiUserBookingsPopup({Key? key}) : super(key: key);

//   @override
//   State<MultiUserBookingsPopup> createState() => _MultiUserBookingsPopupState();
// }

// class _MultiUserBookingsPopupState extends State<MultiUserBookingsPopup> {
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back_rounded,
//                 color: Colors.white,
//               )),
//           // automaticallyImplyLeading: false,
//           title: Text('Family Members', style: TextStyle(color: Colors.white)),
//           backgroundColor: Color.fromARGB(255, 7, 185, 141),
//         ),
//         body: MultiUserListBookings(globals.selectedLogin_Data, context),
//       ),
//     );
//   }
// }

// ListView MultiUserListBookings(var data, BuildContext contex) {
//   var myData = data["Data"].length;
//   return ListView.builder(
//       itemCount: myData,
//       scrollDirection: Axis.vertical,
//       itemBuilder: (context, index) {
//         return Container(
//             child: MultiUserBookings(data["Data"][index], context, index));
//       });
// }

// Widget MultiUserBookings(data, BuildContext context, index) {
//   DateTime selectedDate = DateTime.now();
//   SavingBase64ImageMultiUser(BilLNuMbEr, billDATE) async {
//     Map data = {
//       "Bill_no": BilLNuMbEr,
//       "connection": globals.Patient_App_Connection_String,
//       "Base64string": globals.PresCripTion_Image_Converter,
//     };
//     final jobsListAPIUrl = Uri.parse(
//         globals.Global_Patient_Api_URL + '/PatinetMobileApp/UpdateBytesimage');

//     var bodys = json.encode(data);

//     var response = await http.post(jobsListAPIUrl,
//         headers: {"Content-Type": "application/json"}, body: bodys);
//     print("${response.statusCode}");
//     print("${response.body}");
//     if (response.statusCode == 200) {
//       Map<String, dynamic> resposne = jsonDecode(response.body);
//       List jsonResponse = resposne["Data"];
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: ((context) => ThankYouScreenOFUploadPrescripTIOn(
//                   BilLNuMbEr, billDATE, ""))));
//     } else {
//       throw Exception('Failed to load jobs from API');
//     }
//   }

//   MultiUserTestBooking() async {
//     if (globals.SelectedlocationId == "" || globals.SelectedlocationId == "0") {
//       return Fluttertoast.showToast(
//           msg: "Select the Location",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Color.fromARGB(255, 235, 103, 93),
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (globals.Session_ID == null || globals.Session_ID == "") {
//       globals.Session_ID = prefs.getString('SeSSion_ID')!;
//     }
//     Map data = {
//       "PATIENT_ID": "1",
//       "UMR_NO": globals.umr_no,
//       "TEST_IDS": "",
//       "TEST_AMOUNTS": "0",
//       "CONSESSION_AMOUNT": "0",
//       "BILL_AMOUNT": "0",
//       "DUE_AMOUNT": "0",
//       "MOBILE_NO": globals.mobNO,
//       "MOBILE_REG_FLAG": "y",
//       "SESSION_ID": globals.Session_ID,
//       "PAYMENT_MODE_ID": "1",
//       "IP_NET_AMOUNT": "0",
//       "IP_TEST_CONCESSION": "0",
//       "IP_TEST_NET_AMOUNTS": "0",
//       "IP_POLICY_ID": "",
//       "IP_PAID_AMOUNT": "0",
//       "IP_OUTSTANDING_DUE": "0",
//       "loc_id": globals.SelectedlocationId,
//       "IP_SLOT": globals.Slot_id,
//       "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
//       "connection": globals.Patient_App_Connection_String,
//       "IP_UPLOAD_IMG": globals.PresCripTion_Image_Converter.toString(),
//       //globals.PresCripTion_Image_Converter.toString(),
//       "IP_PRESCRIPTION": "",
//       "IP_REMARKS": "",
//       "Mobile_Device_Id": Device_token_ID,
//     };

//     final jobsListAPIUrl = Uri.parse(
//         globals.Global_Patient_Api_URL + '/PatinetMobileApp/NewRegistration');

//     var bodys = json.encode(data);

//     var response = await http.post(jobsListAPIUrl,
//         headers: {"Content-Type": "application/json"}, body: bodys);
//     print("${response.statusCode}");
//     print("${response.body}");
//     // return response;
//     //var response = await http.post(jobsListAPIUrl,

//     // headers: {
//     //  "Accept": "application/json",
//     // "Content-Type": "application/json",
//     //},
//     //body: data
//     // encoding: Encoding.getByName("utf-8"));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> resposne = jsonDecode(response.body);
//       List jsonResponse = resposne["Data"];
//       // globals.Bill_No = resposne["Data"][0]["BILL_NO"].toString();

//       var bill_NUmber = resposne["Data"][0]["BILL_NO"].toString();
//       var Bill_Date = resposne["Data"][0]["CREATE_DT"].toString();
//       SavingBase64ImageMultiUser(bill_NUmber, Bill_Date);
//       globals.Slot_id = "";
//       globals.SelectedlocationId = "";
//     } else {
//       throw Exception('Failed to load jobs from API');
//     }
//   }

//   // bool isButtonDisabled = false;

//   // void MultiUserPaymentsBooking() {
//   //   if (!isButtonDisabled) {
//   //     isButtonDisabled = true; // Disable the button

//   //     // Call your API here to book the test
//   //     MultiUserTestBooking();
//   //     // Example delay to simulate API call
//   //     Future.delayed(Duration(seconds: 5), () {
//   //       // Enable the button again after the delay
//   //       isButtonDisabled = false;
//   //     });
//   //   }
//   // }
//   Future<void> _uploadMultiuSERBook(BuildContext context) async {
//     // Show the loading spinner first
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//           child: SizedBox(
//             height: 100,
//             width: 100,
//             child: LoadingIndicator(
//               indicatorType: Indicator.ballClipRotateMultiple,
//               colors: [Color.fromARGB(255, 49, 114, 179)],
//               strokeWidth: 4.0,
//             ),
//           ), // Show a loading spinner
//         );
//       },
//       barrierDismissible:
//           false, // Prevent dismissing the dialog by tapping outside
//     );

//     try {
//       await MultiUserTestBooking();

//       // Close the loading spinner
//       Navigator.pop(context);

//       // Close the bottom sheet
//       Navigator.pop(context, true);
//     } catch (error) {
//       print('Error: $error'); // Handle any API call errors

//       // Close the loading spinner
//       Navigator.pop(context);

//       // Close the bottom sheet
//       Navigator.pop(context, false);
//     }
//   }

//   bool isCardClicked = false;
//   return InkWell(
//     onTap: () {
//       if (!isCardClicked) {
//         globals.umr_no = data["UMR_NO"].toString();
//         _uploadMultiuSERBook(context);
//         isCardClicked = true; // Disable further clicks
//       }
//     },
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
//           child: Card(
//             elevation: 3.0,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(16.0))),
//             child: Row(
//               children: [
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Icon(
//                         Icons.account_circle_rounded,
//                         color: Color.fromARGB(255, 49, 114, 179),
//                         size: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
//                       child: Text(
//                         data["DISPLAY_NAME"].toString(),
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 1, 0, 2),
//                       child: Text(
//                         data["UMR_NO"].toString(),
//                         style: TextStyle(fontSize: 14, color: Colors.red[400]),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

UploadError() {
  return Fluttertoast.showToast(
      msg: "Please Upload Prescription",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 235, 103, 93),
      textColor: Colors.white,
      fontSize: 16.0);
}


// Push_Notification(BuildContext context) async {
//       var isLoading = true;

//       Map data = {
//         "BILL_NO": globals.Bill_No,
//         "Authorization": "",
//         "SenderId": "",
//         "Device_Id": "",
//         "body": "",
//         "Tittle": "",
//         "subtitle": "",
//         "Patient_Name": "",
//         "Mobile_no": "",
//         "IOS_ANDROID": "A",
//         "STATUS_FLAG": "B",
//         "APP_NAME": "UrEMR",
//         "firebaseurl": "",
//         "connection": globals.Patient_App_Connection_String
//       };

//       print(data.toString());
//       final response = await http.post(
//           Uri.parse(globals.Global_Patient_Api_URL +
//               '/PatinetMobileApp/PatPushNotifications'),
//           headers: {
//             "Accept": "application/json",
//             "Content-Type": "application/x-www-form-urlencoded",
//           },
//           body: data,
//           encoding: Encoding.getByName("utf-8"));

//       setState(() {
//         isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         Map<String, dynamic> resposne = jsonDecode(response.body);
//       }
//     }




/**--------------clicking--------------------------- */



  // bool isButtonDisabled = false;
  // Future<void> SingleUserPaymentsBooking() async {
  //   if (!isButtonDisabled) {
  //     setState(() {
  //       isButtonDisabled = true; // Disable the button
  //     });

  //     // Call your API here to book the test
  //     SingleUserTestBookings();

  //     // Example delay to simulate API call
  //     Future.delayed(Duration(seconds: 5), () {
  //       // Enable the button again after the delay
  //       setState(() {
  //         isButtonDisabled = false;
  //       });
  //     });
  //   }
  // }
  // Future<void> _uploadSingleuSERBook(BuildContext context) async {
  //   // Show the loading spinner first
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: SizedBox(
  //           height: 100,
  //           width: 100,
  //           child: LoadingIndicator(
  //             indicatorType: Indicator.ballClipRotateMultiple,
  //             colors: [Color.fromARGB(255, 49, 114, 179)],
  //             strokeWidth: 4.0,
  //           ),
  //         ), // Show a loading spinner
  //       );
  //     },
  //     barrierDismissible:
  //         false, // Prevent dismissing the dialog by tapping outside
  //   );

  //   try {
  //     await SingleUserTestBookings();

  //     // Close the loading spinner
  //     Navigator.pop(context);

  //     // Close the bottom sheet
  //     Navigator.pop(context, true);
  //   } catch (error) {
  //     print('Error: $error'); // Handle any API call errors

  //     // Close the loading spinner
  //     Navigator.pop(context);

  //     // Close the bottom sheet
  //     Navigator.pop(context, false);
  //   }
  // }

  // bool isSingleUserClicked = false;