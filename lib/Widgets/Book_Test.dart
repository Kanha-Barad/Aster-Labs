import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/cart_controller.dart';
import '../Controllers/product_controller.dart';

import 'Test_Search.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;
import 'dart:math' as math;

import '../Screens/Test_Cart_screen.dart';

class ProductsGrid extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        children: [
          TextFieldSearch(
            textEditingController: controller.searchController,
            isPrefixIconVisible: true,
            onChanged: controller.productNameSearch,
            callBackPrefix: () {},
            callBackSearch: () {},
            callBackClear: () {},
          ),
          Expanded(
            child: Obx(() => ListView(
                  shrinkWrap: true,
                  children: [
                    ...controller.productList
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 1.0, 10, 1.0),
                              child: InkWell(
                                onTap: () {
                                  globals.PackageTestInformation = e;
                                  (e.Service_Type_Id == 2)
                                      ? _showPickerBookTest(context)
                                      : (e.Service_Type_Id == 7)
                                          ? _showPickerDiagnProfilesHlthpackages(
                                              context)
                                          : null;
                                },
                                child: Card(
                                    color: Color.fromARGB(209, 251, 253, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 2.5,
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(children: [
                                          Row(children: [
                                            //  CircleAvatar(radius: 25),
                                            SizedBox(width: 7),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: Transform.rotate(
                                                            angle: -180 *
                                                                math.pi /
                                                                180,
                                                            child: Icon(Icons
                                                                .filter_alt)),
                                                      ),
                                                      SizedBox(
                                                        width: 250,
                                                        child: Text(e.title,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        25, 0.0, 0.0, 0.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            'Rs.' +
                                                                "\u{20B9} " +
                                                                "${e.price}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .deepOrange)),
                                                        Spacer(),
                                                        InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          onTap: () {
                                                            final filteredProductIndex =
                                                                controller
                                                                    .productList
                                                                    .indexOf(e);

                                                            if (filteredProductIndex >=
                                                                0) {
                                                              final product = controller
                                                                      .productList[
                                                                  filteredProductIndex];
                                                              controller
                                                                  .toggleAddRemove(
                                                                      filteredProductIndex);

                                                              print(e.id);
                                                              print(product
                                                                  .isAdded
                                                                  .value);
                                                              if (product
                                                                  .isAdded
                                                                  .value) {
                                                                cartController
                                                                    .addItem(
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .id,
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .price,
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .title,
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .Service_Id,
                                                                  1,
                                                                );
                                                              } else {
                                                                cartController
                                                                    .removeitem(
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .Service_Id,
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .price,
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .title,
                                                                  controller
                                                                      .productList[
                                                                          filteredProductIndex]
                                                                      .id,
                                                                  1,
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: Center(
                                                            child: Obx(() {
                                                              final filteredProductIndex =
                                                                  controller
                                                                      .productList
                                                                      .indexOf(
                                                                          e);
                                                              final isAdded = filteredProductIndex >=
                                                                      0 &&
                                                                  controller
                                                                      .addedProductIds
                                                                      .contains(controller
                                                                          .productList[
                                                                              filteredProductIndex]
                                                                          .id);

                                                              return SizedBox(
                                                                height: 36,
                                                                width: 69,
                                                                child: Card(
                                                                  color: isAdded
                                                                      ? Color.fromARGB(
                                                                          247,
                                                                          216,
                                                                          109,
                                                                          102)
                                                                      : Color.fromARGB(
                                                                          255,
                                                                          26,
                                                                          177,
                                                                          122),
                                                                  elevation: 1,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      isAdded
                                                                          ? 'Remove'
                                                                          : 'Add',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ])),
                                          ]),
                                        ]))),
                              ),
                            ))
                        .toList()
                  ],
                )),
          ),
          InkWell(
              onTap: () {
                cartController.itemCount != 0
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()))
                    : null;
              },
              child: GetBuilder<CartController>(
                  init: CartController(),
                  builder: (cont) => SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color.fromARGB(255, 49, 114, 179),
                            // margin: EdgeInsets.all(15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Total Items :  ${cartController.itemCount}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),

                                  Text(
                                    '\u{20B9} ' +
                                        ' ${cartController.totalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  //  backgroundColor: Theme.of(context).primaryColor,

                                  Text(
                                    'View Cart',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))),
        ],
      );
    });
  }
}

/*---------------------------------BookedStatus--------------------------------------- */

class BookedStats extends StatefulWidget {
  const BookedStats({Key? key}) : super(key: key);

  @override
  State<BookedStats> createState() => _BookedStatsState();
}

