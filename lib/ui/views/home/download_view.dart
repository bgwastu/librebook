import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/app_localizations.dart';
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
            if (snapshot.data.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 64, color: Colors.grey[600],),
                  verticalSpaceSmall,
                  Text(AppLocalizations.of(context).translate('no-books-title'), style: Theme.of(context).textTheme.headline6),
                  verticalSpaceSmall,
                  Text(AppLocalizations.of(context).translate('no-books-description'), style: Theme.of(context).textTheme.bodyText2)
                ],
              );
            }
            final listMeta = snapshot.data.reversed.toList();
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listMeta.length,
              itemBuilder: (context, index) {
                Book book = listMeta[index]['book'];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailView(book: book)));
                   
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
          }else {
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
                  style: Get.textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpaceTiny,
                Text(
                  book.authors.join(', '),
                  maxLines: 1,
                  style: Theme.of(Get.context).textTheme.caption,
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
    return ClipRRect(
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
    );
  }
}
