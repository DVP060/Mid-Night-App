import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/offer_food_view.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/more/food_details_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../common_widget/popular_resutaurant_row.dart';
import '../more/my_order_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class OfferView extends StatefulWidget {
  const OfferView({super.key});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  TextEditingController txtSearch = TextEditingController();

  List loadArr = [
    {
      "image": "assets/img/offer_1.png",
      "name": "Café de Noires",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_2.png",
      "name": "Isso",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/offer_3.png",
      "name": "Cafe Beans",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List offerFoodItemArr = [];
  bool isLoading = true;
  Future<void> fetchFoodItems() async {
    var url = Uri.parse("https://dvp.pythonanywhere.com/getoffers");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          offerFoodItemArr.add(value);
        });
        print(offerFoodItemArr[0]);
        offerFoodItemArr = offerFoodItemArr[0];
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
    fetchFoodItems();
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Offers",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find discounts, Offers special\nmeals and more!",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 140,
                  height: 30,
                  child: RoundButton(
                      title: "check Offers", fontSize: 12, onPressed: () {}),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: loadArr.length,
                  itemBuilder: (isLoading == true)
                      ? (context, index) {
                          var pObj = loadArr[index] as Map? ?? {};
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      pObj["image"].toString(),
                                      width: double.maxFinite,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pObj["name"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 8,
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
                                                pObj["rate"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.primary,
                                                    fontSize: 11),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "(${pObj["rating"]} Ratings)",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.secondaryText,
                                                    fontSize: 11),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                pObj["type"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.secondaryText,
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
                                                pObj["food_type"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.secondaryText,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      : ((context, index) {
                          var fObj = offerFoodItemArr[index] as Map? ?? {};
                          return OfferFoodRow(
                            pObj: fObj,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDetailsView(
                                          id: fObj['id'],
                                        )),
                              );
                            },
                          );
                        })),
            ],
          ),
        ),
      ),
    );
  }
}
