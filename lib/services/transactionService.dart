import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchTransaction() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var userToken = localStorage.getString('token');
  print('i am here:'+ userToken);
  final response = await http.get(
    'http://167.99.142.219:5001/transaction/myTransactions',
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $userToken",
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    print('i am here:'+ response.body);
    List<dynamic> transaction = jsonDecode(response.body);
    return transaction;
  } else {
    throw Exception('Failed to load post');
  }
}
