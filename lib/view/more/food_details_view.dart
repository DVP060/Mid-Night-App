import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/color_extension.dart';
import '../more/my_order_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class FoodDetailsView extends StatefulWidget {
  final int id;
  const FoodDetailsView({super.key, required this.id});

  @override
  State<FoodDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<FoodDetailsView> {
  bool isLoading = true;
  double price = 15;
  int qty = 1;
  bool isFav = false;
  // _saveCart(int id) async {
  // var url = Uri.parse("https://dvp.pythonanywhere.com/cart/$id/$qty");
  // try {
  //   var response = await http.get(url);
  //   String key = "";
  //   if (response.statusCode == 200) {
  //     final result = jsonDecode(response.body) as Map<String, dynamic>;
  //     // print(result);
  //     result.forEach((key, value) {
  //       // print(key);
  //       key = key;
  //       print(value);
  //     });
  //     if (key == "message") {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => MyOrderView()));
  //     }
  //   }
  // } catch (error) {
  //   print("error $error");
  // }
  // }

  List foodArr = [
    {
      "id": 5,
      "name": "Garlic Burger",
      "description":
          "The Garlic Burger is a savory delight that caters to garlic enthusiasts and burger aficionados alike. Featuring a perfectly grilled patty, typically made from beef or chicken, this burger is generously infused with the bold and aromatic flavor of garlic.",
      "price": 149,
      "img_url": "/media/photos/Garlic_JnR8Ba6.jpg",
      "jain": false
    }
  ];
  Future<void> fetchFoodDetails() async {
    var url =
        Uri.parse("https://dvp.pythonanywhere.com/getProduct/${widget.id}");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        // print(result);
        print(result['product']);
        foodArr.add(result['product']);
        setState(() {});
        Timer(Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
            foodArr.removeAt(0);
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
    fetchFoodDetails();
  }

  @override
  Widget build(BuildContext context) {
    var fObj = foodArr[0] as Map? ?? {};
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: (isLoading == true)
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Image.asset(
                  //   "assets/img/detail_top.png",
                  //   width: media.width,
                  //   height: media.width,
                  //   fit: BoxFit.cover,
                  // ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://dvp.pythonanywhere.com${fObj["img_url"]}",
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        width: MediaQuery.of(context).size.width,
                        errorWidget: (context, url, error) => Center(
                          child: Text("Image Can't be loaded $error"),
                        ),
                        fit: BoxFit.cover,
                      )),
                  Container(
                    width: media.width,
                    height: media.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                            Colors.black
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: media.width - 60,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: TColor.white,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          fObj['name'],
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IgnorePointer(
                                                  ignoring: true,
                                                  child: RatingBar.builder(
                                                    initialRating: 4,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    itemPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 1.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: TColor.primary,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  " 4 Star Ratings",
                                                  style: TextStyle(
                                                      color: TColor.primary,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "\Rs.${fObj['price'].toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 31,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "/per Portion",
                                                  style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          "Description",
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          fObj['description'],
                                          style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Divider(
                                            color: TColor.secondaryText
                                                .withOpacity(0.4),
                                            height: 1,
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          "Customize your Order",
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: BoxDecoration(
                                              color: TColor.textfield,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              items: ["small", "Big"].map((e) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style: TextStyle(
                                                        color:
                                                            TColor.primaryText,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {},
                                              hint: Text(
                                                "- Select the size of portion -",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.secondaryText,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: BoxDecoration(
                                              color: TColor.textfield,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              items: ["small", "Big"].map((e) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style: TextStyle(
                                                        color:
                                                            TColor.primaryText,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {},
                                              hint: Text(
                                                "- Select the ingredients -",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.secondaryText,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Number of Portions",
                                              style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                qty = qty - 1;

                                                if (qty < 1) {
                                                  qty = 1;
                                                }
                                                setState(() {});
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                height: 25,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: TColor.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.5)),
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              height: 25,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: TColor.primary,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.5)),
                                              child: Text(
                                                qty.toString(),
                                                style: TextStyle(
                                                    color: TColor.primary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                qty = qty + 1;

                                                setState(() {});
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                height: 25,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: TColor.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.5)),
                                                child: Text(
                                                  "+",
                                                  style: TextStyle(
                                                      color: TColor.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 220,
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Container(
                                              width: media.width * 0.25,
                                              height: 160,
                                              decoration: BoxDecoration(
                                                color: TColor.primary,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(35),
                                                        bottomRight:
                                                            Radius.circular(
                                                                35)),
                                              ),
                                            ),
                                            Center(
                                              child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 8,
                                                              bottom: 8,
                                                              left: 10,
                                                              right: 20),
                                                      width: media.width - 80,
                                                      height: 120,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(35),
                                                                  bottomLeft: Radius.circular(35),
                                                                  topRight: Radius.circular(10),
                                                                  bottomRight: Radius.circular(10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 12,
                                                                offset: Offset(
                                                                    0, 4))
                                                          ]),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Total Price",
                                                            style: TextStyle(
                                                                color: TColor
                                                                    .primaryText,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            "\$${(fObj['price'] * qty).toString()}",
                                                            style: TextStyle(
                                                                color: TColor
                                                                    .primaryText,
                                                                fontSize: 21,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 130,
                                                            height: 25,
                                                            child: RoundIconButton(
                                                                title:
                                                                    "Add to Cart",
                                                                icon:
                                                                    "assets/img/shopping_add.png",
                                                                color: TColor
                                                                    .primary,
                                                                onPressed:
                                                                    () {}),
                                                          )
                                                        ],
                                                      )),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const MyOrderView()));
                                                    },
                                                    child: Container(
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      22.5),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                    0, 2))
                                                          ]),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Image.asset(
                                                          "assets/img/shopping_cart.png",
                                                          width: 20,
                                                          height: 20,
                                                          color:
                                                              TColor.primary),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Container(
                            height: media.width - 20,
                            alignment: Alignment.bottomRight,
                            margin: const EdgeInsets.only(right: 4),
                            child: InkWell(
                                onTap: () {
                                  isFav = !isFav;
                                  setState(() {});
                                },
                                child: Image.asset(
                                    isFav
                                        ? "assets/img/favorites_btn.png"
                                        : "assets/img/favorites_btn_2.png",
                                    width: 70,
                                    height: 70)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset(
                                  "assets/img/btn_back.png",
                                  width: 20,
                                  height: 20,
                                  color: TColor.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyOrderView()));
                                },
                                icon: Image.asset(
                                  "assets/img/shopping_cart.png",
                                  width: 25,
                                  height: 25,
                                  color: TColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                // Image.asset(
                //   "assets/img/detail_top.png",
                //   width: media.width,
                //   height: media.width,
                //   fit: BoxFit.cover,
                // ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://dvp.pythonanywhere.com${fObj["img_url"]}",
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      width: MediaQuery.of(context).size.width,
                      errorWidget: (context, url, error) => Center(
                        child: Text("Image Can't be loaded $error"),
                      ),
                      fit: BoxFit.cover,
                    )),
                Container(
                  width: media.width,
                  height: media.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black,
                      Colors.transparent,
                      Colors.black
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: media.width - 60,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: TColor.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Text(
                                        fObj['name'],
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              IgnorePointer(
                                                ignoring: true,
                                                child: RatingBar.builder(
                                                  initialRating: 4,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 1.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: TColor.primary,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                " 4 Star Ratings",
                                                style: TextStyle(
                                                    color: TColor.primary,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\Rs.${fObj['price'].toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 31,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "/per Portion",
                                                style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Text(
                                        fObj['description'],
                                        style: TextStyle(
                                            color: TColor.secondaryText,
                                            fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Divider(
                                          color: TColor.secondaryText
                                              .withOpacity(0.4),
                                          height: 1,
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Text(
                                        "Customize your Order",
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: TColor.textfield,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            items: ["small", "Big"].map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (val) {},
                                            hint: Text(
                                              "- Select the size of portion -",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: TColor.secondaryText,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: TColor.textfield,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            items: ["small", "Big"].map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (val) {},
                                            hint: Text(
                                              "- Select the ingredients -",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: TColor.secondaryText,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Number of Portions",
                                            style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              qty = qty - 1;

                                              if (qty < 1) {
                                                qty = 1;
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              height: 25,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: TColor.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.5)),
                                              child: Text(
                                                "-",
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            height: 25,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: TColor.primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.5)),
                                            child: Text(
                                              qty.toString(),
                                              style: TextStyle(
                                                  color: TColor.primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              qty = qty + 1;

                                              setState(() {});
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              height: 25,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: TColor.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.5)),
                                              child: Text(
                                                "+",
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 220,
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Container(
                                            width: media.width * 0.25,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              color: TColor.primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(35),
                                                      bottomRight:
                                                          Radius.circular(35)),
                                            ),
                                          ),
                                          Center(
                                            child: Stack(
                                              alignment: Alignment.centerRight,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 8,
                                                            left: 10,
                                                            right: 20),
                                                    width: media.width - 80,
                                                    height: 120,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        35),
                                                                bottomLeft:
                                                                    Radius
                                                                        .circular(
                                                                            35),
                                                                topRight: Radius.circular(10),
                                                                bottomRight: Radius.circular(10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              blurRadius: 12,
                                                              offset:
                                                                  Offset(0, 4))
                                                        ]),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Total Price",
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primaryText,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "\Rs.${(fObj['price'] * qty).toString()}",
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primaryText,
                                                              fontSize: 21,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 130,
                                                          height: 25,
                                                          child:
                                                              RoundIconButton(
                                                            title:
                                                                "Add to Cart",
                                                            icon:
                                                                "assets/img/shopping_add.png",
                                                            color:
                                                                TColor.primary,
                                                            onPressed:
                                                                () async {
                                                              int id =
                                                                  fObj['id'];
                                                              var url = Uri.parse(
                                                                  "https://dvp.pythonanywhere.com/cart/$id/$qty");
                                                              try {
                                                                var response =
                                                                    await http
                                                                        .get(
                                                                            url);
                                                                String key = "";
                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  final result =
                                                                      jsonDecode(
                                                                          response
                                                                              .body) as Map<
                                                                          String,
                                                                          dynamic>;
                                                                  // print(result);
                                                                  bool val =
                                                                      false;
                                                                  result.forEach(
                                                                      (key,
                                                                          value) {
                                                                    // print(key);
                                                                    key = key;
                                                                    if (key ==
                                                                        "status") {
                                                                      if (value ==
                                                                          true) {
                                                                        val =
                                                                            value;
                                                                        setState(
                                                                            () {});
                                                                        print("in " +
                                                                            val.toString());
                                                                      }
                                                                    }
                                                                  });
                                                                  print("out " +
                                                                      val.toString());
                                                                  if (val ==
                                                                      true) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                MyOrderView()));
                                                                  }
                                                                }
                                                              } catch (error) {
                                                                print(
                                                                    "error $error");
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const MyOrderView()));
                                                  },
                                                  child: Container(
                                                    width: 45,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(22.5),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(0, 2))
                                                        ]),
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/img/shopping_cart.png",
                                                        width: 20,
                                                        height: 20,
                                                        color: TColor.primary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Container(
                          height: media.width - 20,
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.only(right: 4),
                          child: InkWell(
                              onTap: () {
                                isFav = !isFav;
                                setState(() {});
                              },
                              child: Image.asset(
                                  isFav
                                      ? "assets/img/favorites_btn.png"
                                      : "assets/img/favorites_btn_2.png",
                                  width: 70,
                                  height: 70)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Image.asset(
                                "assets/img/btn_back.png",
                                width: 20,
                                height: 20,
                                color: TColor.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyOrderView()));
                              },
                              icon: Image.asset(
                                "assets/img/shopping_cart.png",
                                width: 25,
                                height: 25,
                                color: TColor.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
