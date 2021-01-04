import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'https://api.qcstaffapp.com/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), 
        headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },);
  }

  postDataHeader(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');

    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), 
        headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        'Content-Type': 'application/json; charset=UTF-8',
      },);
  }

  

  putData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');

    var fullUrl = _url + apiUrl;
    return await http.put(fullUrl,
    headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data));
  }

  getData(apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, 
    headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        'Content-Type': 'application/json; charset=UTF-8',
      },);
  }

  
}
