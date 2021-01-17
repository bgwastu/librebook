import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:librebook/controllers/search_result_controller.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/book_detail/book_detail_view.dart';
import 'package:librebook/ui/widgets/image_error_widget.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultView extends StatefulWidget {
  final String query;
  final bool isGeneral;
  final BookSearchDetail firstSearchDetail;

  SearchResultView({
    Key key,
    @required this.query,
    @required this.firstSearchDetail,
    @required this.isGeneral,
  }) : super(key: key);

  @override
  _SearchResultViewState createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  final controller = Get.put(SearchResultController());

  @override
  void initState() {
    super.initState();
    controller.setBookSearchDetailNew(widget.firstSearchDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.isGeneral ? 'General Books' : 'Fantasy Books',
          style: TextStyle(color: Colors.grey[800]),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
      body: Obx(
        () => LazyLoadRefreshIndicator(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final book = controller.listBook[index];
              final isNextPage = index + 1 >= controller.listBook.length &&
                  !controller.isLastPage();
              if (isNextPage) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8, top: 16),
                  child: Column(
                    children: [CircularProgressIndicator()],
                  ),
                );
              }

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
            itemCount: controller.listBook.length,
          ),
          onEndOfPage: () => controller.loadData(widget.query),
          onRefresh: () => controller.onRefreshData(widget.query),
          isLoading: controller.isLoading.value,
          scrollOffset: 150,
        ),
      ),
    );
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
          Card(
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
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
        ],
      ),
    );
  }
}
