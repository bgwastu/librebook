import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/app_localizations.dart';
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
    setCurrentOverlay(Get.isDarkMode);
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
    setCurrentOverlay(Get.isDarkMode);

    final ThemeData theme = Get.theme;
    return theme.copyWith(
      primaryColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        brightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      primaryIconTheme: theme.primaryIconTheme.copyWith(
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[800]),
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
    setCurrentOverlay(Get.isDarkMode);
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    setCurrentOverlay(Get.isDarkMode);
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
          InkWell(
            onTap: () {
              print('tap');
              if (!controller.isFantasyBusy.value) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchResultView(
                    query: query,
                    firstSearchDetail: controller.currentFantasySearchDetail,
                    isGeneral: false,
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
                    AppLocalizations.of(context).translate('fiction-books'),
                    style: Theme.of(Get.context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: null,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<BookSearchDetail>(
              future: controller.searchFantasyBook(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _shimmerLoading(context);
                }

                if (snapshot.hasData) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    separatorBuilder: (context, _) => horizontalSpaceSmall,
                    itemCount: snapshot.data.listBook.length,
                    itemBuilder: (context, index) {
                      return BookItemHorizontalWidget(
                        book: snapshot.data.listBook[index],
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return _errorHandle(snapshot.error);
                }

                return SizedBox();
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
          InkWell(
            onTap: () {
              if (!controller.isGeneralBusy.value) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchResultView(
                    query: query,
                    firstSearchDetail: controller.currentGeneralSearchDetail,
                    isGeneral: true,
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
                    AppLocalizations.of(context).translate('general-books'),
                    style: Theme.of(Get.context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: null,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<BookSearchDetail>(
              future: controller.searchGeneralBook(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _shimmerLoading(context);
                }

                if (snapshot.hasData) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    separatorBuilder: (context, _) => horizontalSpaceSmall,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.listBook.length,
                    itemBuilder: (context, index) {
                      return BookItemHorizontalWidget(
                        book: snapshot.data.listBook[index],
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return _errorHandle(snapshot.error);
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorHandle(e) {
    //TODO: handle error

    if (e is SocketException) {
      return _noInternetWidget();
    }

    if (e is SearchNotFoundException) {
      return _notFoundWidget();
    }

    return Center(
      child:
          Text(AppLocalizations.of(Get.context).translate('undefined-error')),
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
          AppLocalizations.of(Get.context).translate('no-internet-error-title'),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        Text(
          AppLocalizations.of(Get.context)
              .translate('no-internet-error-description'),
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
        Icon(Icons.sentiment_dissatisfied, size: 50),
        verticalSpaceSmall,
        Text(
          AppLocalizations.of(Get.context).translate('not-found-error-title'),
          style: Theme.of(Get.context).textTheme.headline6,
        ),
        Text(
          AppLocalizations.of(Get.context)
              .translate('not-found-error-description'),
          style: Theme.of(Get.context).textTheme.bodyText1,
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
