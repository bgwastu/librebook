import 'package:http/http.dart';

class NoInternetException implements Exception {
  final String message = 'No internet access';
}

class ServerException implements Exception {
  String message = 'Can\'t connect to server';

  ServerException({this.message});
}

class SearchNotFoundException implements Exception {}

class ElementNotFound implements Exception {
  final String message = 'Element nof found';
  final Response response;
  int statusCode;
  String body;
  Map<String, String> header;

  ElementNotFound(this.response) {
    statusCode = response.statusCode;
    body = response.body;
    header = response.headers;
  }
}
