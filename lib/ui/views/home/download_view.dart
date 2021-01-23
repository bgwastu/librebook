import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/home_controller.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/book_detail/book_detail_view.dart';
import 'package:librebook/ui/widgets/image_error_widget.dart';
import 'package:shimmer/shimmer.dart';

class DownloadView extends StatelessWidget {
  final _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _homeController.getDownloadList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (snapshot.hasError) {
            throw snapshot.error;
          }

          if (snapshot.hasData) {
            final listMeta = snapshot.data.reversed.toList();
            return ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: listMeta.length,
              itemBuilder: (context, index) {
                Book book = listMeta[index]['book'];
                return InkWell(
                  onTap: () {
                    Get.to(BookDetailView(
                      book: book,
                    ));
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
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
        height: Get.height / 9.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
                  style: TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _coverImage(Book book) {
    return Card(
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: Get.height / 10,
          width: Get.height / 15,
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
      ),
    );
  }
}
