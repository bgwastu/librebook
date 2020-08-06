import 'package:flutter/material.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/search/search_viewmodel.dart';
import 'package:librebook/ui/views/search_result/search_result_general_view.dart';
import 'package:librebook/ui/widgets/book_item_horizontal_widget.dart';
import 'package:librebook/ui/widgets/shimmer_book_item_horizontal_widget.dart';
import 'package:stacked/stacked.dart';

// TODO:
// - Handle Error
class BookSearch extends SearchDelegate<Map<String, dynamic>> {
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
          // General book list Widget
          Container(
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
                  child: FutureBuilder<List<Book>>(
                      future: model.searchGeneralBook(query),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Loading Widget
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            // If list book is empty
                            return _generalNotFound();
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data.length - 1) {
                                // Next Widget
                                return _moreWidget(() {
                                  // TODO: go to list view general
                                });
                              }

                              // Book Item Widget
                              return BookItemHorizontalWidget(
                                book: snapshot.data[index],
                              );
                            },
                          );
                        }

                        if (snapshot.hasError) {
                          //TODO: handle error
                          print(snapshot.error.toString());
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        return Container();
                      }),
                ),
              ],
            ),
          ),

          // Fiction book list Widget
          Container(
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
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: model.searchFantasyBook(query),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Loading Widget
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            // If fiction book was not found
                            return _fictionNotFound();
                          }

                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data.length - 1) {
                                // Next Widget
                                return _moreWidget(() {
                                  // TODO: go to list view fiction
                                });
                              }

                              // Book Item Widget
                              return FutureBuilder<Book>(
                                  future: model.getDetailBookFiction(
                                      snapshot.data[index]['url']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ShimmerBookItemHorizontalWidget();
                                    }

                                    if (snapshot.hasData) {
                                      return BookItemHorizontalWidget(
                                        book: snapshot.data,
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Container();
                                    }

                                    return Container();
                                  });
                            },
                          );
                        }

                        if (snapshot.hasError) {
                          //TODO: handle error
                          print(snapshot.error.toString());

                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        return Container();
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      viewModelBuilder: () => SearchViewModel(),
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
