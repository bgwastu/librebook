import 'package:flutter/material.dart';
import 'package:librebook/ui/shared/ui_helper.dart';

class ImageErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey[600],
            ),
            verticalSpaceSmall,
            Center(
              child: Text(
                'Image not available',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
