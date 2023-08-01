import 'package:flutter/material.dart';
import 'package:asterlabs/Widgets/BottomNavigation.dart';
import './OrdersHistory.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:flutter_charts/flutter_charts.dart';

var dataset = null;
String bar = "";

class MyTrends extends StatefulWidget {
  const MyTrends({Key? key}) : super(key: key);

  @override
  _MyTrendsState createState() => _MyTrendsState();
}

class _MyTrendsState extends State<MyTrends> {
  @override
  Widget build(BuildContext context) {
    Widget _buildPatientIconCard(data, index, context, FLAG) {
      var selectedIndex;
      int _selectedIndex = int.parse(globals.flag_index);

      bool _hasBeenPressed = true;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
            padding: EdgeInsets.all(2),
            child: InkWell(
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  color: _selectedIndex == index
                      ? Color(0xff123456)
                      : Color.fromARGB(192, 221, 194, 193),
                  child: _selectedIndex == index
                      ? Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 3, 1, 0),
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                              ],
                            ),
                            Column(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 8.0, 2.0, 0.0),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      data["DISPLAY_NAME"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 0.0),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      data["UMR_NO"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 3, 1, 0),
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                              ],
                            ),
                            Column(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 8.0, 2.0, 0.0),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      data["DISPLAY_NAME"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 0.0),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      data["UMR_NO"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
              onTap: () {
                globals.selectedIcon = data;
                globals.dis_name = data["DISPLAY_NAME"];
                globals.flag_index = index.toString();
                globals.umr_no = data["UMR_NO"];
                //  dataset = data;
                var datsetvalues = [];
                bar = "";
                datsetvalues = globals.selectedLogin_Data["Data"];
                //setState(() {
                //_updateItems(datsetvalues, index, 0);
                globals.selectedLogin_Data["Data"] = datsetvalues;
                //});
                // array.push(datsetvalues.splice(array.indexOf(element), 1)[0]);
                // datsetvalues.unshift(datsetvalues.splice(index, 0)[0]);
                setState(() {});
              },
            )),
      );
    }

    Future<List<ManagerDetails>> _fetchManagerDetails() async {
      Map data = {
        "patient_id": globals.umr_no,
        "session_id": "1",
        "connection": globals.Patient_App_Connection_String,
      };
      final jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
          '/PatinetMobileApp/PatientWiseServices');
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
            .map((managers) => ManagerDetails.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    ListView PatientIconListView(var data, BuildContext contex, String FLAG) {
      var myData = data["Data"].length;
      //jsonEncode(data, toEncodable: (e) => e.toJsonAttr());
      //Object.entries(data);

      //final c = json.decode(data).toString();

      return ListView.builder(
          itemCount: myData,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            // return  Text(myData[index]["Frequency"].toString());
            return _buildPatientIconCard(
                data["Data"][index], index, context, FLAG);
          });
    }

    Widget MyTrendsDetails = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<ManagerDetails>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();

                  //
                } else {
                  return SizedBox(
                      height: 500, child: MyTrendsListView(data, context));
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));
//....................................................... THIS IS FOR ICONS
    Widget MyTrendsIconDetails = Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<ManagerDetails>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  // if (dataset != null) {
                  //  globals.selectedLogin_Data.insert(0, dataset.toString());
                  //}
                  return PatientIconListView(
                      globals.selectedLogin_Data, context, "INC");

                  // NoContent();
                } else {
                  // if (dataset != null) {
                  //   globals.selectedLogin_Data.insert(0, dataset.toString());
                  // }
                  return PatientIconListView(
                      globals.selectedLogin_Data, context, "INC");
                }
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));
//..............................................
    final title = 'Horizontal List';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 7, 185, 141),
        toolbarHeight: 140,
        leadingWidth: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'My Trends',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                      (bar == "y")
                          ? IconButton(
                              onPressed: () {
                                bar = "x";
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.line_axis,
                                color: Colors.white,
                              ))
                          : IconButton(
                              onPressed: () {
                                bar = "y";
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.bar_chart,
                                color: Colors.white,
                              )),
                      Spacer(),
                      SizedBox(
                        height: 18.0,
                        width: 18.0,
                        child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OredersHistory()));
                            },
                            icon: Icon(
                              Icons.history,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 3,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 0.0),
                    child: Row(
                      children: [
                        Text(
                          'Family Members',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60, child: MyTrendsIconDetails),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 70, child: MyTrendsIconDetails),
            SizedBox(
                // height: 590,
                height: MediaQuery.of(context).size.height * 0.74,
                child: MyTrendsDetails),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
      bottomNavigationBar: AllBottOMNaviGAtionBar(),
    );
  }
}

