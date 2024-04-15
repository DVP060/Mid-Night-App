import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:food_delivery/view/more/add_card_view.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:shimmer/shimmer.dart';

import '../../common_widget/round_button.dart';
import 'my_order_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class OrderDetailsView extends StatefulWidget {
  int orderid = 0;
  OrderDetailsView({super.key, required this.orderid});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  List loadArr = [
    {"name": "food name", "quantity": "0", "total_price": 0},
    {"name": "food name", "quantity": "0", "total_price": 0},
    {"name": "food name", "quantity": "0", "total_price": 0}
  ];
  List foodDetailsArr = [];
  Map customerDetails = {};
  String orderStatus = "";
  String orderDate = "";
  bool isCancel = false;
  String payment_type = "";
  bool payment_status = true;
  int amount = 0;
  String address = "";
  bool isLoading = true;
  Map data = {};
  Future<void> fetchOrderDetails() async {
    var url = Uri.parse(
        "https://dvp.pythonanywhere.com/orderdetails_api/${widget.orderid}");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        print(result);
        data = result;
        setState(() {});
        foodDetailsArr = data['food_item'];
        isCancel = data['iscancel'];
        payment_status = data['payment_status'];
        payment_type = data['payment_type'];
        amount = data['amount'];
        address = data['address'];
        orderStatus = data['order_status'];
        customerDetails = data['customer_details'];
        Timer(Duration(seconds: 2), () {
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

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Order Details",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const MyOrderView()));
                    //   },
                    //   icon: Image.asset(
                    //     "assets/img/shopping_cart.png",
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  "Products Details",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                  decoration: BoxDecoration(color: TColor.textfield),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: foodDetailsArr.length,
                    separatorBuilder: ((context, index) => Divider(
                          indent: 25,
                          endIndent: 25,
                          color: TColor.secondaryText.withOpacity(0.5),
                          height: 1,
                        )),
                    itemBuilder: (isLoading == true)
                        ? ((context, index) {
                            var cObj = loadArr[index] as Map? ?? {};
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${cObj["name"].toString()} x${cObj["quantity"].toString()}",
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "\Rs.${cObj["total_price"].toString()}",
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                        : ((context, index) {
                            var cObj = foodDetailsArr[index] as Map? ?? {};
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${cObj["name"].toString()} x${cObj["quantity"].toString()}",
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "\Rs.${cObj["total_price"].toString()}",
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            );
                          }),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  color: TColor.secondaryText.withOpacity(0.4),
                  height: 1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: TColor.textfield,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 9))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Status",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          (payment_status == true)
                              ? Image.asset(
                                  "assets/img/check.png",
                                  width: 20,
                                  height: 20,
                                )
                              : Icon(Icons.close)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Text(
                        "Customer Details",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Customer Name",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          (customerDetails.isNotEmpty)
                              ? Text("${customerDetails['name'].toString()}")
                              : Text("Undefined")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Text(
                        "Price Details",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Grand Total",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          (amount != 0)
                              ? Text("Rs.${amount.toString()}")
                              : Text("Undefined")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  "Delivery Location Details",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Address",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    (address != "") ? Text("$address") : Text("Undefined")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Divider(
                  color: TColor.secondaryText.withOpacity(0.4),
                  height: 1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  "Order Tracking Details",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: ListTile(
                  title: OrderTrackerZen(
                    tracker_data: [
                      TrackerData(
                        title: "Order Place",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Your order was placed on Zenzzen",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                          TrackerDetails(
                            title: "Zenzzen Arranged A Callback Request",
                            datetime: "Sat, 8 Apr '22 - 17:42",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "Order Shipped",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Your order was shipped with MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "Order Delivered",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
