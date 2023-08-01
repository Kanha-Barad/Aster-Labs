import 'package:flutter/material.dart';
import 'package:asterlabs/PatientHome.dart';
import 'package:asterlabs/Widgets/BottomNavigation.dart';

String Bill_NUMber = "";
String BIlling_DATe = "";

class ThankYouScreenOFUploadPrescripTIOn extends StatefulWidget {
  ThankYouScreenOFUploadPrescripTIOn(billno, Billdate) {
    Bill_NUMber = "";
    Bill_NUMber = billno;
    BIlling_DATe = "";
    BIlling_DATe = Billdate;
  }

  @override
  State<ThankYouScreenOFUploadPrescripTIOn> createState() =>
      _ThankYouScreenOFUploadPrescripTIOnState();
}

class _ThankYouScreenOFUploadPrescripTIOnState
    extends State<ThankYouScreenOFUploadPrescripTIOn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => PatientHome())));
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          'Prescription Orders',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 5),
            child: Icon(
              Icons.thumb_up_outlined,
              size: 65,
              color: Color.fromARGB(255, 21, 29, 118),
            ),
          ),
          Text(
            'Thank you ! Your Request has been taken.\nOur Customer care will connect and confirm the test mentioned in your prescription for booking.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 21, 29, 118),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 70, 10, 4),
            child: Row(
              children: [Text('Order Number'), Spacer(), Text(Bill_NUMber)],
            ),
          ),
          const Divider(
            thickness: 1.8,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 4),
            child: Row(
              children: [
                Text('Appointment Date'),
                Spacer(),
                Text(BIlling_DATe)
              ],
            ),
          ),
          const Divider(
            thickness: 1.8,
            indent: 10,
            endIndent: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(12, 10, 10, 4),
          //   child: Row(
          //     children: const [
          //       Text('Enquiry Address'),
          //       Spacer(),
          //       SizedBox(
          //           width: 140,
          //           child:
          //               Text('17, Vadsarvala Nivas Mulund West, Mumbai 400054'))
          //     ],
          //   ),
          // ),
          // const Divider(
          //   thickness: 1.8,
          //   indent: 10,
          //   endIndent: 10,
          // ),
        ],
      )),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}
