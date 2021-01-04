import 'dart:convert';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/models/loginResponse.dart';
import 'package:sacco_app/util/userFetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  User userData;

  Future<LoginResponse> login(data) async {
    print('LOGIN DATA: ' + data.toString());
    var res = await CallApi().postData(data, 'authenticate/get/token');
    print('RESPONSE BODY: ' + res.body);
    //return LoginResponse(false, "Check credentials");
    var body = json.decode(res.body);

    if (res.statusCode != 200) {
      //create res
      LoginResponse resp = LoginResponse(false, "Check credentials");
      return resp;
    }

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', body['jwt']);

    var userToken = localStorage.getString('token');
    print('stored token: ' + userToken);
    var response = await CallApi().getData('profile/user/get');
    var responseJson = jsonDecode(response.body);
    print('Response: ' + response.body);

    localStorage.setString('user', json.encode(responseJson));
    LoginResponse resp = LoginResponse(true, "Login Successful");
    return resp;
    //Authorization: Bearer jwt
  }

  
}
