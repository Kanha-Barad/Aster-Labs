import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './PatientHome.dart';
import './ClientCodeLogin.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  // Handle the notification permission response
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // User granted permission to display notifications
    print('Notification permission granted');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    // User granted provisional permission to display notifications (iOS 15+)
    print('Provisional notification permission granted');
  } else {
    // User denied permission to display notifications
    print('Notification permission denied');
  }

  runApp(PatientApp());
}

class PatientApp extends StatefulWidget {
  const PatientApp({Key? key}) : super(key: key);
  @override
  State<PatientApp> createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging.instance.getToken().then((value) {
    // //  Device_token_ID = value.toString();
    //   print(value);
    // });
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          accentColor: Color(0xff123456),
        ),
        home: PatientHome());
  }
}