import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/download_controller.dart';
import 'package:librebook/controllers/home_controller.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/book_detail/book_detail_view.dart';
import 'package:librebook/ui/widgets/image_error_widget.dart';
import 'package:shimmer/shimmer.dart';

class DownloadView extends StatelessWidget {
  final _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _homeController.getDownloadList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.hasData) {
            final listMeta = snapshot.data;
            return ListView.builder(
              itemCount: listMeta.length,
              itemBuilder: (context, index){
                Book book = listMeta[index]['book'];
                return Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: InkWell(
                    onTap: () {
                      Get.to(BookDetailView(
                        book: book,
                      ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _coverImage(book),
                        horizontalSpaceSmall,
                        _detailBook(book),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            //TODO: create a no list ui
            return Container();
          }
        });
  }
  Expanded _detailBook(Book book) {
    return Expanded(
      child: Container(
        height: Get.height / 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpaceTiny,
                Text(
                  book.authors.join(', '),
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Format: ' + book.format,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Language: ' + book.language,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _coverImage(Book book) {
    return Container(
      height: Get.height / 6,
      width: Get.height / 8,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 2,
            left: 2,
            child: Material(
              elevation: 3,
              color: primaryColor,
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    book.format,
                    style: TextStyle(
                        color: secondaryColor, fontWeight: FontWeight.w600),
                  )),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]),
            ),
            child: CachedNetworkImage(
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
            ),
          ),
        ],
      ),
    );
  }
}
