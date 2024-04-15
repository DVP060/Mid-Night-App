import 'package:flutter/material.dart';

import '../common/color_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryCell extends StatelessWidget {
  final Map cObj;
  final VoidCallback onTap;
  const CategoryCell({super.key, required this.cObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 200,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: Image.network(
            //     "https://dvp.pythonanywhere.com${cObj["img_url"]}",
            //     width: 85,
            //     height: 200,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: "https://dvp.pythonanywhere.com${cObj["img_url"]}",
                  height: 200,
                  width: 110,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Text("Image Can't be loaded $error"),
                  ),
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
    );
  }
}
