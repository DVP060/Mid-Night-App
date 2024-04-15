import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/view/home/location.dart';
import 'package:food_delivery/view/menu/menu_items_view.dart';
import 'package:food_delivery/view/menu/menu_view.dart';
import 'package:food_delivery/view/more/food_details_view.dart';
import 'package:food_delivery/view/more/food_item_view.dart';
import 'package:food_delivery/view/more/subcategory_view.dart';
import 'package:food_delivery/view/offer/offer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../../common_widget/recent_item_row.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/main.dart';
import 'package:geocoding/geocoding.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? address = "";
  final locationObj = const LocationIdentifier();
  TextEditingController txtSearch = TextEditingController();
  bool isLoading = true;
  List catArr = [];
  Future<void> fetchCategory() async {
    var url = Uri.parse("https://dvp.pythonanywhere.com/getCategories");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          catArr.add(value);
        });
        print(catArr[0]);
        catArr = catArr[0];
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

  List randomFoodItemArr = [];
  bool isFoodLoading = true;
  Future<void> fetchFoodItems() async {
    var url = Uri.parse("https://dvp.pythonanywhere.com/getrandomproducts");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          randomFoodItemArr.add(value);
        });
        print(randomFoodItemArr[0]);
        randomFoodItemArr = randomFoodItemArr[0];
        setState(() {});
        Timer(Duration(seconds: 3), () {
          setState(() {
            isFoodLoading = false;
          });
        });
      } else {
        print("no data found");
      }
    } catch (error) {
      print("error $error");
    }
  }

  _fetchResult(int id) async {
    var url = Uri.parse("https://dvp.pythonanywhere.com/getResult/$id");
    try {
      var response = await http.get(url);
      bool isCatOrPro = false;
      String key = "";
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        result.forEach((key, value) {
          // print(key);
          key = key;
          isCatOrPro = value;
          print("$key" + isCatOrPro.toString());
        });
        if (key == "products") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OfferView()));
        }
      } else {
        print("no data found");
      }
    } catch (error) {
      print("error $error");
    }
  }

  getAddress() async {
    print("this is get address");
    final _pref = await SharedPreferences.getInstance();
    List? lat_long_list = _pref.getStringList(LocationIdentifierState.KEYNAME);
    print(lat_long_list);
    print(double.parse(lat_long_list![0]));
    print(double.parse(lat_long_list[1]));
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(lat_long_list[0]), double.parse(lat_long_list[1]));
    print(placemark);
    setState(() {
      address =
          "${placemark.first.street},${placemark.first.locality},${placemark.first.thoroughfare},${placemark.first.postalCode}";
    });
    print(address);
  }

  @override
  void initState() {
    super.initState();
    getAddress();
    fetchCategory();
    fetchFoodItems();
  }

  List loadArr = [
    {"image": "assets/img/cat_offer.png", "name": ""},
    {"image": "assets/img/cat_sri.png", "name": ""},
    {"image": "assets/img/cat_3.png", "name": ""},
    {"image": "assets/img/cat_4.png", "name": ""},
    {"image": "assets/img/cat_offer.png", "name": ""},
    {"image": "assets/img/cat_sri.png", "name": ""},
    {"image": "assets/img/cat_3.png", "name": ""},
    {"image": "assets/img/cat_4.png", "name": ""},
  ];

  List foodloadArr = [
    {
      "image": "assets/img/res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/res_3.png",
      "name": "Bakes by Tella",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      "image": "assets/img/item_1.png",
      "name": "Mulberry Pizza by Josh",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_2.png",
      "name": "Barita",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_3.png",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Good morning ${ServiceCall.userPayload[KKey.name] ?? ""}!",
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivering to",
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 11),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (address != null)
                            ? Container(
                                height: 60,
                                width: 200,
                                child: Text(
                                  "$address",
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Text(
                                "Choose",
                                style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w700),
                              ),
                        const SizedBox(
                          width: 25,
                        ),
                        Image.asset(
                          "assets/img/dropdown.png",
                          width: 12,
                          height: 12,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: RoundTextfield(
              //     hintText: "Search Food",
              //     controller: txtSearch,
              //     left: Container(
              //       alignment: Alignment.center,
              //       width: 30,
              //       child: Image.asset(
              //         "assets/img/search.png",
              //         width: 20,
              //         height: 20,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Popular Foods",
                  onView: () {},
                ),
              ),
              Container(
                height: 180,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: catArr.length,
                    itemBuilder: (isLoading == true)
                        ? (context, index) {
                            var cObj = loadArr[index] as Map? ?? {};
                            return Shimmer.fromColors(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            cObj['image'],
                                            height: 200,
                                            width: 110,
                                            fit: BoxFit.cover,
                                          )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            cObj["name"],
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!);
                          }
                        : (context, index) {
                            var cObj = catArr[index] as Map? ?? {};
                            return CategoryCell(
                              cObj: cObj,
                              onTap: () async {
                                print("in result");
                                var url = Uri.parse(
                                    "https://dvp.pythonanywhere.com/getResult/${cObj['id']}");
                                try {
                                  var response = await http.get(url);
                                  bool isCatOrPro = false;
                                  String key;
                                  if (response.statusCode == 200) {
                                    final result = jsonDecode(response.body)
                                        as Map<String, dynamic>;
                                    // print(result);
                                    print(result);
                                    if (result['products'] == true) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FoodItemsView(
                                                    id: cObj['id'],
                                                    category: cObj['name'],
                                                  )));
                                    } else if (result['category'] == true) {
                                      var mObj = catArr[index] as Map? ?? {};
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubCatergoryView(
                                                    id: mObj['id'],
                                                    category: mObj['name'],
                                                  )));
                                    } else {
                                      print("error");
                                    }
                                  }
                                } catch (error) {
                                  print("error $error");
                                }
                              },
                            );
                          }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Favorite By People",
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: foodloadArr.length,
                itemBuilder: (isFoodLoading == true)
                    ? (context, index) {
                        var pObj = foodloadArr[index] as Map? ?? {};
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
                        var fObj = randomFoodItemArr[index] as Map? ?? {};
                        return PopularRestaurantRow(
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
                      }),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ViewAllTitleRow(
              //     title: "Most Popular",
              //     onView: () {},
              //   ),
              // ),
              // SizedBox(
              //   height: 200,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     itemCount: mostPopArr.length,
              //     itemBuilder: ((context, index) {
              //       var mObj = mostPopArr[index] as Map? ?? {};
              //       return MostPopularCell(
              //         mObj: mObj,
              //         onTap: () {},
              //       );
              //     }),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ViewAllTitleRow(
              //     title: "Recent Items",
              //     onView: () {},
              //   ),
              // ),
              // ListView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   itemCount: recentArr.length,
              //   itemBuilder: ((context, index) {
              //     var rObj = recentArr[index] as Map? ?? {};
              //     return RecentItemRow(
              //       rObj: rObj,
              //       onTap: () {},
              //     );
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
