import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/view/more/food_item_view.dart';
import 'package:food_delivery/view/more/subcategory_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';
import 'menu_items_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  List loadArr = [
    {
      "name": "Food",
      "image": "assets/img/menu_1.png",
    },
    {
      "name": "Beverages",
      "image": "assets/img/menu_2.png",
    },
    {
      "name": "Desserts",
      "image": "assets/img/menu_3.png",
    },
    {
      "name": "Promotions",
      "image": "assets/img/menu_4.png",
    },
  ];
  List catArr = [];
  bool isLoading = true;
  TextEditingController txtSearch = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 180),
            width: media.width * 0.27,
            height: media.height * 0.6,
            decoration: BoxDecoration(
              color: TColor.primary,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
            ),
          ),
          SingleChildScrollView(
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
                          "Menu",
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
                    height: 30,
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: loadArr.length,
                      itemBuilder: (isLoading == true)
                          ? ((context, index) {
                              var mObj = loadArr[index] as Map? ?? {};
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 8, bottom: 8, right: 20),
                                        width: media.width - 100,
                                        height: 90,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomLeft: Radius.circular(25),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 4))
                                            ]),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            mObj["image"].toString(),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  mObj["name"].toString(),
                                                  style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(17.5),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2))
                                                ]),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              "assets/img/btn_next.png",
                                              width: 15,
                                              height: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                          : ((context, index) {
                              var cObj = catArr[index] as Map? ?? {};
                              return GestureDetector(
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
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 8, bottom: 8, right: 20),
                                      width: media.width - 100,
                                      height: 90,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 7,
                                                offset: Offset(0, 4))
                                          ]),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              height: 80,
                                              width: 80,
                                              imageUrl:
                                                  "https://dvp.pythonanywhere.com${cObj["img_url"]}",
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                child:
                                                    Text("Image Can't be load"),
                                              ),
                                              fit: BoxFit.contain,
                                            )),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cObj["name"].toString(),
                                                style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(17.5),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2))
                                              ]),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/img/btn_next.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
