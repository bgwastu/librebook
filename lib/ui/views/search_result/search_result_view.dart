import 'package:flutter/material.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/ui/views/search_result/search_result_general_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SearchResultView extends StatelessWidget {
  final String query;
  final BookSearchDetail firstSearchDetail;

  SearchResultView({
    Key key,
    @required this.query,
    @required this.firstSearchDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchResultGeneralViewModel>.reactive(
      builder: (context, model, _) => Scaffold(
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
          body: LazyLoadRefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index + 1 >= model.listBook.length && model.bookSearchDetail.currentPage < model.bookSearchDetail.lastPage) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: [CircularProgressIndicator()],
                    ),
                  );
                }

                return ListTile(
                  title: Text(model.listBook[index].title),
                  subtitle: Text(model.listBook[index].authors.join(', ')),
                  trailing: Text(
                    model.listBook[index].id,
                  ),
                );
              },
              itemCount: model.listBook.length,
            ),
            onEndOfPage: () => model.loadData(query),
            onRefresh: () => model.onRefreshData(query),
            isLoading: model.isLoading,
          )),
      viewModelBuilder: () => SearchResultGeneralViewModel(),
      onModelReady: (model) => model.setBookSearchDetail(firstSearchDetail),
    );
  }
}
