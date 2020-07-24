import 'package:flutter/material.dart';
import 'package:librebook/ui/views/search/search_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BookSearch extends SearchDelegate<Map<String, dynamic>> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
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
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search for title, author, ISBN';

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: <Widget>[

      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.nonReactive(
      builder: (context, model, _) => query.isNotEmpty
          ? ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    query,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 32),
                  onTap: () {},
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: model.suggestionBooks(query),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data
                              .map(
                                (e) => ListTile(
                                  title: Text(
                                    e['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: e['authors'] != null
                                      ? Text(
                                          e['authors'].join(', '),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : null,
                                  leading: e['authors'] != null
                                      ? Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Icon(Icons.search),
                                  ) : Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 32),
                                  onTap: () {},
                                ),
                              )
                              .take(5)
                              .toList(),
                        );
                      }
                      return Container();
                    }),
              ],
            )
          : Container(),
      viewModelBuilder: () => SearchViewModel(),
    );
  }
}
