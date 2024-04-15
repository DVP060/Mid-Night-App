import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class OfferFoodRow extends StatelessWidget {
  final Map pObj;
  final VoidCallback onTap;
  const OfferFoodRow({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: "https://dvp.pythonanywhere.com${pObj["img_url"]}",
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Text("Image Can't be loaded $error"),
                  ),
                  width: double.maxFinite,
                  height: 200,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              width: 8,
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      // Text(
                      //   pObj["rate"],
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(color: TColor.primary, fontSize: 11),
                      // ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                      // Text(
                      //   "(${pObj["rating"]} Ratings)",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       color: TColor.secondaryText, fontSize: 11),
                      // ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                      Text(
                        (pObj["jain"] == true) ? "Jain" : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 11),
                      ),
                      Text(
                        " . ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: TColor.primary, fontSize: 11),
                      ),
                      Container(
                        height: 60,
                        width: 200,
                        child: Text(
                          pObj["offer"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.secondaryText, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