//.................................................API Related Code.......................
class ManagerDetails {
  final variable_result_value;
  final variable_parameter_name;
  final variable_result_dt;
  final variable_service_name;
  ManagerDetails({
    required this.variable_result_value,
    required this.variable_parameter_name,
    required this.variable_result_dt,
    required this.variable_service_name,
  });
  factory ManagerDetails.fromJson(Map<String, dynamic> json) {
    return ManagerDetails(
      variable_result_value: json['RESULT_VALUE'].toString(),
      variable_parameter_name: json['PARAMETER_NAME'].toString(),
      variable_result_dt: json['RESULT_DT'].toString(),
      variable_service_name: json['SERVICE_NAME'].toString(),
    );
  }
}

class NoContent3 extends StatelessWidget {
  const NoContent3();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Color(0xff123456),
              size: 50,
            ),
            const Text('No Data Found'),
          ],
        ),
      ),
    );
  }
}

ListView MyTrendsListView(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildMyTrends(data[index], context, index);
      });
}

Widget _buildMyTrends(var data, BuildContext context, index) {
  const cutOffYValue = 0.0;
  const yearTextStyle = TextStyle(fontSize: 12, color: Colors.black);

  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.grey[300],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   data.variable_parameter_name,
            //   style: TextStyle(color: Colors.black),
            // ),
            Text(
              data.variable_parameter_name,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.only(bottom: 15.0),
                width: 320,
                height: 200,
                // child: (data.variable_result_value.split(',').length == 1)
                //     ? chartToRunBar(data, context, index)
                //     : chartToRun(data, context, index)),
                child: (bar == "y")
                    ? chartToRunBar1(data, context, index)
                    : chartToRun(data, context, index)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMyTrends1(var data, BuildContext context, index) {
  const cutOffYValue = 0.0;
  const yearTextStyle = TextStyle(fontSize: 12, color: Colors.black);

  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.grey[300],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   data.variable_parameter_name,
            //   style: TextStyle(color: Colors.black),
            // ),
            Text(
              data.variable_parameter_name,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 15.0),
              width: 320,
              height: 200,
              // child: (data.variable_result_value.split(',').length == 1)
              //     ? chartToRunBar(data, context, index)
              //     : chartToRun(data, context, index)),
              child: chartToRunBar1(data, context, index),
              // child: chartToRun(data, context, index)
            ),
          ],
        ),
      ),
    ),
  );
}

// List<FlSpot> gatherWeightData(data) {
//   //data.sort(sort_by('price', true, parseInt));
//   List<FlSpot> spotWeightList = [];
//   List<FlSpot> removedSpotWeightList = [];
//   if (data.variable_result_dt.split(',').length > 1) {
//     for (int i = 0; i < data.variable_result_dt.split(',').length; i++) {
//       spotWeightList.add(FlSpot(
//           (double.parse(data.variable_result_dt.split(',')[i].toString())),
//           double.parse(data.variable_result_value.split(',')[i].toString())));
//       /* if (spotWeightList.length >= 19) {
//       spotWeightList.removeAt(0);
//       removedSpotWeightList = spotWeightList;
//       return removedSpotWeightList;
//     }*/
//     }
//   } else {
//     spotWeightList.add(FlSpot(
//         (double.parse(data.variable_result_dt.toString())),
//         double.parse(data.variable_result_value.toString())));
//   }
//   return spotWeightList;
// }

//..........................................................................................................................
Widget chartToRun(var data, BuildContext context, index) {
  List<double> listdata = [];
  List<String> xvales = [];

  if (data.variable_result_value.split(',').length > 1) {
    for (int i = 0;
        i <= data.variable_result_value.split(',').length - 1;
        i++) {
      //listdata.add(new ListTile());

      listdata.add(double.parse(data.variable_result_value.split(',')[i]));
      xvales.add(data.variable_result_dt.split(',')[i]);
      // listdata
      //     .add(double.parse(data.variable_result_value.split(',')[i].toString()));
    }
  } else {
    //chartToRunbAR(data, context, index);
    //chartToRunBar();
    listdata.add(double.parse(data.variable_result_value.toString()));
    xvales.add(data.variable_result_dt);
  }
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();
  // Example shows how to create ChartOptions instance
  //   which will request to start Y axis at data minimum.
  // Even though startYAxisAtDataMinRequested is set to true, this will not be granted on bar chart,
  //   as it does not make sense there.
  chartOptions = const ChartOptions(
    dataContainerOptions:
        DataContainerOptions(startYAxisAtDataMinRequested: false),
  );

  chartData = ChartData(
    dataRows: [listdata],
    xUserLabels: xvales,
    dataRowsColors: [Colors.green],
    dataRowsLegends: const [''],
    chartOptions: chartOptions,
  );
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );
  return lineChart;
}

