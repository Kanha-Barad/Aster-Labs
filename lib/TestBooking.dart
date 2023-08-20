import 'dart:convert';

import 'package:asterlabs/Widgets/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'TestCartItemsAdded.dart';
import 'CartModel.dart';
import 'Cartprovider.dart';
import 'Widgets/BookTestDrawer.dart';
import 'Widgets/Test_Search.dart';
import 'globals.dart' as globals;
import 'dart:math' as math;

TextEditingController searchController = TextEditingController();
String LOCATION_ID = "";
String searchQuery = '';

class bookATeSt extends StatefulWidget {
  bookATeSt(LoCID) {
    LOCATION_ID = "";
    LOCATION_ID = LoCID;
  }
  @override
  State<bookATeSt> createState() => _bookATeStState();
}

class _bookATeStState extends State<bookATeSt> {
  // final List<CartItem> items = []

  Future<List<CartItem>> fetchData() async {
    Map<String, String> data = {
      'IP_LOCATION_ID': LOCATION_ID, //38,45
      'IP_SESSION_ID': '1',
      'connection': globals.Patient_App_Connection_String
      //'Server=172.24.248.12;User id=ALUATDB.SVCA;Password=DSFg45THFD;Database=P_ASTER_LIMS_UAT_2023'
    };

    final response = await http.post(
      Uri.parse(
          globals.Global_Patient_Api_URL + 'PatinetMobileApp/PreferedServices'),
      //'https://asterlabs.asterdmhealthcare.com/MOBILEAPPAPI/PatinetMobileApp/PreferedServices'
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> responseItems = responseBody["Data"];
      List<CartItem> items = responseItems.map((item) {
        Map<String, dynamic> itemMap = item as Map<String, dynamic>;
        return CartItem(
          id: itemMap['SERVICE_ID'],
          name: itemMap['SERVICE_NAME'],
          price: itemMap['PRICE'].toDouble(),
        );
      }).toList();
      // List<CartItem> items =
      //     (json.decode(response.body)["Data"] as List).map((item) {
      //   return CartItem(
      //     id: item['SERVICE_GROUP_ID'],
      //     name: item['SERVICE_NAME'],
      //     price: item['PRICE'].toDouble(),
      //   );
      // }).toList();

      return items;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 7, 185, 141),
          title: Text('Test Enquiry', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              onPressed: () {
                searchQuery = '';
                searchController.clear();
                // Trigger a UI update by rebuilding the widget tree
                //context.read<CartProvider>().notifyListeners();
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back)), // Your image widget
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Image.asset("assets/images/asterlabs.png"),
                onPressed: () {
                  // onMenuIconTap();
                  Scaffold.of(context).openEndDrawer(); // Open the end drawer
                },
              ),
            ),
          ],
        ),
        endDrawer: AppDrawer(),
        body: FutureBuilder<List<CartItem>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
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
              );
            } else if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return Center(
                child: Text('Error loading data'),
              );
            } else {
              final items = snapshot.data ?? [];

              return Column(
                children: [
                  TextFieldSearch(
                    textEditingController: searchController,
                    isPrefixIconVisible: true,
                    onChanged: (value) {
                      // Update the search query when the user types
                      searchQuery = value;
                      // Trigger a UI update by rebuilding the widget tree
                      context.read<CartProvider>().notifyListeners();
                    },
                    callBackPrefix: () {},
                    callBackSearch: () {},
                    callBackClear: () {
                      // Clear the search query when the "Clear" button is pressed
                      searchQuery = '';
                      searchController.clear();
                      // Trigger a UI update by rebuilding the widget tree
                      context.read<CartProvider>().notifyListeners();
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        if (searchQuery.isNotEmpty &&
                            !items[index]
                                .name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase())) {
                          return SizedBox(); // Skip rendering this item
                        }
                        var cartProvider = Provider.of<CartProvider>(context);
                        var isSelected =
                            cartProvider.cartItems.contains(items[index]);

                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Adjust the radius as needed
                                side: BorderSide(
                                    color: Color.fromARGB(255, 231, 231, 231))),
                            margin: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 10, 4),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 4, 0),
                                        child: Transform.rotate(
                                            angle: -180 * math.pi / 180,
                                            child: Icon(
                                              Icons.filter_alt_outlined,
                                              color: Color.fromARGB(
                                                  255, 49, 114, 179),
                                            )),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 4, right: 6),
                                          child: Text(
                                            items[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.4,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(42, 1, 4, 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        '\u{20B9} ' +
                                            '${items[index].price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.deepOrange),
                                      ),
                                      Spacer(),
                                      ToggleButtons(
                                        renderBorder: false,
                                        color: Colors.white,
                                        borderWidth: 0,
                                        borderColor: Colors.white,
                                        isSelected: [isSelected],
                                        children: [
                                          if (!isSelected)
                                            InkWell(
                                                onTap: () {
                                                  cartProvider
                                                      .addToCart(items[index]);
                                                },
                                                child: SizedBox(
                                                  height: 36,
                                                  width: 69,
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        255, 26, 177, 122),
                                                    elevation: 1,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Add',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                          else
                                            InkWell(
                                                onTap: () {
                                                  cartProvider.removeFromCart(
                                                      items[index]);
                                                },
                                                child: SizedBox(
                                                  height: 36,
                                                  width: 69,
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        247, 216, 109, 102),
                                                    elevation: 1,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
        bottomSheet: CartBottomBar(),
        bottomNavigationBar: AllBottOMNaviGAtionBar(),
      ),
    );
  }
}

class CartBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context).cartItems;
    double total = cartItems.fold(0, (sum, item) => sum + item.price);

    return GestureDetector(
      onTap: () {
        // Navigate to cart page or show a modal bottom sheet with cart items
        cartItems.length != 0
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(LOCATION_ID)),
              )
            : null;
        searchQuery = '';
        searchController.clear();
        // Trigger a UI update by rebuilding the widget tree
       // context.read<CartProvider>().notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color.fromARGB(255, 49, 114, 179),
          // margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total Items :  ${cartItems.length}",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),

                Text(
                  '\u{20B9} ' + '$total',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
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
    );
  }
}