class _BookedStatsState extends State<BookedStats> {
  @override
  Widget build(BuildContext context) {
    Future<List<Bookedstatusclass>> _fetchManagerDetails() async {
      Map data = {
        "Service_Id": globals.PackageTestInformation.Service_Id.toString(),
        "Gender_Id": "1",
        "connection": globals.Patient_App_Connection_String
      };
      final jobsListAPIUrl = Uri.parse(globals.Global_Patient_Api_URL +
          '/PatinetMobileApp/Servicewiseparameters');
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
            .map((managers) => Bookedstatusclass.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget BookStatusDetails = FutureBuilder<List<Bookedstatusclass>>(
        future: _fetchManagerDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty == true) {
              return NoContent();
            }
            var data = snapshot.data;
            return SizedBox(child: BookStatusListView(data, context, 'BS'));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
              child: const CircularProgressIndicator(
            strokeWidth: 4.0,
          ));
        });
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff123456),
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 15,
            ),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              globals.PackageTestInformation.title,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ])),
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: BookStatusDetails),
    );
  }
}

Widget NoContent() {
  return GestureDetector();
}

ListView BookStatusListView(data, BuildContext context, String flg) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return _BookStatusDetails(data[index], context, flg, index);
    },
  );
}

Widget _BookStatusDetails(var data, BuildContext context, flg, int index) {
  return GestureDetector(
    child: (flg == "BS")
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (index == 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 18.0, 0.0, 5.0),
                          child: Text(
                            'Parameter Count',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    )
                  : Container(child: null),
              (index == 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6.0, 0.0, 10.0),
                      child: Text(data.assy_cnt),
                    )
                  : Container(child: null),
              (index == 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 9.0, 0.0, 5.0),
                          child: Text(
                            'Parameter Included',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    )
                  : Container(child: null),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6.0, 0.0, 6.0),
                child: Text(data.compnt_name),
              ),
              (int.parse(index.toString()) ==
                      int.parse(data.assy_cnt.toString()) - 1)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 13.0, 0.0, 5.0),
                          child: Text(
                            'Why To Get?',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    )
                  : Container(child: null),
              (int.parse(index.toString()) ==
                      int.parse(data.assy_cnt.toString()) - 1)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6.0, 0.0, 6.0),
                      child: Text(data.why_to_get),
                    )
                  : Container(child: null),
              (int.parse(index.toString()) ==
                      int.parse(data.assy_cnt.toString()) - 1)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 13.0, 0.0, 5.0),
                          child: Text(
                            'When To Get?',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    )
                  : Container(child: null),
              (int.parse(index.toString()) ==
                      int.parse(data.assy_cnt.toString()) - 1)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6.0, 0.0, 6.0),
                      child: Text(data.when_to_get),
                    )
                  : Container(child: null),
              (int.parse(index.toString()) ==
                      int.parse(data.assy_cnt.toString()) - 1)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 13.0, 0.0, 5.0),
                          child: Text(
                            'FAQ',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    )
                  : Container(child: null),
              (int.parse(index.toString()) ==
                      int.parse(data.assy_cnt.toString()) - 1)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6.0, 0.0, 40),
                      child: Text(data.faq),
                    )
                  : Container(child: null),
            ],
          )
        : Container(),
  );
}

class Bookedstatusclass {
  final assy_cnt;
  final assy_frmt_name;
  final assy_frmt_cd;
  final compnt_id;
  final compnt_name;
  final cmpnt_cd;
  final assy_srvc_name;
  final why_to_get;
  final when_to_get;
  final faq;
  Bookedstatusclass({
    required this.assy_cnt,
    required this.assy_frmt_name,
    required this.assy_frmt_cd,
    required this.compnt_id,
    required this.compnt_name,
    required this.cmpnt_cd,
    required this.assy_srvc_name,
    required this.why_to_get,
    required this.when_to_get,
    required this.faq,
  });
  factory Bookedstatusclass.fromJson(Map<String, dynamic> json) {
    return Bookedstatusclass(
      assy_cnt: json['CNT'].toString(),
      assy_frmt_name: json['ASSAY_FORMAT_NAME'].toString(),
      assy_frmt_cd: json['ASSAY_FORMAT_CD'].toString(),
      compnt_id: json['COMPONENT_ID'].toString(),
      compnt_name: json['COMPONENT_NAME'].toString(),
      cmpnt_cd: json['COMPONENT_CD'].toString(),
      assy_srvc_name: json['SERVICE_NAME'].toString(),
      why_to_get: json['WHY_TO_GET'].toString(),
      when_to_get: json['WHEN_TO_GET'].toString(),
      faq: json['FAQ'].toString(),
    );
  }
}

void _showPickerBookTest(BuildContext context) {
  var res = showModalBottomSheet(
    context: context,
    builder: (_) => Container(
      //  width: ,
      height: MediaQuery.of(context).size.height * 0.75,
      //  color: Color(0xff123456),
      child: BookedStats(),
    ),
  );
  print(res);
}

/*---------------------------------BookedStatus--------------------------------------- */

/*---------------------------------------Diagnostic and health package------------------------------------- */

class DiagnProfilesHlthpackages extends StatefulWidget {
  const DiagnProfilesHlthpackages({Key? key}) : super(key: key);

