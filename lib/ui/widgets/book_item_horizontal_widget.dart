import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/widgets/image_error_widget.dart';
import 'package:shimmer/shimmer.dart';

class BookItemHorizontalWidget extends StatelessWidget {
  final Book book;

  BookItemHorizontalWidget({@required this.book});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 3.2,
      child: InkWell(
        onTap: () {
          //TODO: implement tap book item horizontal widget
          print('tap');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[_coverImage(), _formatBook()],
              ),
            ),
            verticalSpaceSmall,
            _titleBook(),
            verticalSpaceTiny,
            _authorBook()
          ],
        ),
      ),
    );
  }

  Text _authorBook() {
    return Text(
      book.authors.join(', '),
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Text _titleBook() {
    return Text(
      book.title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Positioned _formatBook() {
    return Positioned(
      right: 4,
      top: 4,
      child: Material(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            book.format,
            style:
                TextStyle(color: secondaryColor, fontWeight: FontWeight.w600),
          ),
          color: primaryColor,
        ),
      ),
    );
  }

  CachedNetworkImage _coverImage() {
    return CachedNetworkImage(
      imageUrl: book.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: double.infinity,
          color: Colors.white,
        ),
      ),
      fit: BoxFit.fill,
      errorWidget: (context, _, __) {
        return ImageErrorWidget();
      },

      width: double.infinity,
    );
  }
}
