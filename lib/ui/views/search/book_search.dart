import 'dart:io';

import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/search_controller.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/search_result/search_result_view.dart';
import 'package:librebook/ui/widgets/book_item_horizontal_widget.dart';
import 'package:librebook/ui/widgets/custom_search_widget.dart' as customSearch;
import 'package:librebook/ui/widgets/shimmer_book_item_horizontal_widget.dart';
import 'package:librebook/utils/custom_exception.dart';

class BookSearch extends customSearch.SearchDelegate<Map<String, dynamic>> {
  bool isResultView = false;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty && !isResultView
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            )
          : isResultView
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSuggestions(context);
                  },
                )
              : Container(),
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme:
          theme.primaryIconTheme.copyWith(color: Colors.grey[600]),
      primaryColorBrightness: Brightness.light,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search for title, author, ISBN';

  @override
  Widget buildResults(BuildContext context) {
    isResultView = true;
    final controller = Get.put(SearchController());
    return ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        _generalBookList(context, controller),
        _fictionBookList(context, controller),
      ],
    );
  }

  Container _fictionBookList(
      BuildContext context, SearchController controller) {
    return Container(
      height: Get.height / 2.3,
      child: Column(
        children: <Widget>[
          Obx(
            () => InkWell(
              onTap: () {
                //TODO: On tap go to fiction list book
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Fiction Books',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: null,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: EnhancedFutureBuilder<BookSearchDetail>(
              future: controller.searchFantasyBook(query),
              whenWaiting: _shimmerLoading(context),
              whenNotDone: _shimmerLoading(context),
              whenError: _errorHandle,
              rememberFutureResult: true,
              whenDone: (bookSearchDetail) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  separatorBuilder: (context, _) => horizontalSpaceSmall,
                  itemCount: bookSearchDetail.listBook.length,
                  itemBuilder: (context, index) {
                    return BookItemHorizontalWidget(
                      book: bookSearchDetail.listBook[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _generalBookList(
      BuildContext context, SearchController controller) {
    return Container(
      height: Get.height / 2.3,
      child: Column(
        children: <Widget>[
          Obx(
            () => InkWell(
              onTap: () async {
                //TODO: On tap go to general list book
                if (!controller.isGeneralBusy.value) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchResultView(
                      query: query,
                      firstSearchDetail: controller.currentGeneralSearchDetail,
                    ),
                  ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'General Books',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: null,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: EnhancedFutureBuilder<BookSearchDetail>(
              future: controller.searchGeneralBook(query),
              whenWaiting: _shimmerLoading(context),
              whenNotDone: _shimmerLoading(context),
              rememberFutureResult: true,
              whenError: _errorHandle,
              whenDone: (bookSearchDetail) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  separatorBuilder: (context, _) => horizontalSpaceSmall,
                  scrollDirection: Axis.horizontal,
                  itemCount: bookSearchDetail.listBook.length,
                  itemBuilder: (context, index) {
                    return BookItemHorizontalWidget(
                      book: bookSearchDetail.listBook[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorHandle(e) {
    //TODO: handle error
    print(e);

    if (e is SocketException) {
      return _noInternetWidget();
    }

    if (e is SearchNotFoundException) {
      return _notFoundWidget();
    }

    if(e is ServerException) {
      print(e.message);
    }

    return Center(
      child: Text(e.toString()),
    );
  }

  Widget _noInternetWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.signal_cellular_connected_no_internet_4_bar,
          size: 50,
          color: Colors.grey[600],
        ),
        verticalSpaceSmall,
        Text(
          'Not Found',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        Text(
          'No internet access',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        )
      ],
    );
  }

  ListView _shimmerLoading(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(10, (index) => ShimmerBookItemHorizontalWidget()),
    );
  }

  Column _notFoundWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sentiment_dissatisfied,
          size: 50,
          color: Colors.grey[600],
        ),
        verticalSpaceSmall,
        Text(
          'Not Found',
          style: TextStyle(
            fontSize: 22,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Please try with another query',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    isResultView = false;
    return query.isNotEmpty
        ? ListView(children: <Widget>[
            ListTile(
              title: Text(
                query,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
              leading: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(horizontal: 32),
              onTap: () => showResults(context),
            )
          ])
        : Container();
  }
}
