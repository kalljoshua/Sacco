/*import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {

  void fetchUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');
    var response = await http.get(
      'http://167.99.142.219:8081/profile/user/get',
      headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"},
    );
    var responseJson = jsonDecode(response.body);
    print('Response: ' + response.body);
    setState(() {
      userData = new User.fromJson(responseJson);
      
    });
  }

}*/
