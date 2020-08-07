import 'package:flutter/material.dart';

class SearchResultGeneralView extends StatelessWidget {
  final String query;
  const SearchResultGeneralView({Key key, @required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('General Books', style: TextStyle(color: Colors.grey[800]),),
        actions: [
          IconButton(icon: Icon(Icons.close), onPressed:() => Navigator.of(context).pop())
        ],
      ),
    );
  }
}