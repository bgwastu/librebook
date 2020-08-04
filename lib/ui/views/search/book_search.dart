import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/search/search_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

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
          color: Colors.grey[800],
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
              children: <Widget>[
                Container(
                  height: screenHeight(context) / 2.5,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          print('halow');
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
                                color: secondaryColor,
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: model.searchFantasyBooks(query),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Loading Widget
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (index == snapshot.data.length - 1) {
                                      // Next Widget
                                      print('triggered');
                                      return Container(
                                        color: Colors.greenAccent,
                                        child: FlatButton(
                                          child: Text("Load More"),
                                          onPressed: () {},
                                        ),
                                      );
                                    }

                                    // Book Item Widget
                                    return FutureBuilder<Book>(
                                        future: model.getDetailBookFiction(
                                            snapshot.data[index]['url']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            // TODO: waiting shimmering
                                            return _shimmerBookItem(context);
                                          }

                                          if (snapshot.hasData) {
                                            return _fantasyBookItem(
                                              context,
                                              snapshot.data,
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
        viewModelBuilder: () => SearchViewModel());
  }

  Widget _shimmerBookItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.only(left: 8),
        width: screenWidth(context) / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            verticalSpaceSmall,
            Container(
              height: 25,
              color: Colors.white,
            ),
            verticalSpaceTiny,
            Container(
              height: 20,
              width: screenWidth(context) / 4,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fantasyBookItem(BuildContext context, Book book) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      width: screenWidth(context) / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
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
                  width: double.infinity,
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Material(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'EPUB',
                        style: TextStyle(
                            color: secondaryColor, fontWeight: FontWeight.w600),
                      ),
                      color: primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          verticalSpaceSmall,
          Text(
            book.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          verticalSpaceTiny,
          Text(
            book.authors.join(', '),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
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