//......................................................................................................................
//Widget chartToRunbAR(var data, BuildContext context, index) {
Widget chartToRunBar(var data, context, index) {
  List<double> listdata = [];
  List<String> xvales = [];
  listdata.add(double.parse(data.variable_result_value)..floorToDouble());
  xvales.add(data.variable_result_dt);
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();
  // Example shows an explicit use of the DefaultIterativeLabelLayoutStrategy.
  // The xContainerLabelLayoutStrategy, if set to null or not set at all,
  //   defaults to DefaultIterativeLabelLayoutStrategy
  // Clients can also create their own LayoutStrategy.
  xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
    options: chartOptions,
  );

  chartData = ChartData(
    dataRows: [listdata],
    xUserLabels: xvales,
    dataRowsLegends: [''],
    chartOptions: chartOptions,
  );
  // chartData.dataRowsDefaultColors(); // if not set, called in constructor
  var verticalBarChartContainer = VerticalBarChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var verticalBarChart = VerticalBarChart(
    painter: VerticalBarChartPainter(
      verticalBarChartContainer: verticalBarChartContainer,
    ),
  );
  return verticalBarChart;
}

//.............................................................................................................................
Widget chartToRunBar1(var data, context, index) {
  List<double> listdata = [];
  List<String> xvales = [];

  if (data.variable_result_value.split(',').length > 1) {
    for (int i = 0;
        i <= data.variable_result_value.split(',').length - 1;
        i++) {
      //listdata.add(new ListTile());

      listdata.add(double.parse(data.variable_result_value.split(',')[i])
          .floorToDouble());
      xvales.add(data.variable_result_dt.split(',')[i]);
      // listdata
      //     .add(double.parse(data.variable_result_value.split(',')[i].toString()));
    }
  } else {
    //chartToRunbAR(data, context, index);
    //chartToRunBar();
    listdata.add(double.parse(data.variable_result_value.toString()));
    xvales.add(data.variable_result_dt);
  }
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;

  ChartOptions chartOptions = const ChartOptions();
  // Example shows an explicit use of the DefaultIterativeLabelLayoutStrategy.
  // The xContainerLabelLayoutStrategy, if set to null or not set at all,
  //   defaults to DefaultIterativeLabelLayoutStrategy
  // Clients can also create their own LayoutStrategy.
  xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
    options: chartOptions,
  );

  chartData = ChartData(
    xUserLabels: xvales,
    dataRowsColors: [Color.fromARGB(184, 147, 169, 241)],
    dataRows: [listdata],
    dataRowsLegends: [''],
    chartOptions: chartOptions,
  );
  // chartData.dataRowsDefaultColors(); // if not set, called in constructor
  var verticalBarChartContainer = VerticalBarChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var verticalBarChart = VerticalBarChart(
    painter: VerticalBarChartPainter(
      verticalBarChartContainer: verticalBarChartContainer,
    ),
  );
  return verticalBarChart;
}

//............................................................Icon

moveArrayItemToNewIndex(arr, old_index, new_index) {
  if (new_index >= arr.length) {
    var k = new_index - arr.length + 1;
    while (k--) {
      arr.push("undefined");
    }
  }
  arr.splice(new_index, 0, arr.splice(old_index, 1)[0]);
  return arr;
}

class NoContent extends StatelessWidget {
  const NoContent();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Color(0xff123456),
              size: 40,
            ),
            const Text('No Data Found'),
          ],
        ),
      ),
    );
  }
}

_updateItems(var data, int oldIndex, int newIndex) {
  if (newIndex > oldIndex) {
    newIndex -= 1;
  }

  final item = data.removeAt(oldIndex);
  data.insert(newIndex, item);
  return data;
}