  @override
  State<DiagnProfilesHlthpackages> createState() =>
      _DiagnProfilesHlthpackagesState();
}

class _DiagnProfilesHlthpackagesState extends State<DiagnProfilesHlthpackages> {
  @override
  Widget build(BuildContext context) {
    Future<List<hlthPackageDiagnoPackage>> _fetchManagerDetails() async {
      Map data = {
        "package_id": globals.PackageTestInformation.Service_Id.toString(),
        "connection": globals.Patient_App_Connection_String
        //"Server_Flag":""
      };
      final jobsListAPIUrl = Uri.parse(
          globals.Global_Patient_Api_URL + '/PatinetMobileApp/ServiceIncludes');
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
            .map((managers) => hlthPackageDiagnoPackage.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget HlthDiagnopackageDetails = Container(
        child: FutureBuilder<List<hlthPackageDiagnoPackage>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return HlthDiagnopackageListView(data, context, 'HPSP');
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(
                  child: const CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            }));
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 15,
            ),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
          title: Row(
            children: [
              SizedBox(
                //   width: 270,
                child: Text(
                  globals.PackageTestInformation.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xff123456),
          automaticallyImplyLeading: false),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(globals.PackageTestInformation.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                      '  \u{20B9} ' + "${globals.PackageTestInformation.price}",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
                child: HlthDiagnopackageDetails)
          ],
        ),
      ),
    );
  }
}

ListView HlthDiagnopackageListView(data, BuildContext context, String flg) {
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      return
          //   height: MediaQuery.of(context).size.height * 0.2,
          _HlthDiagnopackageDetails(data[index], context, flg);
    },
    scrollDirection: Axis.horizontal,
  );
}

Widget _HlthDiagnopackageDetails(var data, BuildContext context, flg) {
  return GestureDetector(
      onTap: () {},
      child: (flg == "HPSP")
          ? SizedBox(
              height: 45,
              width: 160,
              child: Card(
                color: Colors.indigo,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 142,
                      child: Center(
                        child: Text(
                          data.servc_name,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Card());
}

class hlthPackageDiagnoPackage {
  final servic_id;
  final packg_name;
  final servc_name;
  final servc_grp;
  hlthPackageDiagnoPackage(
      {required this.servic_id,
      required this.packg_name,
      required this.servc_name,
      required this.servc_grp});
  factory hlthPackageDiagnoPackage.fromJson(Map<String, dynamic> json) {
    return hlthPackageDiagnoPackage(
        servic_id: json['SERVICE_ID'].toString(),
        packg_name: json['PKG_NAME'].toString(),
        servc_name: json['SERVIE_NAME'],
        servc_grp: json['SERVICE_GROUP'].toString());
  }
}

void _showPickerDiagnProfilesHlthpackages(BuildContext context) {
  var res = showModalBottomSheet(
    context: context,
    builder: (_) => Container(
      //  width: ,
      height: MediaQuery.of(context).size.height * 0.35,
      //  color: Color(0xff123456),
      child: DiagnProfilesHlthpackages(),
    ),
  );
  print(res);
}

/*---------------------------------------Diagnostic and health package------------------------------------- */


// ProductController().isLoading.value
              // ?
              // Center(
              //     child: SpinKitChasingDots(
              //         color: Colors.deepPurple[600], size: 40),
              //   )
              // final ProductController controller = Get.find<ProductController>();

              //  SizedBox(
              //           height: 100,
              //           width: 100,
              //           child: Center(
              //             child: LoadingIndicator(
              //               indicatorType: Indicator.ballClipRotateMultiple,
              //               colors: Colors.primaries,
              //               strokeWidth: 4.0,
              //             ),
              //           ),
              //         )
              //       :


//--------------------------add remove code ------------------------------
              //      InkWell(
//   borderRadius: BorderRadius.circular(15.0),
//   onTap: () {
//     final filteredProductIndex = controller.productList.indexOf(e);

//     if (filteredProductIndex >= 0) {
//       final product = controller.productList[filteredProductIndex];

//       if (!product.isAdded.value) {
//         cartController.addItem(
//           product.id,
//           product.price,
//           product.title,
//           product.Service_Id,
//           1,
//         );
//       } else {
//         cartController.removeitem(
//           product.Service_Id,
//           product.price,
//           product.title,
//           product.id,
//           1,
//         );
//       }
//     }
//   },
//   child: Center(
//     child: Obx(() {
//       final filteredProductIndex = controller.productList.indexOf(e);
//       final isAdded = filteredProductIndex >= 0 && controller.addedProductIds.contains(controller.productList[filteredProductIndex].id);

//       return SizedBox(
//         height: 36,
//         width: 69,
//         child: Card(
//           color: isAdded ? Color.fromARGB(247, 216, 109, 102) : Color.fromARGB(255, 26, 177, 122),
//           elevation: 1,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Center(
//             child: Text(
//               isAdded ? 'Remove' : 'Add',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       );
//     }),
//   ),
// ),