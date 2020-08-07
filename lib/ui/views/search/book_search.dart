import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/search/search_viewmodel.dart';
import 'package:librebook/ui/views/search_result/search_result_general_view.dart';
import 'package:librebook/ui/widgets/book_item_horizontal_widget.dart';
import 'package:librebook/ui/widgets/custom_search_widget.dart' as customSearch;
import 'package:librebook/ui/widgets/shimmer_book_item_horizontal_widget.dart';
import 'package:stacked/stacked.dart';

// TODO:
// - Handle Error
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
    return ViewModelBuilder<SearchViewModel>.nonReactive(
      builder: (context, model, _) => ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          _generalBookList(context, model),
          _fictionBookList(context, model),
        ],
      ),
      viewModelBuilder: () => SearchViewModel(),
    );
  }

  Container _fictionBookList(BuildContext context, SearchViewModel model) {
    return Container(
      height: screenHeight(context) / 2.5,
      child: Column(
        children: <Widget>[
          InkWell(
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
          Expanded(
            child: EnhancedFutureBuilder<List<Map<String, dynamic>>>(
              future: model.searchFantasyBook(query),
              whenWaiting: _shimmerLoading(context),
              whenNotDone: _shimmerLoading(context),
              whenError: _errorHandle,
              rememberFutureResult: true,
              whenDone: (listBook) {
                if (listBook.isEmpty) {
                  // If fiction book was not found
                  return _fictionNotFound();
                }

                return ListView.builder(
                  itemCount: listBook.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == listBook.length - 1) {
                      // Next Widget
                      return _moreWidget(() {
                        // TODO: go to list view fiction
                      });
                    }

                    // Book Item Widget
                    return EnhancedFutureBuilder<Book>(
                      future: model.getDetailBookFiction(
                        listBook[index]['url'],
                      ),
                      rememberFutureResult: true,
                      whenWaiting: ShimmerBookItemHorizontalWidget(),
                      whenNotDone: _shimmerLoading(context),
                      whenError: (_) => Container(),
                      whenDone: (book) => BookItemHorizontalWidget(book: book),
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

  Container _generalBookList(BuildContext context, SearchViewModel model) {
    return Container(
      height: screenHeight(context) / 2.5,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () async {
              //TODO: On tap go to general list book
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchResultGeneralView(
                  query: query,
                ),
              ));
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
          Expanded(
            child: EnhancedFutureBuilder<List<Book>>(
              future: model.searchGeneralBook(query),
              whenWaiting: _shimmerLoading(context),
              whenNotDone: _shimmerLoading(context),
              rememberFutureResult: true,
              whenError: _errorHandle,
              whenDone: (listBook) {
                if (listBook.isEmpty) {
                  // If list book is empty
                  return _generalNotFound();
                }
                return ListView.builder(
                  itemCount: listBook.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == listBook.length - 1) {
                      // Next Widget
                      return _moreWidget(() {
                        // TODO: go to list view general
                      });
                    }

                    // Book Item Widget
                    return BookItemHorizontalWidget(
                      book: listBook[index],
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
    print(e.toString());

    return Center(
      child: Text(e.toString()),
    );
  }

  ListView _shimmerLoading(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(10, (index) => ShimmerBookItemHorizontalWidget()),
    );
  }

  Column _fictionNotFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sentiment_dissatisfied,
          size: 50,
        ),
        verticalSpaceSmall,
        Text(
          'Not Found',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Text(
          'query was not found in fiction book',
        )
      ],
    );
  }

  Column _generalNotFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sentiment_dissatisfied,
          size: 50,
        ),
        verticalSpaceSmall,
        Text(
          'Not Found',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Text(
          'query was not found in general book',
          style: TextStyle(),
        )
      ],
    );
  }

  Widget _moreWidget(Function onTap) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      iconSize: 40,
      onPressed: () {},
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
