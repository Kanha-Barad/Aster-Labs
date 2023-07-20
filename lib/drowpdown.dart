import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State {
  // Default Drop Down Item.
  String dropdownValue = 'Tom Cruise';

  // To show Selected Item in Text.
  String holder = '';

  List<String> actorsName = [
    'Robert Downey, Jr.',
    'Tom Cruise',
    'Leonardo DiCaprio',
    'Will Smith',
    'Tom Hanks'
  ];

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: Column(children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.red, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (data) {
                setState(() {
                  dropdownValue = data.toString();
                });
              },
              items: actorsName.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child:
                    //Printing Item on Text Widget
                    Text('Selected Item = ' + '$holder',
                        style: TextStyle(fontSize: 22, color: Colors.black))),
            TextButton(
              child: Text('Click Here To Get Selected Item From Drop Down'),
              onPressed: getDropDownItem,
            ),
          ]),
        ),
      ),
    );
  }
}
