import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:food_delivery/view/more/addresses_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_address_view.dart';
import 'checkout_message_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:food_delivery/view/more/address_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  List paymentArr = [
    {"name": "Cash on delivery", "icon": "assets/img/cash.png"},
    {"name": "**** **** **** 2187", "icon": "assets/img/visa_icon.png"},
    {"name": "test@gmail.com", "icon": "assets/img/paypal.png"},
  ];

  _placeorder(BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://dvp.pythonanywhere.com/placeorder_api'));
    request.body = json.encode({
      {"name": "divy", "phone": "1111222233", "address": 79}
    });
    request.headers.addAll(headers);
    // Assuming $e and $p are defined somewhere in your code
    try {
      print("datacomes1");
      http.StreamedResponse response = await request.send();
      print("Data Sent");
      if (response.statusCode == 200) {
        // var res = await http.Response.fromStream(response);
        // final result = jsonDecode(res.body) as Map<String, dynamic>;
        // print(result);
        // If the request is successful (status code 200),
        // navigate to the login screen
        print("in 200 success");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckoutMessageView()),
        );
        // showModalBottomSheet(
        //     context: context,
        //     backgroundColor: Colors.transparent,
        //     isScrollControlled: true,
        //     builder: (context) {
        //       return const CheckoutMessageView();
        //     });
        setState(() {});
      } else {
        // If the request is unsuccessful, print the status code
        // and navigate to the login screen
        print("User Not Found");
        print("Response Status Code: ${response.statusCode}");
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() {});
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyRegister()),
        // );
      }
    } catch (e) {
      // If an exception occurs during the request, print the error
      print("Error: $e");
    }
  }

  bool isLoading = true;
  List itemArr = [];
  int subtotal = 0;
  int packfees = 0;
  List addressList = [];

  Future<void> fetchCheckoutDetails() async {
    var url = Uri.parse("https://dvp.pythonanywhere.com/checkout_api");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          itemArr.add(value);
        });
        print(itemArr[0]);
        subtotal = itemArr[1];
        packfees = itemArr[3];
        if (itemArr[4] != []) {
          addressList = itemArr[4];
          print("in addresses" + addressList.toString());
          setState(() {});
        }
        itemArr = itemArr[0];
        setState(() {});
        Timer(Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        print("no data found");
      }
    } catch (error) {
      print("error $error");
    }
  }

  int? _selectedValue;
  Map<int, String> addressMap = {};
  String address_str = "";
  _fetchAreas() async {
    final _pref = await SharedPreferences.getInstance();
    int? cusId = _pref.getInt('cusId');
    var url = Uri.parse("https://dvp.pythonanywhere.com/getAddresses/$cusId");
    try {
      var response = await http.get(url);
      String key = "";
      List address = [];
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          key = key;
          // isCatOrPro = value;
          // print("$key" + isCatOrPro.toString());
          // print(value);
          address = value;
          setState(() {});
        });
        addressMap = address.fold({}, (Map<int, String> map, area) {
          map[area['id']] = area['Address_type'].toString();
          return map;
        });

        print(addressMap);
        setState(() {});
      } else {
        print("no data found");
      }
    } catch (error) {
      print("error $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAreas();
    fetchCheckoutDetails();
  }

  int selectMethod = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/img/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Expanded(
                        //   child: Text(
                        //     (addressList.length > 0)
                        //         ? addressList[0]['landmark']
                        //         : "",
                        //     style: TextStyle(
                        //         color: TColor.primaryText,
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.w700),
                        //   ),
                        // ),
                        DropdownButton<int>(
                          value: _selectedValue,
                          onChanged: (int? newValue) {
                            print('Selected value: $newValue');
                            if (newValue != null) {
                              setState(() {
                                _selectedValue = newValue;
                                print(addressMap[newValue]);
                                address_str = addressMap[newValue]!;
                                setState(() {});
                                print(
                                    'Updated selected value: $_selectedValue');
                              });
                            }
                          },
                          items: addressMap.entries.map<DropdownMenuItem<int>>(
                              (MapEntry<int, String> entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressDetailsView()),
                            );
                          },
                          child: Text(
                            "Change",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment method",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add, color: TColor.primary),
                          label: Text(
                            "Add Card",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: paymentArr.length,
                        itemBuilder: (context, index) {
                          var pObj = paymentArr[index] as Map? ?? {};
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                                color: TColor.textfield,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color:
                                        TColor.secondaryText.withOpacity(0.2))),
                            child: Row(
                              children: [
                                Image.asset(pObj["icon"].toString(),
                                    width: 50, height: 20, fit: BoxFit.contain),
                                // const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    pObj["name"],
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectMethod = index;
                                    });
                                  },
                                  child: Icon(
                                    selectMethod == index
                                        ? Icons.radio_button_on
                                        : Icons.radio_button_off,
                                    color: TColor.primary,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "\Rs.$subtotal",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Cost",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "\Rs.50",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Packging Fees",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "+\Rs.20",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "-\Rs.40",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "\Rs.${(subtotal + 20 + 50) - 40}",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: RoundButton(
                    title: "Send Order",
                    onPressed: () async {
                      var headers = {'Content-Type': 'application/json'};
                      var request = http.Request(
                          'POST',
                          Uri.parse(
                              'https://dvp.pythonanywhere.com/placeorder_api'));
                      request.body = json.encode({
                        "name": "divy",
                        "phone": "1111222233",
                        "address": _selectedValue
                      });
                      request.headers.addAll(headers);
                      // Assuming $e and $p are defined somewhere in your code
                      try {
                        print("datacomes1");
                        http.StreamedResponse response = await request.send();
                        print("Data Sent");
                        if (response.statusCode == 200) {
                          print("in 200 success");
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutMessageView()),
                          );
                          setState(() {});
                        } else {
                          // If the request is unsuccessful, print the status code
                          // and navigate to the login screen
                          print("User Not Found");
                          print("Response Status Code: ${response.statusCode}");

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MyRegister()),
                          // );
                        }
                      } catch (e) {
                        // If an exception occurs during the request, print the error
                        print("Error: $e");
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
