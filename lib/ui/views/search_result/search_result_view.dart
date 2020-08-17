import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:librebook/controllers/search_result_controller.dart';
import 'package:librebook/models/book_search_detail_model.dart';

class SearchResultView extends StatefulWidget {
  final String query;
  final BookSearchDetail firstSearchDetail;

  SearchResultView({
    Key key,
    @required this.query,
    @required this.firstSearchDetail,
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
          'General Books',
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
              final isNextPage = index + 1 >= controller.listBook.length &&
                  !controller.isLastPage();
              if (isNextPage) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [CircularProgressIndicator()],
                  ),
                );
              }

              return ListTile(
                title: Text(controller.listBook[index].title),
                subtitle: Text(controller.listBook[index].authors.join(', ')),
                trailing: Text(
                  controller.listBook[index].id,
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
}
