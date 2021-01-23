import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBookItemHorizontalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Get.isDarkMode ? Colors.grey[700] : Colors.grey[300],
      highlightColor: Get.isDarkMode ? Colors.grey[600] : Colors.grey[100],
      child: Container(
        margin: EdgeInsets.only(left: 8),
        width: Get.height / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            verticalSpaceSmall,
            Container(
              height: 25,
              color: Colors.white,
            ),
            verticalSpaceTiny,
            Container(
              height: 20,
              width: Get.width / 4,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}