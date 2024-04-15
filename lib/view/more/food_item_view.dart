import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/view/menu/item_details_view.dart';
import 'package:food_delivery/view/more/food_details_view.dart';
import 'package:food_delivery/view/more/food_item_row.dart';
import 'package:shimmer/shimmer.dart';

import '../../common_widget/menu_item_row.dart';
import '../more/my_order_view.dart';
import '../more/food_item_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class FoodItemsView extends StatefulWidget {
  final int id;
  final String category;
  const FoodItemsView({super.key, required this.id, required this.category});

  @override
  State<FoodItemsView> createState() => _FoodItemsViewState();
}

class _FoodItemsViewState extends State<FoodItemsView> {
  TextEditingController txtSearch = TextEditingController();

  bool isLoading = true;
  List foodArr = [];
  Future<void> fetchProducts() async {
    var url =
        Uri.parse("https://dvp.pythonanywhere.com/getProducts/${widget.id}");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          foodArr.add(value);
        });
        print(foodArr[0]);
        foodArr = foodArr[0];
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

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  List menuItemsArr = [
    {
      "image": "assets/img/dess_1.png",
      "name": "French Apple Pie",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_2.png",
      "name": "Dark Chocolate Cake",
      "rate": "4.9",
      "rating": "124",
      "type": "Cakes by Tella",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_3.png",
      "name": "Street Shake",
      "rate": "4.9",
      "rating": "124",
      "type": "Café Racer",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_4.png",
      "name": "Fudgy Chewy Brownies",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_1.png",
      "name": "French Apple Pie",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_2.png",
      "name": "Dark Chocolate Cake",
      "rate": "4.9",
      "rating": "124",
      "type": "Cakes by Tella",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_3.png",
      "name": "Street Shake",
      "rate": "4.9",
      "rating": "124",
      "type": "Café Racer",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_4.png",
      "name": "Fudgy Chewy Brownies",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        widget.category.toString(),
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: foodArr.length,
                itemBuilder: (isLoading == true)
                    ? (context, index) {
                        var mObj = menuItemsArr[index] as Map? ?? {};
                        return Shimmer.fromColors(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () {},
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Image.asset(
                                      mObj["image"].toString(),
                                      width: double.maxFinite,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      height: 200,
                                      decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black
                                          ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                mObj["name"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    "assets/img/rate.png",
                                                    width: 10,
                                                    height: 10,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    mObj["rate"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: TColor.primary,
                                                        fontSize: 11),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    mObj["type"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: TColor.white,
                                                        fontSize: 11),
                                                  ),
                                                  Text(
                                                    " . ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: TColor.primary,
                                                        fontSize: 11),
                                                  ),
                                                  Text(
                                                    mObj["food_type"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: TColor.white,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 22,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!);
                      }
                    : ((context, index) {
                        var mObj = foodArr[index] as Map? ?? {};
                        return FoodItemRow(
                          mObj: mObj,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodDetailsView(
                                        id: mObj['id'],
                                      )),
                            );
                          },
                        );
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
