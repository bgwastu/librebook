import 'package:flutter/material.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBookItemHorizontalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.only(left: 8),
        width: screenWidth(context) / 3.2,
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
              width: screenWidth(context) / 4,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}