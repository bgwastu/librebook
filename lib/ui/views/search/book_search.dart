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
  String get searchFieldLabel => 'Search for books';

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isNotEmpty ? ViewModelBuilder<SearchViewModel>.nonReactive(
      builder: (context, model, _) => FutureBuilder<List<Map<String, dynamic>>>(
        future: model.findFantasyBooks(query),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.search),
                title: Text(snapshot.data[index]['title'], overflow: TextOverflow.ellipsis,),
              );
            },
          );
          }
          return Container();
        }
      ),
      viewModelBuilder: () => SearchViewModel(),
    ) : Container();
  }
}
